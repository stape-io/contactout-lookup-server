___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Contactout Lookup Variable",
  "description": "Variable that returns contact information from Contactout API. It currently supports:\n - People Enrich API;\n - Contact Info Single API;\n - Email Verifier API;",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "configGroup",
    "displayName": "API Lookup Configuration",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "apiSelection",
        "displayName": "Choose Contactout API",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "ContactInfoSingle",
            "displayValue": "Contact Info - Single"
          },
          {
            "value": "PeopleEnrich",
            "displayValue": "People Enrich"
          },
          {
            "value": "EmailVerifier",
            "displayValue": "Email Verifier"
          }
        ],
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "You can find all Contactout APIs references \u003ca href\u003d\"https://api.contactout.com/\"\u003e here \u003c/a\u003e. Bear in mind that not all of them are currently supported here."
      },
      {
        "type": "TEXT",
        "name": "apiKey",
        "displayName": "API Key",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "You can find you API Key in the upper right corner of your \u003ca href\u003d\"https://contactout.com/api-dashboard\"\u003e API Dashboard \u003c/a\u003e"
      },
      {
        "type": "CHECKBOX",
        "name": "storeResponse",
        "checkboxText": "Store response in cache",
        "simpleValueType": true,
        "help": "Store the response in Template Storage. If all parameters of the request are the same response will be taken from the cache if it exists. Defaults to \u003cb\u003eenabled\u003c/b\u003e",
        "subParams": [
          {
            "type": "TEXT",
            "name": "expirationTime",
            "displayName": "Cache Expiration Time (Hours)",
            "simpleValueType": true,
            "help": "Will update cache if data is expired.",
            "enablingConditions": [
              {
                "paramName": "storeResponse",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "POSITIVE_NUMBER"
              },
              {
                "type": "NON_EMPTY"
              }
            ],
            "defaultValue": 12
          }
        ],
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "outputKeys",
        "checkboxText": "Extract keys from returned JSON object",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "apiSelection",
            "paramValue": "EmailVerifier",
            "type": "NOT_EQUALS"
          }
        ],
        "subParams": [
          {
            "type": "TEXT",
            "name": "outputKeysList",
            "displayName": "Key Names",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "outputKeys",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "help": "",
            "valueHint": "foo.0.bar, email, work_email.0"
          },
          {
            "type": "RADIO",
            "name": "objectOutput",
            "displayName": "Output object structure",
            "radioItems": [
              {
                "value": "createFlatObject",
                "displayValue": "Create one-level deep (flat) object."
              },
              {
                "value": "createNestedObject",
                "displayValue": "Create nested object."
              }
            ],
            "simpleValueType": true,
            "help": "If you want some nested key to persist in the same nested position as the source object, mark \u003cb\u003eCreate Nested Object\u003c/b\u003e, otherwise it will return a flat object",
            "enablingConditions": [
              {
                "paramName": "outputKeys",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "defaultValue": "createFlatObject"
          }
        ],
        "help": "Limit the returning object by choosing one or more specific keys you want to extract. \u003c/br\u003e \nIf needed to extract nested values, use dot notation. \u003c/br\u003e(e.g. \u003ci\u003efoo.id\u003c/i\u003e, \u003ci\u003ebar.0.price\u003c/i\u003e).\u003c/br\u003e\nIf multiple keys are listed, they will be returned in a key/value JSON format.\n\u003cb\u003eSeparate the keys/paths by comma.\u003c/b\u003e"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "contactInfoSingleAPIGroup",
    "displayName": "Contact Info Single Lookup Configuration",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "helpContactInfoSingle",
        "displayName": "Returns a user data object from a LinkedIn profile as specified in the  \u003ca href\u003d\"https://api.contactout.com/#contact-info-api-single\"\u003e documentation \u003c/a\u003e.\u003c/br\u003e"
      },
      {
        "type": "TEXT",
        "name": "linkedinProfile",
        "displayName": "Linkedin Profile",
        "simpleValueType": true,
        "help": "The fully formed URL of the LinkedIn profile. URL must begin with \u003ci\u003ehttp\u003c/i\u003e and must contain \u003cb\u003elinkedin.com/in/\u003c/b\u003e or \u003cb\u003elinkedin.com/pub/\u003c/b\u003e \u003c/br\u003e\n(E.g. \"https://www.linkedin.com/in/jane-doe-18951158\")",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          },
          {
            "type": "REGEX",
            "args": [
              "(https?).*linkedin.*\\/(in|pub)\\/.+"
            ]
          }
        ]
      },
      {
        "type": "SELECT",
        "name": "emailType",
        "displayName": "Email Type",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "personal_email",
            "displayValue": "Personal Email"
          },
          {
            "value": "work_email",
            "displayValue": "Work Email"
          },
          {
            "value": "none",
            "displayValue": "None"
          }
        ],
        "simpleValueType": true,
        "help": "Choose which type of e-mail address you want in the response. Defaults to both work \u003cb\u003eAND\u003c/b\u003e personal.",
        "notSetText": "Both Personal and Work Emails"
      },
      {
        "type": "CHECKBOX",
        "name": "includePhone",
        "checkboxText": "Include Phone",
        "simpleValueType": true,
        "help": "If you check this box it will include phone information in the response and deduct phone credits."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "apiSelection",
        "paramValue": "ContactInfoSingle",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "emailVerifierAPIGroup",
    "displayName": "Email Verifier Lookup Configuration",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "helpEmailVerifier",
        "displayName": "Verifies the deliverability of an email address as specified in the  \u003ca href\u003d\"https://api.contactout.com/#email-verifier-api\"\u003e documentation \u003c/a\u003e."
      },
      {
        "type": "TEXT",
        "name": "email",
        "displayName": "Email Address",
        "simpleValueType": true,
        "help": "Email address string to check for deliverability.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "apiSelection",
        "paramValue": "EmailVerifier",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "peopleEnrichAPIGroup",
    "displayName": "People Enrich API",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "helpPeopleEnrich",
        "displayName": "Returns a user data object as described in the \u003ca href\u003d\"https://api.contactout.com/#people-enrich-request-parameters\"\u003e documentation \u003c/a\u003e.\u003c/br\u003e"
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "peopleEnrichPrimaryParameters",
        "displayName": "Primary Parameters",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Parameter Name",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "linkedin_url",
                "displayValue": "Linkedin Profile URL"
              },
              {
                "value": "email",
                "displayValue": "Email Address"
              },
              {
                "value": "phone",
                "displayValue": "Phone Number"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "isUnique": true
          },
          {
            "defaultValue": "",
            "displayName": "Parameter Value",
            "name": "value",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "newRowButtonText": "Add Parameter",
        "valueValidators": []
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "peopleEnrichNameParameters",
        "displayName": "Name Parameters",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Parameter Name",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "full_name",
                "displayValue": "Full Name"
              },
              {
                "value": "first_name",
                "displayValue": "First Name"
              },
              {
                "value": "last_name",
                "displayValue": "Last Name"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "isUnique": true
          },
          {
            "defaultValue": "",
            "displayName": "Parameter Value",
            "name": "value",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "valueHint": ""
          }
        ],
        "newRowButtonText": "Add Parameter",
        "help": "If setting either \u003cb\u003eFirst Name\u003c/b\u003e or \u003cb\u003e Last Name \u003c/b\u003e, both must be set, otherwise it will be discarded on lookup filtering."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "peopleEnrichSecondaryParameters",
        "displayName": "Secondary Parameters",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Parameter Name",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "company",
                "displayValue": "Company"
              },
              {
                "value": "company_domain",
                "displayValue": "Company Domain"
              },
              {
                "value": "education",
                "displayValue": "Education"
              },
              {
                "value": "location",
                "displayValue": "Location"
              },
              {
                "value": "job_title",
                "displayValue": "Job Title"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "isUnique": true
          },
          {
            "defaultValue": "",
            "displayName": "Parameter Value",
            "name": "value",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "newRowButtonText": "Add Parameter"
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "peopleEnrichIncludeParameters",
        "displayName": "Include Parameter in Response",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Parameter",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "work_email",
                "displayValue": "Work Email"
              },
              {
                "value": "personal_email",
                "displayValue": "Personal Email"
              },
              {
                "value": "phone",
                "displayValue": "Phone"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "isUnique": true
          }
        ],
        "newRowButtonText": "Add Parameter",
        "help": "By default this API does not retrieve \u003cb\u003ephone\u003c/b\u003e, \u003cb\u003epersonal_email\u003c/b\u003e or \u003cb\u003ework_email\u003c/b\u003e. To get these values on the response, add them here."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "apiSelection",
        "paramValue": "PeopleEnrich",
        "type": "EQUALS"
      }
    ]
  },
  {
    "displayName": "Logs Settings",
    "name": "logsGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "RADIO",
        "name": "logType",
        "radioItems": [
          {
            "value": "no",
            "displayValue": "Do not log"
          },
          {
            "value": "debug",
            "displayValue": "Log to console during debug and preview"
          },
          {
            "value": "always",
            "displayValue": "Always log to console"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "debug"
      }
    ]
  },
  {
    "displayName": "BigQuery Logs Settings",
    "name": "bigQueryLogsGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "RADIO",
        "name": "bigQueryLogType",
        "radioItems": [
          {
            "value": "no",
            "displayValue": "Do not log to BigQuery"
          },
          {
            "value": "always",
            "displayValue": "Log to BigQuery"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "no"
      },
      {
        "type": "GROUP",
        "name": "logsBigQueryConfigGroup",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "TEXT",
            "name": "logBigQueryProjectId",
            "displayName": "BigQuery Project ID",
            "simpleValueType": true,
            "help": "Optional.  \u003cbr\u003e\u003cbr\u003e  If omitted, it will be retrieved from the environment variable \u003cI\u003eGOOGLE_CLOUD_PROJECT\u003c/i\u003e where the server container is running. If the server container is running on Google Cloud, \u003cI\u003eGOOGLE_CLOUD_PROJECT\u003c/i\u003e will already be set to the Google Cloud project\u0027s ID."
          },
          {
            "type": "TEXT",
            "name": "logBigQueryDatasetId",
            "displayName": "BigQuery Dataset ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "TEXT",
            "name": "logBigQueryTableId",
            "displayName": "BigQuery Table ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "bigQueryLogType",
            "paramValue": "always",
            "type": "EQUALS"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_bigquery",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedTables",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "projectId"
                  },
                  {
                    "type": 1,
                    "string": "datasetId"
                  },
                  {
                    "type": 1,
                    "string": "tableId"
                  },
                  {
                    "type": 1,
                    "string": "operation"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___

Created on 01/12/2025, 09:40:50


