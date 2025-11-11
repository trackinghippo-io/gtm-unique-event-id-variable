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
  "description": "Generates a unique event ID per pageload that is stored in the GTM dataLayer and available via gtm.uniqueEventId. The ID is generated once per page load.",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "UTILITY"
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

const generateRandom = require('generateRandom');
const createQueue = require('createQueue');
const copyFromDataLayer = require('copyFromDataLayer');
const getTimestampMillis = require('getTimestampMillis');

// Check if ID already exists in dataLayer for this pageload
// Only reuse if it's a valid string with the expected format
let uniqueId = copyFromDataLayer('gtm.uniqueEventId');

// Validate the existing ID - must be a string with the timestamp-random-random format
const isValidId = uniqueId && typeof uniqueId === 'string' && uniqueId.indexOf('-') > 0;

// If no valid ID exists, generate a new one
if (!isValidId) {
  // Generate a globally unique ID using timestamp and multiple random numbers
  const timestamp = getTimestampMillis();
  const randomNum1 = generateRandom(100000, 999999);
  const randomNum2 = generateRandom(100000, 999999);
  uniqueId = timestamp + '-' + randomNum1 + '-' + randomNum2;

  // Push to dataLayer to store for this pageload
  const dataLayerPush = createQueue('dataLayer');
  dataLayerPush({
    'gtm.uniqueEventId': uniqueId
  });
} else if (data.setGtmProperty) {
  // If valid ID exists and user wants to ensure it's set, push to dataLayer
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
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "gtm.uniqueEventId"
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