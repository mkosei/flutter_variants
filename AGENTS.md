# Flutter Variants

## Purpose

This repository builds a Flutter SDK for server-delivered UI variants.

The product goal is to let teams change copy, visual presentation, campaign
content, CTA labels, images, colors, spacing, and other design-level details
without waiting for an App Store or Play Store release.

This project is Variant UI, not Variant Logic. Flutter app code owns layout,
navigation, button callbacks, authentication, payments, permissions, network
calls, and business behavior.

## Product Model

The primary API should be small variant slots embedded inside native Flutter UI.

Example:

```dart
VariantText(
  id: 'home.hero.title',
  fallback: 'Welcome',
)
```

The Flutter screen structure remains native:

```dart
Column(
  children: [
    VariantText(
      id: 'home.hero.title',
      fallback: 'Welcome',
    ),
    ElevatedButton(
      onPressed: onContinue,
      child: VariantText(
        id: 'home.cta.label',
        fallback: 'Continue',
      ),
    ),
  ],
)
```

The server may change the text values for `home.hero.title` and
`home.cta.label`, but it must not define the button tap behavior.

## Core Principle

Do not build Variant Flutter.

Do not build a full-screen server-driven renderer as the primary product
surface.

Build constrained variant design slots. The native Flutter app should define the
screen structure and behavior; variant data should fill approved presentation
slots.

## What Variant Data May Control

- Text values
- Image URLs or asset references
- Icon identifiers from an approved set
- Colors from an approved schema
- Spacing values within approved constraints
- Layout helpers within approved constraints (`EdgeInsets`, `BorderRadius`)
- Visibility for approved slots
- CTA labels
- Design variants for predefined slots

## What Variant Data Must Not Control

- Arbitrary Dart, JavaScript, expressions, or scripts
- API endpoints or HTTP requests
- Button tap logic
- Navigation behavior
- Authentication behavior
- Payment or purchase behavior
- Permission requests
- Native capability access
- Business rules
- Experiment assignment logic inside the runtime

If interactions are added later, variant data may only reference native-defined
action slots. The app owns the behavior; the server may only choose approved
action identifiers.

Example:

```json
{
  "id": "home.cta.label",
  "type": "text",
  "value": "Start now"
}
```

This can change a button label. It cannot change `onPressed`.

## Current Status

Phase 1 (variant slots + value delivery) is implemented:

- Core: `VariantScope`, `VariantHost` (timeout, retry with exponential
  backoff, refresh interval, in-memory cache, load callbacks).
- Widgets: `VariantText`, `VariantImage`, `VariantVisibility`.
- Value readers: `VariantColor`, `VariantSpacing`, `VariantEdgeInsets`,
  `VariantBorderRadius`.

The next milestone is `v1.0.0` = pub.dev publishable. Remaining API work and
polish items are tracked in `doc/TODO.md` (English) and `doc/TODO.ja.md`
(Japanese).

The developer-facing API reference lives in `DOCUMENT.md`. `README.md` is the
minimal entry point.

Do not build yet:

- Full-screen schema rendering
- Runtime logic execution
- Variant-defined actions
- AB test assignment
- Analytics
- Experiment dashboards
- User segmentation
- Rollback management
- Authentication
- Navigation runtime
- Forms runtime
- Permissions
- Variant business rules

## Architecture

Current package structure:

```txt
lib/
  flutter_variants.dart
  src/
    core/
      variant_scope.dart
      variant_host.dart
    loader/
      variant_values_loader.dart
      variant_values_memory_cache.dart
      variant_values_parser.dart
    values/
      variant_color.dart
      variant_spacing.dart
      variant_edge_insets.dart
      variant_border_radius.dart
    widgets/
      variant_text.dart
      variant_image.dart
      variant_visibility.dart
```

Keep the runtime narrow. Prefer explicit slot widgets and typed value readers
over generic variant rendering.

Future areas may be added when needed:

```txt
src/
  devtools/
  analytics/
```

## Error Handling

Variant data must never crash the app.

If a variant value is missing, malformed, or has the wrong type, the widget must
render its local fallback.

Example:

```dart
VariantText(
  id: 'home.title',
  fallback: 'Welcome',
)
```

If `home.title` is missing or invalid, render `Welcome`.

`VariantHost` adds the same guarantee on the network path: load failures, parse
issues, and timeouts never replace the current values — local fallbacks (or the
last cached values) keep rendering.

## Future Hosted Product

The OSS SDK should remain usable with a self-hosted server. A hosted paid
product can provide:

- Variant value hosting
- Console UI for editing slots
- Preview
- Version history
- Rollback
- Targeting
- AB assignment
- Analytics and reaction-rate dashboards

The hosted product should make operations easier, but the app runtime must stay
safe and constrained.

## Agent Guidance

When working in this repository:

- Treat design variants as the product goal.
- Prefer small slot widgets over full-screen schema rendering.
- Keep native Flutter code responsible for layout structure and behavior.
- Preserve app stability when variant input is missing or invalid.
- Always provide local fallback values for variant slots.
- Do not introduce runtime logic execution.
- Do not let variant data define button behavior, network calls, business rules,
  permissions, payments, authentication, or navigation behavior.
- If actions are needed, model them as references to native-defined action
  slots, not as server-defined logic.
- Add tests around fallback behavior, valid values, invalid values, and example
  usage.
- For the user-facing API reference, read `DOCUMENT.md` rather than guessing.
- For the next planned work and the `v1.0.0` API list, check `doc/TODO.md`
  first.
