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
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "configGroup",
    "displayName": "",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "apiSelection",
        "displayName": "Choose Contactout API",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "contactInfoSingle",
            "displayValue": "Contact Info - Single"
          },
          {
            "value": "peopleEnrich",
            "displayValue": "People Enrich"
          },
          {
            "value": "emailVerifier",
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
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "useOptimisticScenario",
        "checkboxText": "Use Optimistic Scenario?",
        "simpleValueType": true,
        "help": "The tag will call gtmOnSuccess() without waiting for a response from the API. This will speed up sGTM response time however your tag will always return the status fired successfully even in case it is not.",
        "subParams": []
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "contactInfoSingleAPIGroup",
    "displayName": "Contact Info Single Lookup Configuration",
    "groupStyle": "NO_ZIPPY",
    "subParams": [],
    "enablingConditions": [
      {
        "paramName": "apiSelection",
        "paramValue": "contactInfoSingle",
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
        "type": "SIMPLE_TABLE",
        "name": "peopleEnrichPrimaryParameters",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Primary Parameters",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "linkedinUrl",
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
            "displayName": "Value",
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
        "displayName": "Help",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Name Parameters",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "fullname",
                "displayValue": "Full Name"
              },
              {
                "value": "firstname",
                "displayValue": "First Name"
              },
              {
                "value": "phone",
                "displayValue": "lastname"
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
            "displayName": "Value",
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
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Secondary Paremeters",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "company",
                "displayValue": "Company"
              },
              {
                "value": "companyDomains",
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
                "value": "jobTitle",
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
            "displayName": "Value",
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
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Data to be included on response",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "workEmail",
                "displayValue": "Work Email"
              },
              {
                "value": "personalEmail",
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
        "newRowButtonText": "Add Parameter"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "apiSelection",
        "paramValue": "peopleEnrich",
        "type": "EQUALS"
      }
    ],
    "help": "Returns a user data object as described in the \u003ca href\u003d\"https://api.contactout.com/#people-enrich-request-parameters\"\u003e documentation \u003c/a\u003e.\u003c/br\u003e \nIn order to return a match, is required:\u003cbr\u003e\n\u003cul\u003e \n\u003cli\u003e One primary identifier (Linkedin URL, Email or Phone)\u003c/li\u003e\n\u003cb\u003eOR\u003c/b\u003e\n\u003cli\u003e A combination of \u003cb\u003eName\u003c/b\u003e and at least a secondary parameter (Company, Location, Education, etc.)\u003c/li\u003e\u003cbr\u003e\n\u003c/ul\u003e\nObs: A \u003cb\u003eName\u003c/b\u003e must be either a Full Name or a combination of First Name and Last Name."
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
const encodeUriComponent = require('encodeUriComponent');
const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeString = require('makeString');
const Object = require('Object');
const sendHttpRequest = require('sendHttpRequest');
const sha256Sync = require('sha256Sync');

/*==============================================================================
==============================================================================*/

const eventData = getAllEventData();
const useOptimisticScenario = data.useOptimisticScenario;
const url = eventData.page_location || getRequestHeader('referer');
const postBody = {};
const queries = [];
let requestConfig = {};

if (!isConsentGivenOrNotRequired(data, eventData)) {
  return data.gtmOnSuccess();
}

if (url && url.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) {
  return data.gtmOnSuccess();
}

sendRequest(requestConfig, postBody, queries);

if (useOptimisticScenario) {
  return data.gtmOnSuccess();
}

/*==============================================================================
  Vendor Related Functions
==============================================================================*/

function normalizePhoneNumber(phoneNumber) {
  if (!phoneNumber) return phoneNumber;

  phoneNumber = phoneNumber.split(' ').join('').split('-').join('').split('(').join('').split(')').join('');

  if (phoneNumber[0] !== '+') phoneNumber = '+' + phoneNumber;
  return phoneNumber;
}

function sendRequest(requestConfig, postBody, queries) {
  log({
    Name: 'ContactoutLookup',
    Type: 'Request',
    EventName: 'API_' + requestConfig.apiName.toUpperCase() + '_LOOKUP',
    RequestMethod: 'POST',
    RequestUrl: requestConfig.url,
    RequestBody: postBody
  });

  return sendHttpRequest(requestConfig.url, requestConfig.options, JSON.stringify(postBody))
    .then((result) => {
      // .then has to be used when the Authorization header is in use
      log({
        Name: 'ContactoutLookup',
        Type: 'Response',
        EventName: 'API_' + requestConfig.apiName.toUpperCase() + '_LOOKUP',
        ResponseStatusCode: result.statusCode,
        ResponseHeaders: result.headers,
        ResponseBody: result.body
      });

      if (!useOptimisticScenario) {
        if (result.statusCode >= 200 && result.statusCode < 400) {
          data.gtmOnSuccess();
        } else {
          data.gtmOnFailure();
        }
      }
    })
    .catch((result) => {
      log({
        Name: 'ContactoutLookup',
        Type: 'Message',
        EventName: 'API_' + requestConfig.apiName.toUpperCase() + '_LOOKUP',
        Message: 'Request failed or timed out.',
        Reason: JSON.stringify(result)
      });

      if (!useOptimisticScenario) data.gtmOnFailure();
    });
}

/*==============================================================================
  Helpers
==============================================================================*/

function enc(data) {
  return encodeUriComponent(makeString(data || ''));
}

function isSHA256Base64Hashed(value) {
  if (!value) return false;
  const valueStr = makeString(value);
  const base64Regex = '^[A-Za-z0-9+/]{43}=?$';
  return valueStr.match(base64Regex) !== null;
}

function isSHA256HexHashed(value) {
  if (!value) return false;
  const valueStr = makeString(value);
  const hexRegex = '^[A-Fa-f0-9]{64}$';
  return valueStr.match(hexRegex) !== null;
}

function hashData(value) {
  if (!value) return value;

  const type = getType(value);

  if (value === 'undefined' || value === 'null') return undefined;

  if (type === 'array') {
    return value.map((val) => hashData(val));
  }

  if (type === 'object') {
    return Object.keys(value).reduce((acc, val) => {
      acc[val] = hashData(value[val]);
      return acc;
    }, {});
  }

  if (isSHA256HexHashed(value) || isSHA256Base64Hashed(value)) return value;

  return sha256Sync(makeString(value).trim().toLowerCase(), {
    outputEncoding: 'hex'
  });
}

function isValidValue(value) {
  const valueType = getType(value);
  return valueType !== 'null' && valueType !== 'undefined' && value !== '';
}

function isConsentGivenOrNotRequired(data, eventData) {
  if (data.adStorageConsent !== 'required') return true;
  if (eventData.consent_state) return !!eventData.consent_state.ad_storage;
  const xGaGcs = eventData['x-ga-gcs'] || ''; // x-ga-gcs is a string like "G110"
  return xGaGcs[2] === '1';
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
            "string": "debug"
          }
        }
      ]
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
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 11/11/2025, 15:04:03


