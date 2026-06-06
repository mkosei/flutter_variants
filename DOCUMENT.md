# flutter_variants — Developer Guide

[日本語](DOCUMENT.ja.md) | English

This guide covers the full developer-facing surface of `flutter_variants`.

## Table of Contents

- [Philosophy](#philosophy)
- [Why slots instead of full variant rendering?](#why-slots-instead-of-full-variant-rendering)
- [Quick start](#quick-start)
- [API reference](#api-reference)
  - [`VariantScope`](#variantscope)
  - [`VariantText`](#varianttext)
  - [`VariantButtonLabel`](#variantbuttonlabel)
  - [`VariantImage`](#variantimage)
  - [`VariantColor`](#variantcolor)
  - [`VariantSpacing`](#variantspacing)
  - [`VariantEdgeInsets`](#variantedgeinsets)
  - [`VariantBorderRadius`](#variantborderradius)
  - [`VariantString`](#variantstring)
  - [`VariantBool`](#variantbool)
  - [`VariantNumber`](#variantnumber)
  - [`VariantTextStyle`](#varianttextstyle)
  - [`VariantVisibility`](#variantvisibility)
- [`VariantHost`](#varianthost)
- [Self-hosting](#self-hosting)

## Philosophy

Variant data may change presentation values:

- Text
- CTA labels
- Image references
- Colors
- Spacing
- Design variants

Variant data must not define behavior:

- No server-defined code execution
- No server-defined button logic
- No server-defined navigation logic
- No server-defined API calls
- No server-defined payment/auth/business rules

Flutter code owns behavior. Variant values only fill approved slots.

## Why slots instead of full variant rendering?

Full server-driven UI can drift toward server-defined behavior changes. This
package intentionally keeps the Flutter layout and app logic native.

The goal:

```txt
Variant values change
-> Approved Flutter slots update
-> App behavior stays native
```

## Quick start

```dart
VariantScope(
  values: {
    'home.title': {
      'type': 'text',
      'value': 'Try the new onboarding',
    },
    'home.cta.label': {
      'type': 'text',
      'value': 'Start now',
    },
  },
  child: Column(
    children: [
      const VariantText(
        id: 'home.title',
        fallback: 'Welcome',
      ),
      ElevatedButton(
        onPressed: onContinue,
        child: const VariantText(
          id: 'home.cta.label',
          fallback: 'Continue',
        ),
      ),
    ],
  ),
)
```

The server can change `home.title` and `home.cta.label`. It cannot change
`onContinue`.

## API reference

### `VariantScope`

Provides variant values to the widgets below it.

```dart
VariantScope(
  values: {
    'slot.id': {
      'type': 'text',
      'value': 'Variant value',
    },
  },
  child: child,
)
```

### `VariantText`

Reads a text value by `id` and renders a local fallback when the value is
missing or invalid.

```dart
const VariantText(
  id: 'home.hero.title',
  fallback: 'Welcome',
)
```

### `VariantButtonLabel`

A small `ElevatedButton` whose label comes from a variant slot, while the
callback stays in Flutter app code. This is the package's recommended
pattern for buttons: the server can change what the button *says*, but it
cannot change what the button *does*.

```dart
VariantButtonLabel(
  id: 'home.cta.label',
  fallback: 'Continue',
  onPressed: _onContinue,
)
```

Reuses the same JSON shape as `VariantText` (`{ "type": "text", "value": "..." }`).

`onPressed` may be `null` to render a disabled button. `style` and
`textStyle` are optional, so the button can be themed in Flutter while the
copy stays in the JSON.

### `VariantImage`

Reads an image URL by `id` and renders a local fallback image when the value is
missing or invalid.

```dart
VariantImage(
  id: 'home.hero.image',
  fallback: const AssetImage('assets/default_hero.png'),
)
```

### `VariantColor`

Reads a color value by `id`.

```dart
VariantColor.of(
  context,
  id: 'home.cta.background',
  fallback: const Color(0xFF3366FF),
)
```

Supported formats:

- `#RRGGBB`
- `#AARRGGBB`

### `VariantSpacing`

Reads a spacing value by `id`.

```dart
VariantSpacing.of(
  context,
  id: 'home.section.spacing',
  fallback: 24,
  min: 0,
  max: 64,
)
```

### `VariantEdgeInsets`

Reads an `EdgeInsets` value by `id`.

```dart
VariantEdgeInsets.of(
  context,
  id: 'home.section.padding',
  fallback: const EdgeInsets.all(16),
)
```

Supported formats:

- `value: 12` → `EdgeInsets.all(12)`
- `value: { "left": 8, "top": 4, "right": 8, "bottom": 12 }` → per-side. Missing or invalid sides default to `0`.

### `VariantBorderRadius`

Reads a `BorderRadius` value by `id`.

```dart
VariantBorderRadius.of(
  context,
  id: 'home.card.radius',
  fallback: BorderRadius.circular(8),
)
```

Supported formats:

- `value: 16` → `BorderRadius.circular(16)`
- `value: { "topLeft": 12, "topRight": 12, "bottomLeft": 0, "bottomRight": 4 }` → per-corner. Missing or invalid corners default to `0`.

### `VariantString`

Reads a raw string value by `id`. Use this when you need the string itself
rather than a `Text` widget — `AppBar` titles, `SnackBar` messages, dialog
copy, etc.

```dart
final title = VariantString.of(
  context,
  id: 'home.title',
  fallback: 'Welcome',
);
```

JSON shape: `{ "type": "string", "value": "..." }`.

### `VariantBool`

Reads a raw boolean value by `id`. Complements `VariantVisibility` for cases
that branch on a flag without swapping widgets (feature gates, conditional
behavior, etc.).

```dart
final isEnabled = VariantBool.of(
  context,
  id: 'home.experiment.enabled',
  fallback: false,
);
```

JSON shape: `{ "type": "bool", "value": true }`. Shares the same type as
`VariantVisibility`, so the same entry can be read either way.

### `VariantNumber`

Reads a generic numeric value by `id` (returns `num`). Use this for counts,
opacities, durations in milliseconds, and any non-spacing number.

```dart
final maxItems = VariantNumber.of(
  context,
  id: 'home.list.max_items',
  fallback: 10,
  min: 1,
  max: 100,
);
```

JSON shape: `{ "type": "number", "value": 25 }` or `{ "type": "number", "value": 0.75 }`.

### `VariantTextStyle`

Reads a subset of `TextStyle` by `id` and merges it onto the provided
fallback (via `copyWith`). Fields that are missing or invalid keep the
fallback's value.

```dart
Text(
  'Welcome',
  style: VariantTextStyle.of(
    context,
    id: 'home.title.style',
    fallback: Theme.of(context).textTheme.titleLarge!,
  ),
)
```

JSON shape:

```json
{
  "type": "textStyle",
  "value": {
    "fontSize": 22,
    "fontWeight": "bold",
    "color": "#FF3366",
    "fontFamily": "Inter",
    "letterSpacing": 0.5,
    "height": 1.4,
    "fontStyle": "italic"
  }
}
```

Supported fields:

| Field           | Accepts                                                                                                                                                  |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fontSize`      | number                                                                                                                                                   |
| `fontWeight`    | number `100`–`900`, or string `thin` / `extraLight` / `light` / `normal` (or `regular`) / `medium` / `semiBold` / `bold` / `extraBold` / `black`         |
| `color`         | `#RRGGBB` or `#AARRGGBB`                                                                                                                                 |
| `fontFamily`    | string                                                                                                                                                   |
| `letterSpacing` | number                                                                                                                                                   |
| `height`        | number (line-height multiplier)                                                                                                                          |
| `fontStyle`     | `normal` or `italic`                                                                                                                                     |

Every field is optional. Specify only what you want to override.

### `VariantVisibility`

Reads a boolean value by `id` and switches between `child` and `replacement`.

```dart
VariantVisibility(
  id: 'home.banner.visible',
  fallback: true,
  child: const Banner(),
)
```

## `VariantHost`

Wrap your app with `VariantHost` to load variant values from a URL.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  runApp(
    VariantHost(
      url: Uri.parse(
        'https://your-domain.com/apps/my_app/production/variants.json',
      ),
      child: const App(),
    ),
  );
}
```

Invalid entries are ignored. Missing or invalid slot values fall back locally.

### Timeout and callbacks

```dart
VariantHost(
  url: Uri.parse('https://your-domain.com/apps/my_app/production/variants.json'),
  timeout: const Duration(seconds: 3),
  onLoadError: (error, stackTrace) {
    // Keep local fallbacks and report the error if needed.
  },
  onInvalidEntry: (issue) {}, // Optional: observe invalid entries.
  child: const App(),
)
```

### Retry and refresh

To survive transient network failures and pick up server-side changes while the
app is running, configure retries and a refresh interval.

```dart
VariantHost(
  url: Uri.parse('https://your-domain.com/apps/my_app/production/variants.json'),
  maxRetries: 2, // Optional: retry transient failures with exponential backoff.
  retryBackoff: const Duration(milliseconds: 300), // Optional: initial backoff, doubles each retry.
  refreshInterval: const Duration(minutes: 5), // Optional: re-fetch periodically.
  child: const App(),
)
```

`onLoadError` is only invoked after the final retry fails. The refresh timer
keeps running even after a failed load, so the app can recover automatically
once the server is reachable again.

### Caching

`VariantHost` uses in-memory caching by default. Cached values render
immediately while fresh values are fetched in the background. Set
`cache: false` if you need to always start from local fallbacks.

The SDK only consumes variant values. It does not require server-side code,
runtime logic execution, or a proprietary backend.

## Self-hosting

`flutter_variants` does not require a hosted service.

Variant values are plain JSON, so you can host them on Cloudflare Pages,
Netlify, Vercel, S3, your own backend, or any static file host.

Example `variants.json`:

```json
{
  "home.title": {
    "type": "text",
    "value": "Try the new onboarding"
  },
  "home.cta.label": {
    "type": "text",
    "value": "Start now"
  },
  "home.cta.background": {
    "type": "color",
    "value": "#FF3366"
  },
  "home.banner.visible": {
    "type": "bool",
    "value": true
  },
  "home.section.spacing": {
    "type": "spacing",
    "value": 32
  }
}
```

A simple static hosting layout:

```txt
public/
  apps/
    my_app/
      production/
        variants.json
      staging/
        variants.json
```

Example URL:

```txt
https://your-domain.com/apps/my_app/production/variants.json
```
