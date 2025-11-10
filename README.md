# GTM Unique Event ID Variable

A Google Tag Manager (GTM) variable template that generates a persistent unique event ID stored in localStorage and accessible via `gtm.uniqueEventId`.

## Overview

This GTM variable template creates a unique identifier that persists across browser sessions using localStorage. Once generated, the same ID is reused for all subsequent page loads in that browser, making it perfect for tracking user sessions or creating persistent user identifiers.

## Features

- **Persistent ID**: Generates a unique ID once and stores it in localStorage
- **Browser-specific**: Each browser gets its own unique ID
- **Automatic dataLayer integration**: Optionally sets `gtm.uniqueEventId` in the dataLayer
- **Customizable storage key**: Configure the localStorage key name
- **Privacy-friendly**: Stored only in the user's browser, not sent anywhere automatically

## Installation

### From GTM Community Template Gallery

1. In your GTM workspace, go to **Templates** in the left sidebar
2. Click **Search Gallery** in the Variable Templates section
3. Search for "Unique Event ID"
4. Click on the template and then click **Add to Workspace**
5. Save the template

### Manual Installation

1. Download the `template.tpl` file from this repository
2. In your GTM workspace, go to **Templates**
3. Click **New** in the Variable Templates section
4. Click the three-dot menu in the top right and select **Import**
5. Select the downloaded `template.tpl` file
6. Save the template

## Usage

### Creating the Variable

1. In GTM, go to **Variables** and click **New**
2. Click **Variable Configuration**
3. Select **Unique Event ID** from the Custom category
4. Configure the settings:
   - **Storage Key**: The localStorage key (default: `gtm_unique_event_id`)
   - **Set gtm.uniqueEventId property**: Check to automatically populate `gtm.uniqueEventId` in the dataLayer
5. Name your variable (e.g., "Unique Event ID")
6. Save the variable

### Using the Variable

Once created, you can use this variable in any tag, trigger, or other variable:

- Reference it as `{{Unique Event ID}}` (or whatever name you gave it)
- If you enabled "Set gtm.uniqueEventId property", you can also access it via the dataLayer variable `gtm.uniqueEventId`

### Example Use Cases

**1. Send with Google Analytics events:**
```javascript
// The ID will be available in gtm.uniqueEventId
// Use it as a custom dimension
```

**2. Track across sessions:**
```javascript
// The same ID persists across browser sessions
// Perfect for linking user behavior over time
```

**3. Custom event tracking:**
```javascript
dataLayer.push({
  'event': 'custom_event',
  'uniqueId': {{Unique Event ID}}
});
```

## Configuration Options

### Storage Key
- **Default**: `gtm_unique_event_id`
- **Purpose**: The key name used in localStorage
- **When to change**: If you have naming conflicts or prefer a different key name

### Set gtm.uniqueEventId property
- **Default**: Checked (enabled)
- **Purpose**: Automatically adds the unique ID to `gtm.uniqueEventId` in the dataLayer
- **When to disable**: If you only want to use the variable directly and don't need it in the dataLayer

## Technical Details

### ID Format
The generated ID follows the format: `{timestamp}-{random}`
- **timestamp**: Unix timestamp in milliseconds (13 digits)
- **random**: 6-digit random number

Example: `1699660800000-123456`

### Storage
- Uses browser `localStorage`
- Persists across browser sessions
- Cleared when user clears browser data
- Domain-specific (not shared across domains)

### Permissions
The template requires the following GTM permissions:
- **Access Local Storage**: To read/write the unique ID
- **Access Globals**: To access and modify the dataLayer
- **Read Data Layer**: To read the `gtm` object

## Privacy Considerations

- The unique ID is generated and stored entirely in the user's browser
- No data is sent to external servers by this template
- The ID is domain-specific and not shared across websites
- Users can clear the ID by clearing their browser's localStorage
- Consider your local privacy laws (GDPR, CCPA, etc.) when using persistent identifiers

## Browser Compatibility

This template works in all browsers that support:
- localStorage (all modern browsers)
- Google Tag Manager

## Troubleshooting

### ID keeps changing on each page load
- Check that localStorage is not disabled in the browser
- Verify the storage key is consistent across your configuration
- Check browser console for any localStorage errors

### gtm.uniqueEventId is undefined
- Ensure "Set gtm.uniqueEventId property" is checked in the variable configuration
- Verify the variable fires before you try to access the value
- Check that the dataLayer is available

### ID not persisting across sessions
- Verify localStorage is enabled in the user's browser
- Check that the user isn't in private/incognito mode (localStorage may not persist)
- Ensure browser cookies/data aren't being automatically cleared

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This template is provided as-is for use in Google Tag Manager.

## Support

For issues, questions, or feature requests, please open an issue on the [GitHub repository](https://github.com/michaelroef/gtm-unique-event-id-variable).
