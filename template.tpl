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
  "description": "Generates a unique event ID per dataLayer event. Combines a per-pageload UUID with GTM's built-in event counter, so every event instance gets its own ID while all tags firing on the same event resolve the same value (required for browser/server deduplication, e.g. Meta event_id).",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "UTILITY"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');
const copyFromDataLayer = require('copyFromDataLayer');
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

  // Incorporate timestamp into the first block (8 chars) so IDs sort
  // chronologically. Manual padding for compatibility (no padStart).
  let timeHex = timestamp.toString(16);
  while (timeHex.length < 8) {
    timeHex = '0' + timeHex;
  }
  timeHex = timeHex.slice(-8);

  return (
    timeHex + '-' +
    hex(4) + '-' +
    '4' + hex(3) + '-' + // Version 4 identifier
    hex(4) + '-' +       // Variant
    hex(12)
  );
};

// Stable per-pageload base ID, cached on window so every reference of this
// variable resolves the same base even when multiple tags evaluate it
// simultaneously (zero race conditions).
let pageId = copyFromWindow(GLOBAL_CACHE_KEY);

if (!pageId) {
  pageId = generateUUID();
  setInWindow(GLOBAL_CACHE_KEY, pageId);
}

// GTM assigns an incrementing gtm.uniqueEventId to every dataLayer event.
// Appending it makes the returned ID unique per event instance, while all
// tags firing on the same event still resolve the identical value. Without
// this suffix every event on the page would share one ID, which breaks
// browser/server deduplication (e.g. Meta event_id).
const eventCounter = copyFromDataLayer('gtm.uniqueEventId');
const suffix = (eventCounter || eventCounter === 0) ? eventCounter : 0;

return pageId + '-' + suffix;


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

scenarios:
- name: Combines cached page ID with the GTM event counter
  code: |-
    mock('copyFromWindow', (key) => 'page-uuid');
    mock('copyFromDataLayer', (key) => key === 'gtm.uniqueEventId' ? 42 : undefined);

    const result = runCode({});

    assertThat(result).isEqualTo('page-uuid-42');
- name: Same event counter yields the same ID across multiple evaluations
  code: |-
    mock('copyFromWindow', (key) => 'page-uuid');
    mock('copyFromDataLayer', (key) => 7);

    const first = runCode({});
    const second = runCode({});

    assertThat(first).isEqualTo(second);
- name: Different event counters yield different IDs
  code: |-
    mock('copyFromWindow', (key) => 'page-uuid');

    mock('copyFromDataLayer', (key) => 1);
    const first = runCode({});

    mock('copyFromDataLayer', (key) => 2);
    const second = runCode({});

    assertThat(first).isNotEqualTo(second);
- name: Generates and caches a page ID when none exists
  code: |-
    let stored;
    mock('copyFromWindow', (key) => undefined);
    mock('setInWindow', (key, value) => { stored = value; });
    mock('copyFromDataLayer', (key) => 7);

    const result = runCode({});

    assertThat(stored).isNotEqualTo(undefined);
    assertThat(result).isEqualTo(stored + '-7');
- name: Falls back to suffix 0 when the event counter is unavailable
  code: |-
    mock('copyFromWindow', (key) => 'page-uuid');
    mock('copyFromDataLayer', (key) => undefined);

    const result = runCode({});

    assertThat(result).isEqualTo('page-uuid-0');


___NOTES___

Created on 11/11/2025, 00:56:03
