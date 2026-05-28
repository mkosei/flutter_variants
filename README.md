# flutter_variants

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

## Running The Example

```sh
cd example
fvm flutter run
```

## Running Tests

```sh
fvm flutter test
cd example
fvm flutter test
```
