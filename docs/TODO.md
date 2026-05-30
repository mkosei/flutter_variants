# TODO

[日本語](TODO.ja.md) | English

## APIs to build before v1.0.0

v1.0.0 means "ready to publish on pub.dev." The goal is a stable minimal API
surface.

Primitive value readers:

- `VariantString.of(context, id: ..., fallback: ...)` — for cases where only
  the string value is needed (not a widget).
- `VariantBool.of(context, id: ..., fallback: ...)` — generic boolean reader
  for branching cases outside `VariantVisibility`.
- `VariantNumber.of(context, id: ..., fallback: ...)` — generic number reader
  that is not specific to spacing.

Flutter type helpers:

- `VariantTextStyle.of` — subset of `TextStyle` (`fontSize`, `fontWeight`,
  `color`). Not the full `TextStyle`.

Other candidates to consider:

- `VariantButtonLabel` — keep the callback native and only swap the visible
  label, either as an example or as a dedicated widget.
- `VariantIcon` — pick from an approved icon set.

## APIs to consider after v1.0.0

- None yet (add candidates here when they come up).

## Loader improvements

- Add local persistence so the app can start offline with the last known
  values.
- Add request header support so private JSON endpoints can be used.

## Performance

- Verify that `VariantScope` updates do not rebuild unrelated widgets more
  than necessary.
- Decide whether `VariantScope` should be split per screen, per feature, or
  per slot.
- Add benchmarks so parsing large JSON does not get too slow.
- Check whether `parseVariantValues` allocates more than it needs to in its
  copy step.
- Make sure swapping image URLs does not cause unnecessary re-fetches or
  flicker.
- Make `VariantHost` fetch / parse / scope update timings visible in debug
  builds.
- Prefer fallback rendering on the first frame so variant loading does not
  block the UI thread.
- Verify the perceived speed of stale-data-first rendering + background
  refresh.
- Review lookup count and map structure for screens with many slots.

## Schema validation

- Detect unknown or typo-looking keys during development.
- Write a small schema spec per type.
  - `text`
  - `image`
  - `color`
  - `spacing`
  - `bool`
  - `edgeInsets`
  - `borderRadius`
- Add schema versioning.
  - `schemaVersion`
  - Compatibility rules
  - Fallback behavior

## Developer experience

- Add a debug overlay that shows current values and parse issues.
- Add more examples to README and DOCUMENT.
  - Button labels
  - Campaign banners
  - Image swaps
  - Show / hide toggles
  - Color changes
- Add an example `variants.json`.
- Add a minimal self-hosted sample using a static file.

## Safety rules

- Callbacks, navigation, API calls, auth, payments, and business logic must
  stay on the native Flutter side.
- Do not add server-defined action execution.
- Do not add arbitrary expression evaluation.
- Do not add execution of Dart, JavaScript, or any script.
- Variant values are limited to presentation swaps only.

## Tests

- Add tests for `loadVariantValuesFromUrl` covering success and invalid JSON
  cases.
- Add an example app test that exercises `VariantHost`.
- Add regression tests confirming widgets do not crash on invalid schemas
  (complements existing parser tests).

## Pre-publish polish

- Update `pubspec.yaml` description before publishing.
- Add package topics.
- Add a screenshot or short GIF for the README.
- Maintain a CHANGELOG for each public API change.
- Review the exported API surface before the first release.

## Future tooling

- Consider a CLI that validates `variants.json`.
- Consider a preview command for trying out variant changes locally.
- Consider a small web editor that emits static JSON.
- Keep CLI / web tooling optional, separate from the Flutter SDK itself.

## Hosted product ideas

- Keep self-hosting free and documented in the README.
- Possible paid offerings:
  - Hosted JSON delivery
  - Web console for editing values
  - Approval workflow
  - Rollback
  - Basic metrics
  - Experiment reporting
- Even in a hosted product, do not allow business logic to be swapped from
  the server.
