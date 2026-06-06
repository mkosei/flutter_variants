# Changelog

## 0.1.0

Initial release.

### Core

- `VariantScope` — provides variant values to descendant widgets.
- `VariantHost` — loads variant values from a JSON URL, with timeout, retry
  with exponential backoff, refresh interval, in-memory caching, and load
  callbacks (`onLoaded`, `onLoadError`, `onInvalidEntry`).

### Slot widgets

- `VariantText` — renders text from a slot with a local fallback.
- `VariantButtonLabel` — `ElevatedButton` whose label comes from a variant
  slot while the callback stays in Flutter code.
- `VariantImage` — renders an image from a URL slot with a local fallback.
- `VariantIcon` — renders an icon from an approved icon set chosen by the
  app.
- `VariantVisibility` — toggles between `child` and `replacement` based on a
  boolean slot.

### Value readers

- `VariantColor.of` — `Color` (`#RRGGBB` or `#AARRGGBB`).
- `VariantSpacing.of` — `double` spacing with optional `min` / `max`
  clamping.
- `VariantEdgeInsets.of` — `EdgeInsets` from a uniform number or per-side
  map.
- `VariantBorderRadius.of` — `BorderRadius` from a uniform number or
  per-corner map.
- `VariantTextStyle.of` — `TextStyle` subset (`fontSize`, `fontWeight`,
  `color`, `fontFamily`, `letterSpacing`, `height`, `fontStyle`).
- `VariantString.of` — raw `String`.
- `VariantBool.of` — raw `bool`.
- `VariantNumber.of` — raw `num` with optional `min` / `max` clamping.

### Loader

- `loadVariantValuesFromUrl` — default HTTP loader.
- `parseVariantValuesWithIssues` — parses JSON and surfaces invalid entries
  for observation.
- `VariantValuesMemoryCache` — process-lifetime cache used by `VariantHost`.

### Design rules

- All slot widgets require a local `fallback`.
- Variant data only changes presentation; behavior stays in Flutter code.
- No remote logic execution, no native setup, no vendor lock-in.
