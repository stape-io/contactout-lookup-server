const BigQuery = require('BigQuery');
const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeTableMap = require('makeTableMap');
const Object = require('Object');
const sendHttpRequest = require('sendHttpRequest');
const sha256Sync = require('sha256Sync');
const Promise = require('Promise');
const templateDataStorage = require('templateDataStorage');
const makeInteger = require('makeInteger');
const encodeUriComponent = require('encodeUriComponent');

/*==============================================================================
  MAIN EXECUTION
==============================================================================*/

const eventData = getAllEventData();
const apiMethodsMapping = {
  PeopleEnrich: peopleEnrichHandler,
  ContactInfoSingle: contactInfoSingleHandler,
  EmailVerifier: emailVerifierHandler
};

if (handleGuardClauses(eventData)) return; //Early return

const requestBody = handleRequestBody(data, eventData);
const requestConfig = handleRequestConfig(data, eventData);

return sendRequest(requestConfig, requestBody);

/*==============================================================================
 VENDOR RELATED FUNCTIONS
==============================================================================*/

function sendRequest(requestConfig, requestBody) {
  const chosenApi = data.apiSelection;
  const cacheKey = sha256Sync('contactout_' + chosenApi + '_' + requestConfig.url + JSON.stringify(requestBody));
  const cacheKeyTimestamp = cacheKey + '_timestamp';
  const cacheExpirationTimeMillis = data.expirationTime && makeInteger(data.expirationTime) * 60 * 60 * 1000;
  const now = getTimestampMillis();
  const keysToReturn = data.outputKeys ? data.outputKeysList.split(',') : undefined;

  if (data.storeResponse) {
    let cachedValues = templateDataStorage.getItemCopy(cacheKey);
    const cachedValueTimestamp = templateDataStorage.getItemCopy(cacheKeyTimestamp);
    if (data.expirationTime) {
      if (cachedValueTimestamp && now - makeInteger(cachedValueTimestamp) >= cacheExpirationTimeMillis) {
        cachedValues = '';
        templateDataStorage.removeItem(cacheKey);
        templateDataStorage.removeItem(cacheKeyTimestamp);
      }
    }
    if (cachedValues) return Promise.create((resolve) => resolve(JSON.parse(createReturningObject(cachedValues))));
  }

  log({
    Name: 'ContactoutLookup',
    Type: 'Request',
    EventName: chosenApi,
    RequestMethod: requestConfig.options.method,
    RequestUrl: requestConfig.url,
    RequestBody: requestBody
  });
  return sendHttpRequest(requestConfig.url, requestConfig.options, JSON.stringify(requestBody))
    .then((result) => {
      log({
        Name: 'ContactoutLookup',
        Type: 'Response',
        EventName: chosenApi,
        ResponseStatusCode: result.statusCode,
        ResponseHeaders: result.headers,
        ResponseBody: result.body
      });

      if (result.statusCode === 200) {
        const parsedBody = JSON.parse(result.body || '{}');
        if (!parsedBody) return;
        if (data.storeResponse) {
          templateDataStorage.setItemCopy(cacheKey, parsedBody);
          templateDataStorage.setItemCopy(cacheKeyTimestamp, now);
        }
        return createReturningObject(result.body, keysToReturn);
      }
    })
    .catch((result) => {
      log({
        Name: 'ContactoutLookup',
        Type: 'Message',
        EventName: chosenApi,
        Message: 'Request failed or timed out.',
        Reason: JSON.stringify(result)
      });
      return;
    });
}

function createReturningObject(sourceObject, keysToReturn) {
  sourceObject = JSON.parse(sourceObject);
  let returnObject = {};

  if (data.apiSelection === 'EmailVerifier') {
    return sourceObject.data.status;
  }

  if (!keysToReturn) {
    return sourceObject;
  }

  if (getType(keysToReturn) === 'array') {
    log(keysToReturn);
    if (keysToReturn.length === 1) {
      return extractKeyFromObject(keysToReturn[0], sourceObject);
    } else if (keysToReturn.length > 1) {
      returnObject = createNestedObject(sourceObject, keysToReturn);
      return data.objectOutput === 'createFlatObject' ? flattenObject(returnObject) : returnObject;
    }
  }
}

