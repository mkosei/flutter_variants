# flutter_variants

[日本語](README.ja.md) | English

A Flutter SDK for safe UI variants.

`flutter_variants` lets you change approved UI values such as text, labels, and
design copy without shipping a new app release. The app keeps ownership of
layout, navigation, callbacks, API calls, payments, authentication, and business
logic.

This is not a server-driven UI renderer. It is a small variant slot system for
Flutter apps.

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

## Example

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

## Current API

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

### `VariantVisibility`

Reads a boolean value by `id` and switches between `child` and `replacement`.

```dart
VariantVisibility(
  id: 'home.banner.visible',
  fallback: true,
  child: const Banner(),
)
```

## Why Slots Instead Of Full Variant Rendering?

Full server-driven UI can become risky because it can drift toward server-defined
behavior changes. This package intentionally keeps the Flutter layout and app
logic native.

The goal is:

```txt
Variant values change
-> Approved Flutter slots update
-> App behavior stays native
```

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

Your Flutter app can fetch this JSON, decode it into
`Map<String, Map<String, dynamic>>`, and pass it to `VariantScope`.

```dart
VariantScope(
  values: values,
  child: const App(),
)
```

The SDK only consumes variant values. It does not require server-side code,
remote logic execution, or a proprietary backend.

## Running The Example

```sh
cd example
flutter run
```

## Running Tests

```sh
flutter test
cd example
flutter test
```

If you use FVM, prefix the Flutter commands with `fvm`:

```sh
fvm flutter test
cd example
fvm flutter test
```
