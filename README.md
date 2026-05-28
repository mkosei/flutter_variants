# flutter_variants

A Flutter SDK for safe remote UI variants.

`flutter_variants` lets you change approved UI values such as text, labels, and
design copy without shipping a new app release. The app keeps ownership of
layout, navigation, callbacks, API calls, payments, authentication, and business
logic.

This is not a server-driven UI renderer. It is a small remote slot system for
Flutter apps.

## Philosophy

Remote data may change presentation values:

- Text
- CTA labels
- Image references
- Colors
- Spacing
- Design variants

Remote data must not define behavior:

- No remote code execution
- No remote button logic
- No remote navigation logic
- No remote API calls
- No remote payment/auth/business rules

Flutter code owns behavior. Remote values only fill approved slots.

## Example

```dart
RemoteVariantScope(
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
      const RemoteText(
        id: 'home.title',
        fallback: 'Welcome',
      ),
      ElevatedButton(
        onPressed: onContinue,
        child: const RemoteText(
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

### `RemoteVariantScope`

Provides remote variant values to the widgets below it.

```dart
RemoteVariantScope(
  values: {
    'slot.id': {
      'type': 'text',
      'value': 'Remote value',
    },
  },
  child: child,
)
```

### `RemoteText`

Reads a text value by `id` and renders a local fallback when the value is
missing or invalid.

```dart
const RemoteText(
  id: 'home.hero.title',
  fallback: 'Welcome',
)
```

## Why Slots Instead Of Full Remote Rendering?

Full server-driven UI can become risky because it can drift toward remote
behavior changes. This package intentionally keeps the Flutter layout and app
logic native.

The goal is:

```txt
Remote values change
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