function handleRequestBody(data, eventData) {
  return apiMethodsMapping[data.apiSelection]('body', eventData);
}

function handleRequestConfig(data, eventData) {
  const apiBaseUrl = 'https://api.contactout.com/';
  const apiVersion = 'v1';
  const apiPath = apiMethodsMapping[data.apiSelection]('path');
  const apiQueries = apiMethodsMapping[data.apiSelection]('queries');

  const requestConfig = {
    apiName: data.apiSelection,
    url: apiBaseUrl + apiVersion + apiPath + apiQueries,
    options: {
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        token: data.apiKey
      },
      method: apiMethodsMapping[data.apiSelection]('requestMethod')
    }
  };
  return requestConfig;
}

function peopleEnrichHandler(method) {
  if (method === 'requestMethod') return 'POST';
  if (method === 'path') return '/people/enrich';
  if (method === 'queries') return '';
  if (method === 'body') {
    const primaryParameters = makeTableMap(data.peopleEnrichPrimaryParameters || [], 'key', 'value') || {};
    let nameParameters = makeTableMap(data.peopleEnrichNameParameters || [], 'key', 'value') || {};
    let secondaryParameters = makeTableMap(data.peopleEnrichSecondaryParameters || [], 'key', 'value') || {};
    let includeParameters = data.peopleEnrichIncludeParameters ? { include: data.peopleEnrichIncludeParameters.map((o) => o.key) } : undefined;

    nameParameters = nameParameters.first_name && nameParameters.last_name ? nameParameters : {};

    Object.entries(secondaryParameters).forEach((entry) => {
      const key = entry[0];
      const value = entry[1];
      if (key.match('education|company|company_domain') && getType(value) === 'string') {
        secondaryParameters[key] = value.split(',').map((param) => param.trim());
      }
    });

    return mergeObjects(primaryParameters, nameParameters, secondaryParameters, includeParameters);
  }
}

function contactInfoSingleHandler(method) {
  let queriesUrl = '/?';
  const queries = {
    profile: data.linkedinProfile,
    email_type: data.emailType,
    include_phone: data.includePhone
  };
  if (method === 'requestMethod') return 'GET';
  if (method === 'path') return '/people/linkedin';
  if (method === 'queries') {
    for (let key in queries) {
      if (queries[key]) queriesUrl += key + '=' + encodeUriComponent(queries[key]) + '&';
    }
    return queriesUrl;
  }
  if (method === 'body') return undefined;
}

function emailVerifierHandler(method) {
  const email = data.email;
  if (method === 'requestMethod') return 'GET';
  if (method === 'path') return '/email/verify';
  if (method === 'queries') return '?' + 'email=' + encodeUriComponent(email);
  if (method === 'body') return undefined;
}
/*==============================================================================
  Helpers
==============================================================================*/

function handleGuardClauses(eventData) {
  const url = eventData.page_location || getRequestHeader('referer');

  if (url && url.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return true;

  if (data.apiSelection === 'PeopleEnrich') {
    if (!data.peopleEnrichPrimaryParameters && !data.peopleEnrichNameParameters) {
      log({
        Name: 'ContactoutLookup',
        Type: 'Message',
        EventName: 'PeopleEnrich',
        Message: 'Request failed or timed out.',
        Reason: 'Wrong combination of required parameters for People Enrich API Lookup'
      });
      return true;
    }
  }
}

function flattenObject(ob) {
  const toReturn = {};

  for (let i in ob) {
    if (!ob.hasOwnProperty(i)) continue;

    if (['object', 'array'].indexOf(getType(ob[i])) !== -1) {
      const flatObject = flattenObject(ob[i]);
      for (let x in flatObject) {
        if (!flatObject.hasOwnProperty(x)) continue;
        toReturn[i + '_' + x] = flatObject[x];
      }
    } else {
      toReturn[i] = ob[i];
    }
  }

  return toReturn;
}

function createNestedObject(source, paths) {
  const result = {};

  paths.forEach((path) => {
    const keys = path.trim().split('.');
    let srcPtr = source;
    let resPtr = result;

    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];

      if (!srcPtr || !srcPtr[key]) return;

      const isLastKey = i === keys.length - 1;
      if (isLastKey) {
        resPtr[key] = srcPtr[key];
      } else {
        if (getType(resPtr[key]) === 'undefined') {
          resPtr[key] = getType(srcPtr[key]) === 'array' ? [] : {};
        }
        srcPtr = srcPtr[key];
        resPtr = resPtr[key];
      }
    }
  });

  return result;
}

