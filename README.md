# flutter_variants

[日本語](README.ja.md) | English

[![pub package](https://img.shields.io/pub/v/flutter_variants.svg)](https://pub.dev/packages/flutter_variants)

A Flutter SDK for safe UI variants.

`flutter_variants` lets you change approved UI values such as text, labels, and
design copy without shipping a new app release. Layout, navigation, callbacks,
API calls, payments, authentication, and business logic stay in the Flutter
app.

This is not a server-driven UI renderer. It is a small variant slot system.

## Minimal example

```dart
VariantScope(
  values: {
    'home.title': {
      'type': 'text',
      'value': 'Try the new onboarding',
    },
  },
  child: const VariantText(
    id: 'home.title',
    fallback: 'Welcome',
  ),
)
```

For server-delivered values, wrap the app with `VariantHost`:

```dart
VariantHost(
  url: Uri.parse(
    'https://your-domain.com/apps/my_app/production/variants.json',
  ),
  child: const App(),
)
```

## Documentation

See [DOCUMENT.md](DOCUMENT.md) for the full developer guide:

- Philosophy and the slot-based approach
- API reference (`VariantScope`, `VariantText`, `VariantButtonLabel`,
  `VariantImage`, `VariantIcon`, `VariantColor`, `VariantSpacing`,
  `VariantEdgeInsets`, `VariantBorderRadius`, `VariantString`,
  `VariantBool`, `VariantNumber`, `VariantTextStyle`, `VariantVisibility`)
- `VariantHost` configuration (timeout, retry, refresh, cache, callbacks)
- Self-hosting and the `variants.json` format

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for the
dev setup, code conventions, and hard rules to respect.

## Running the example

```sh
cd example
flutter run
```

## Running tests

```sh
flutter test
cd example
flutter test
```

If you use FVM, prefix the commands with `fvm`:

```sh
fvm flutter test
cd example
fvm flutter test
```
