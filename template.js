const BigQuery = require('BigQuery');
const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeString = require('makeString');
const makeTableMap = require('makeTableMap');
const Object = require('Object');
const sendHttpRequest = require('sendHttpRequest');
const sha256Sync = require('sha256Sync');
const Promise = require('Promise');
const templateDataStorage = require('templateDataStorage');
const makeInteger = require('makeInteger');

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
  const cacheKey = sha256Sync('contactout_' + chosenApi + '_' + JSON.stringify(requestBody));
  const cacheKeyTimestamp = cacheKey + '_timestamp';
  const cacheExpirationTimeMillis = data.expirationTime && makeInteger(data.expirationTime) * 60 * 60 * 1000;
  const now = getTimestampMillis();
  const keysToReturn = data.outputKeys ? data.outputKeysList.split(',') : 'fullObject';
  let returnBody = {};

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
    if (cachedValues) return Promise.create((resolve) => resolve(cachedValues));
  }

  log({
    Name: 'ContactoutLookup',
    Type: 'Request',
    EventName: requestConfig.apiName + 'Api_' + 'Lookup',
    RequestMethod: requestConfig.options.method,
    RequestUrl: requestConfig.url,
    RequestBody: requestBody
  });

  return sendHttpRequest(requestConfig.url, requestConfig.options, JSON.stringify(requestBody))
    .then((result) => {
      log({
        Name: 'ContactoutLookup',
        Type: 'Response',
        EventName: requestConfig.apiName + 'Api_' + 'Lookup',
        ResponseStatusCode: result.statusCode,
        ResponseHeaders: result.headers,
        ResponseBody: result.body
      });

      if (makeString(result.statusCode) === '200' && result.body) {
        if (data.storeResponse) {
          log(result.body);
          templateDataStorage.setItemCopy(cacheKey, result.body);
          templateDataStorage.setItemCopy(cacheKeyTimestamp, now);
        }

        return createReturningObject(result.body, keysToReturn);
      }
    })
    .catch((result) => {
      log({
        Name: 'ContactoutLookup',
        Type: 'Message',
        EventName: requestConfig.apiName + 'Api_' + 'Lookup',
        Message: 'Request failed or timed out.',
        Reason: JSON.stringify(result)
      });
      return;
    });
}

function createReturningObject(sourceObject, keysToReturn) {
  let returnObject = {};
  const isSingleKey = getType(keysToReturn) === 'array' && keysToReturn.length === 1;

  if (data.apiSelection === 'email_verifier') {
    return JSON.parse(sourceObject).data.status;
  }

  if (keysToReturn === 'fullObject') {
    return JSON.parse(sourceObject);
  }

  if (getType(keysToReturn) === 'array' && keysToReturn.length) {
    keysToReturn = keysToReturn.map((key) => key.trim());
    keysToReturn.forEach((keyPath) => {
      const splitKeyPath = keyPath.split('.');
      const lastKeyPathNamespace = splitKeyPath[splitKeyPath.length - 1].match('^[0-9]*$') ? splitKeyPath[splitKeyPath.length - 2] : splitKeyPath[splitKeyPath.length - 1];

      if (data.objectOutput === 'createFlatObject') {
        returnObject[lastKeyPathNamespace] = extractKeyFromObject(keyPath, JSON.parse(sourceObject));
      }

      if (data.objectOutput === 'createNestedObject') {
        returnObject = createNestedObject(returnObject, keyPath, extractKeyFromObject(keyPath, JSON.parse(sourceObject)));
      }
    });
  }
  return isSingleKey ? extractKeyFromObject(keysToReturn[0], JSON.parse(sourceObject)) : returnObject;
}

function handleRequestBody(data, eventData) {
  return apiMethodsMapping[data.apiSelection]('body', eventData);
}

