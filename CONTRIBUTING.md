# Contributing to flutter_variants

[日本語](CONTRIBUTING.ja.md) | English

Thanks for your interest in `flutter_variants`. This guide explains how to
contribute code, documentation, and feedback.

## Project mission

`flutter_variants` is a Flutter SDK for safe, type-safe UI variants delivered
from a JSON URL. The package intentionally stays narrow:

- Variant data may change presentation (text, colors, images, spacing, layout
  values, visibility).
- Variant data must not control behavior (callbacks, navigation, API calls,
  auth, payments, business rules).
- The app always renders a local fallback if values are missing or invalid.

If you are new, read [`AGENTS.md`](AGENTS.md) first — it explains the
philosophy and the boundaries we hold to. The user-facing API reference lives
in [`DOCUMENT.md`](DOCUMENT.md). The current roadmap lives in
[`docs/TODO.md`](docs/TODO.md).

## Ways to contribute

- **Report issues** — bugs, confusing docs, missing examples.
- **Improve docs** — README, DOCUMENT, code comments, examples.
- **Add tests** — regression tests for invalid JSON, edge cases, missing slots.
- **Implement APIs** — pick something from `docs/TODO.md`, especially items
  under "APIs to build before v1.0.0".
- **Share use cases** — open a discussion about how you are using or want to
  use the SDK. Real use cases drive API decisions.

## Development setup

```sh
git clone https://github.com/mkosei/flutter_variants.git
cd flutter_variants

# Install Flutter via FVM (recommended) or your preferred tool.
fvm install
fvm flutter pub get

# Run the package tests.
fvm flutter test

# Run the example app.
cd example
fvm flutter pub get
fvm flutter run
```

The example app loads `example/assets/variants.json` at startup. Edit it and
hot-restart to see variant changes.

## Hard rules

These constraints define the package. PRs that break them will not be merged.

- **No remote logic execution.** Variant data must never run code (no Dart,
  no JavaScript, no expression evaluation, no script).
- **No server-defined behavior.** Callbacks, navigation, API calls, auth,
  payments, permissions, and business rules stay in Flutter app code.
- **Variant data is presentation only.** If a feature requires the server to
  decide what *happens* (not what the user *sees*), it does not belong here.
- **Every public widget / value reader requires a fallback.** Crashing on
  missing or invalid data is not allowed.

When in doubt, lean conservative. The point of the package is the constraint.

## Code conventions

- **API shape.** New value readers must follow the existing pattern:
  `VariantXxx.of(context, id: ..., fallback: ...)` for typed values, or
  `VariantXxx(id: ..., fallback: ..., ...)` for widgets. `fallback` is
  always required.
- **Type contracts in JSON.** Each variant entry has a `type` and a `value`.
  Picking a new type? Document the JSON shape in `DOCUMENT.md` next to the
  new API.
- **No new dependencies without discussion.** The runtime is pure Dart +
  Flutter. Anything that adds a dependency should be discussed first.
- **No platform channels.** The package must work on every Flutter target
  without native code.
- **No SDK initialization sequences.** `VariantHost` is the only setup step.
  Do not add `await VariantSdk.initialize()` or similar.
- **Tests are required** for every new public API and bug fix. Cover the
  happy path, the missing-value path, and the invalid-value path.
- **Comments are sparse** — explain *why* when the answer is not obvious from
  the code. Do not narrate *what* the code does.

## Pull requests

- Branch from `main`. Keep PRs small and focused on one concern.
- Commit messages follow `type(scope?): summary` style, e.g.
  `feat: add VariantNumber`, `docs: clarify VariantHost retry semantics`,
  `test: cover stale load results`.
- Make sure `fvm flutter test` and `cd example && fvm flutter test` both
  pass.
- Update `DOCUMENT.md` (and `DOCUMENT.ja.md` if you can) for any user-facing
  API change.
- For larger changes, open an issue first to discuss the approach.

## Good places to start

Pick from `docs/TODO.md`. Smaller starter tasks:

- Add more usage examples to `DOCUMENT.md` (button labels, banners, image
  swaps, color changes).
- Add an example variant scenario to `example/assets/variants.json`.
- Add tests for `loadVariantValuesFromUrl` covering success and invalid JSON.
- Implement one of the remaining v1.0.0 APIs (`VariantTextStyle.of`,
  `VariantButtonLabel`, `VariantIcon`).

If you are unsure whether a contribution fits, open a discussion or issue
before writing code.

## Reporting bugs

Open an issue with:

- A short description of what you expected and what happened.
- A minimal reproduction (a small Flutter snippet plus the relevant
  `variants.json`).
- The flutter / dart version (`flutter --version`).

## Questions

Open a GitHub Discussion or issue with the `question` label. Even half-formed
ideas about API or design are welcome.