function extractKeyFromObject(keyPath, sourceObject) {
  const keys = keyPath.split('.');
  return keys.reduce((object, key) => {
    if (sourceObject === undefined) return undefined;
    if (object.hasOwnProperty(key)) return object[key];
    return undefined;
  }, sourceObject);
}

function mergeObjects() {
  const objectToReturn = {};
  if (getType(arguments) === 'array' && arguments.length) {
    arguments.forEach((object) => {
      if (getType(object) === 'object') {
        for (let key in object) {
          objectToReturn[key] = object[key];
        }
      }
    });
  }
  return objectToReturn;
}

function log(rawDataToLog) {
  const logDestinationsHandlers = {};
  if (determinateIsLoggingEnabled()) logDestinationsHandlers.console = logConsole;
  if (determinateIsLoggingEnabledForBigQuery()) logDestinationsHandlers.bigQuery = logToBigQuery;

  rawDataToLog.TraceId = getRequestHeader('trace-id');

  const keyMappings = {
    // No transformation for Console is needed.
    bigQuery: {
      Name: 'tag_name',
      Type: 'type',
      TraceId: 'trace_id',
      EventName: 'event_name',
      RequestMethod: 'request_method',
      RequestUrl: 'request_url',
      RequestBody: 'request_body',
      ResponseStatusCode: 'response_status_code',
      ResponseHeaders: 'response_headers',
      ResponseBody: 'response_body'
    }
  };

  for (const logDestination in logDestinationsHandlers) {
    const handler = logDestinationsHandlers[logDestination];
    if (!handler) continue;

    const mapping = keyMappings[logDestination];
    const dataToLog = mapping ? {} : rawDataToLog;

    if (mapping) {
      for (const key in rawDataToLog) {
        const mappedKey = mapping[key] || key;
        dataToLog[mappedKey] = rawDataToLog[key];
      }
    }

    handler(dataToLog);
  }
}

function logConsole(dataToLog) {
  logToConsole(JSON.stringify(dataToLog));
}

function logToBigQuery(dataToLog) {
  const connectionInfo = {
    projectId: data.logBigQueryProjectId,
    datasetId: data.logBigQueryDatasetId,
    tableId: data.logBigQueryTableId
  };

  dataToLog.timestamp = getTimestampMillis();

  ['request_body', 'response_headers', 'response_body'].forEach((p) => {
    dataToLog[p] = JSON.stringify(dataToLog[p]);
  });

  BigQuery.insert(connectionInfo, [dataToLog], { ignoreUnknownValues: true });
}

function determinateIsLoggingEnabled() {
  const containerVersion = getContainerVersion();
  const isDebug = !!(containerVersion && (containerVersion.debugMode || containerVersion.previewMode));

  if (!data.logType) {
    return isDebug;
  }

  if (data.logType === 'no') {
    return false;
  }

  if (data.logType === 'debug') {
    return isDebug;
  }

  return data.logType === 'always';
}

function determinateIsLoggingEnabledForBigQuery() {
  if (data.bigQueryLogType === 'no') return false;
  return data.bigQueryLogType === 'always';
}
