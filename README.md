# GTM Unique Event ID Variable

A Google Tag Manager (GTM) variable template that generates a unique event ID per pageload stored in the GTM dataLayer and accessible via `gtm.uniqueEventId`.

## Overview

This GTM variable template creates a unique identifier for each page load using the GTM dataLayer. A new ID is generated on every page load, making it perfect for tracking individual page views or events within a session.

## Features

- **Per-pageload ID**: Generates a unique ID for each page load
- **DataLayer storage**: Stores the ID in the GTM dataLayer for the current page session
- **Automatic dataLayer integration**: Optionally sets `gtm.uniqueEventId` in the dataLayer

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
// Use it as a custom dimension for per-pageload tracking
```

**2. Track page views uniquely:**
```javascript
// Each page load gets a new unique ID
// Perfect for identifying individual page views within a session
```

**3. Custom event tracking:**
```javascript
dataLayer.push({
  'event': 'custom_event',
  'uniqueId': {{Unique Event ID}}
});
```

## Configuration Options

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
- Uses GTM `dataLayer`
- Only persists for the current page load
- Resets on each new page load
- No browser storage required

### Permissions
The template requires the following GTM permissions:
- **Access Globals**: To access and modify the dataLayer
- **Read Data Layer**: To read the `gtm.uniqueEventId` value

## Privacy Considerations

- The unique ID is generated and stored only in the GTM dataLayer for the current page load
- No data is sent to external servers by this template
- The ID does not persist across page loads or sessions
- No browser storage is used
- Consider your local privacy laws (GDPR, CCPA, etc.) when using tracking identifiers

## Browser Compatibility

This template works in all browsers that support:
- Google Tag Manager (all modern browsers)

## Troubleshooting

### ID is the same across multiple page loads
- This is expected behavior - each page load should generate a new unique ID
- If the ID is persisting, check if you have caching or single-page application logic that's preventing a full page reload

### gtm.uniqueEventId is undefined
- Ensure "Set gtm.uniqueEventId property" is checked in the variable configuration
- Verify the variable fires before you try to access the value
- Check that the dataLayer is available

### ID is different for each event on the same page
- The ID should be consistent within a single page load
- Ensure you're using the same variable reference
- Check if the variable is being called multiple times correctly

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This GTM Variable is developed under the Apache 2.0 license.

## Support

For issues, questions, or feature requests, please open an issue on the [GitHub repository](https://github.com/trackinghippo-io/gtm-unique-event-id-variable).
