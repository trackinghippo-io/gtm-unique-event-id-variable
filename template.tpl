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

const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');
const createQueue = require('createQueue');
const generateRandom = require('generateRandom');
const getTimestampMillis = require('getTimestampMillis');

const GLOBAL_CACHE_KEY = '__th_unique_page_id';

/**
 * Generates a pseudo-UUID v4.
 * Uses timestamp and random components to ensure high collision resistance.
 * Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
 */
const generateUUID = () => {
  const timestamp = getTimestampMillis();
  
  // Helper to generate a random hex string of length n
  const hex = (len) => {
    let s = '';
    const chars = '0123456789abcdef';
    for (let i = 0; i < len; i++) {
        const r = generateRandom(0, 15);
        s += chars.charAt(r);
    }
    return s;
  };

  // Incorporate timestamp into the first block (8 chars)
  // detailed timestamp allows for chronological sorting if needed
  const timeHex = timestamp.toString(16).padStart(12, '0').slice(-8);
  
  return (
    timeHex + '-' +
    hex(4) + '-' +
    '4' + hex(3) + '-' + // Version 4 identifier
    hex(4) + '-' +       // Variant
    hex(12)
  );
};

// 1. Try to get from Window Cache (Fastest, Synchronous, Stable)
// This prevents race conditions where multiple variable references 
// generate different IDs before the DataLayer updates.
let uniqueId = copyFromWindow(GLOBAL_CACHE_KEY);

if (!uniqueId) {
  // 2. Generate New ID
  uniqueId = generateUUID();
  
  // 3. Cache immediately to Window
  setInWindow(GLOBAL_CACHE_KEY, uniqueId);
  
  // 4. Optional: Push to DataLayer (Asynchronous Side Effect)
  if (data.setGtmProperty) {
     const dataLayerPush = createQueue('dataLayer');
     dataLayerPush({
       'gtm.uniqueEventId': uniqueId
     });
  }
}

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
              },
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
                    "string": "__th_unique_page_id"
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
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 11/11/2025, 00:56:03