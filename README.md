# GTM Unique Event ID Variable

A Google Tag Manager (GTM) variable template that generates a unique ID for **every dataLayer event**, while guaranteeing that all tags firing on the same event resolve the identical value.

## Overview

This variable combines a per-pageload UUID with GTM's built-in per-event counter (`gtm.uniqueEventId`, which GTM stamps on every dataLayer message). The result is an ID that is:

- **Unique per event instance** — two Purchase events on the same page get two different IDs
- **Stable within an event** — every tag that fires on the same event (e.g. a browser Meta Pixel tag and a server-bound GA4 tag) resolves the exact same value

This makes it suitable as a deduplication key for browser/server setups, such as Meta's `event_id` for Pixel + Conversions API. Meta requires the `event_id` to be unique per event instance and identical between the browser and server copy of that event — reusing one ID for all events on a page breaks deduplication and inflates conversion counts.

## Features

- **Globally unique ID**: UUID base unique across all browsers, users, and page loads
- **Per-event granularity**: Each dataLayer event gets its own ID via GTM's event counter
- **Deterministic within an event**: All references during one event resolve the same value — safe for browser + server deduplication
- **Chronologically sortable**: The UUID base incorporates the page-load timestamp

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
4. Name your variable (e.g., "Unique Event ID")
5. Save the variable

### Using the Variable

Once created, reference it as `{{Unique Event ID}}` (or whatever name you gave it) in any tag, trigger, or other variable.

### Example Use Cases

**1. Meta Pixel + Conversions API deduplication:**
Use `{{Unique Event ID}}` as the `event_id` in your browser-side Meta Pixel tag, and pass the same variable to your server-side setup (e.g. as a parameter on the GA4 tag feeding server-side GTM). Both copies of the event carry the same ID, and different events on the same page carry different IDs — exactly what Meta's deduplication requires.

**2. Joining events across systems:**
Attach the ID to events sent to multiple analytics destinations to join them later in your data warehouse.

**3. Debugging duplicate triggers:**
Because the ID embeds GTM's event counter, two firings of the same tag on one page are distinguishable.

## Technical Details

### ID Format

`<pageload-uuid>-<event-counter>`

- The base is a pseudo-UUID v4 (`xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`) generated once per page load, with the current timestamp encoded in the first segment for chronological sorting.
- The suffix is GTM's internal `gtm.uniqueEventId` counter for the event being processed (falls back to `0` if unavailable).

Example: `18ba7c40-a1b2-4c3d-8e5f-1234567890ab-12`

### Storage

- **Window cache**: The UUID base is cached in `window.__th_unique_page_id` so that all variable references on the page share the same base (zero race conditions, synchronous access).
- **Persistence**: Only persists for the current page load. Resets on reload. In single-page applications the base stays constant across virtual pageviews, but the event counter still makes every event's ID unique.

### Permissions

The template requires the following GTM permissions:
- **Access Globals**: `__th_unique_page_id` (Read/Write) — caches the per-pageload UUID base
- **Reads Data Layer**: `gtm.uniqueEventId` — GTM's built-in per-event counter

## Privacy Considerations

- The ID is generated locally; no data is sent to external servers by this template
- The ID does not persist across page loads or sessions
- No browser storage (cookies, localStorage) is used
- Consider your local privacy laws (GDPR, CCPA, etc.) when using tracking identifiers

## Browser Compatibility

This template works in all browsers that support Google Tag Manager (all modern browsers).

## Troubleshooting

### The ID is different for each event on the same page
- This is expected behavior — the whole point of the variable is that each event instance gets its own ID. The UUID portion before the final segment stays constant for the page load.

### Two tags on the same event got different IDs
- Ensure both tags reference the same variable and fire on the same trigger/event. Tags firing on *different* dataLayer events (e.g. a custom event pushed twice) correctly receive different IDs.

### Meta still reports duplicate events
- Verify the server-side event carries the byte-identical ID as the browser event (check the `event_id` in Meta Events Manager's event details for both the Browser and Server source).
- Make sure the server-side pipeline reads the ID from the event payload rather than generating its own.

## Migration from v1/v2 (per-pageload IDs)

Earlier versions generated one ID per page load and reused it for every event, which breaks per-event deduplication. After updating:

- The returned value now ends in `-<n>` where `n` is GTM's event counter.
- The **Set gtm.uniqueEventId property** option was removed. It pushed a custom value into `gtm.uniqueEventId`, which collides with GTM's identically-named internal key; read the variable directly instead.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This GTM Variable is developed under the Apache 2.0 license.

## Support

For issues, questions, or feature requests, please open an issue on the [GitHub repository](https://github.com/trackinghippo-io/gtm-unique-event-id-variable).