function handleRequestConfig(data, eventData) {
  const apiBaseUrl = 'https://api.contactout.com/';
  const apiVersion = 'v1';
  const apiPath = apiMethodsMapping[data.apiSelection]('path');
  const apiQueries = apiMethodsMapping[data.apiSelection]('queries');
  const apiNameMapping = {
    PeopleEnrich: 'PEOPLE_ENRICH',
    ContactInfoSingle: 'CONTACT_INFO_SINGLE',
    EmailVerifier: 'EMAIL_VERIFIER'
  };
  const requestConfig = {
    apiName: apiNameMapping[data.apiSelection],
    url: apiBaseUrl + apiVersion + apiPath + apiQueries,
    options: {
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        token: data.apiKey
      },
      method: apiMethodsMapping[data.apiSelection]('requestMethod'),
      timeout: 15000
    }
  };
  return requestConfig;
}

function peopleEnrichHandler(method) {
  if (method === 'requestMethod') return 'POST';
  if (method === 'path') return '/people/enrich';
  if (method === 'queries') return '';
  if (method === 'body') {
    const primaryParameters = data.peopleEnrichPrimaryParameters ? makeTableMap(data.peopleEnrichPrimaryParameters, 'key', 'value') : {};
    let nameParameters = data.peopleEnrichNameParameters ? makeTableMap(data.peopleEnrichNameParameters, 'key', 'value') : {};
    let secondaryParameters = data.peopleEnrichSecondaryParameters ? makeTableMap(data.peopleEnrichSecondaryParameters, 'key', 'value') : {};
    let includeParameters = data.peopleEnrichIncludeParameters ? { include: Object.values(data.peopleEnrichIncludeParameters) } : [];
    let secondaryObject = {};

    nameParameters = !!(nameParameters.first_name && nameParameters.last_name) === false ? {} : nameParameters;

    Object.entries(secondaryParameters).forEach((parameter) => {
      if (parameter[0].match('education|company|company_domain') && getType(parameter[1]) === 'string') {
        parameter[1] = parameter[1].split(',').map((param) => param.trim());
        secondaryObject[parameter[0]] = parameter[1];
      }
      return secondaryObject;
    });

    if (getType(includeParameters.include) === 'array') {
      includeParameters.include = includeParameters.include.map((parameter) => parameter.key);
    }
    return mergeObjects(primaryParameters, nameParameters, secondaryObject, includeParameters);
  }
}

function contactInfoSingleHandler(method) {
  const profile = data.linkedinProfile;
  const emailType = data.emailType;
  const includePhone = data.includePhone;
  if (method === 'requestMethod') return 'GET';
  if (method === 'path') return '/people/linkedin';
  if (method === 'queries') {
    return '/?' + 'profile=' + profile + '&email_type=' + emailType + '&include_phone=' + includePhone;
  }
  if (method === 'body') return undefined;
}

function emailVerifierHandler(method) {
  const email = data.email;
  if (method === 'requestMethod') return 'GET';
  if (method === 'path') return '/email/verify';
  if (method === 'queries') return '?' + 'email=' + email;
  if (method === 'body') return undefined;
}
/*==============================================================================
  Helpers
==============================================================================*/

function handleGuardClauses(eventData) {
  const url = eventData.page_location || getRequestHeader('referer');

  if (url && url.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return true;

  if (data.apiSelection === 'people_enrich') {
    if (!data.peopleEnrichPrimaryParameters && !data.peopleEnrichNameParameters) return true;
  }
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

function createNestedObject(obj, path, value) {
  const parts = path.split('.');
  let current = obj;

  for (let i = 0; i < parts.length; i++) {
    const part = parts[i];
    const isArrayIndex = part.match('^[0-9]+$');
    const key = isArrayIndex ? makeInteger(part) : part;

    if (i === parts.length - 1) {
      current[key] = value;
      break;
    }

    if (isArrayIndex) {
      let nextStructure = current[key];

      if (!nextStructure) {
        const nextPart = parts[i + 1];
        const isNextArrayIndex = nextPart.match('^[0-9]+$');

        if (isNextArrayIndex) {
          nextStructure = [];
        } else {
          nextStructure = {};
        }
        current[key] = nextStructure;
      }

      current = current[key];
      continue;
    }

    if (!current[key] || typeof current[key] !== 'object') {
      const nextPart = parts[i + 1];
      const isNextArrayIndex = nextPart.match('^[0-9]+$');

      if (isArrayIndex || isNextArrayIndex) {
        current[key] = [];
      } else {
        current[key] = {};
      }
    }
    current = current[key];
  }

  return obj;
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
