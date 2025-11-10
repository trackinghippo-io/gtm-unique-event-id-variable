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
  "displayName": "Unique Event ID by TrackingHippo.io",
  "description": "Generates a persistent unique event ID that is stored in localStorage and available via gtm.uniqueEventId. The ID is generated once per browser and reused across sessions.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "CHECKBOX",
    "name": "setGtmProperty",
    "checkboxText": "Set gtm.uniqueEventId property",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "If checked, sets the unique event ID to gtm.uniqueEventId in the dataLayer."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const localStorage = require('localStorage');
const generateRandom = require('generateRandom');
const createQueue = require('createQueue');

// Get the storage key from template parameters
const storageKey = 'gtm_unique_event_id';

// Try to get existing ID from localStorage
let uniqueId = localStorage.getItem(storageKey);

// If no ID exists, generate a new one
if (!uniqueId) {
  // Generate a unique ID using timestamp and random number
  const timestamp = require('getTimestampMillis')();
  const randomNum = generateRandom(100000, 999999);
  uniqueId = timestamp + '-' + randomNum;

  // Store it in localStorage
  localStorage.setItem(storageKey, uniqueId);
}

// If the user wants to set gtm.uniqueEventId, push to dataLayer
if (data.setGtmProperty) {
  const dataLayerPush = createQueue('dataLayer');
  dataLayerPush({
    'gtm.uniqueEventId': uniqueId
  });
}

// Return the unique ID
return uniqueId;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
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
        "publicId": "access_local_storage",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gtm_unique_event_id"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
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
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 11/11/2025, 00:56:03