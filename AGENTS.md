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

## Phase 1 Scope

Phase 1 focuses on small variant components and variant value delivery.

Build:

- Variant slot identifiers
- Variant value lookup
- Safe fallback values
- Small variant widgets such as `VariantText`
- Tests for missing, invalid, and valid variant values
- Example usage inside a normal native Flutter layout

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

## MVP Target

The first stable API should look like this:

```dart
VariantScope(
  values: {
    'home.hero.title': {
      'type': 'text',
      'value': 'Try the new onboarding',
    },
  },
  child: VariantText(
    id: 'home.hero.title',
    fallback: 'Welcome',
  ),
)
```

The minimum product outcome is:

```txt
Server variant values change
-> Approved Flutter slots update
-> App behavior remains native
-> No app release required
```

## Architecture

Recommended package structure:

```txt
lib/
  flutter_variants.dart
  src/
    core/
      variant_scope.dart
    widgets/
      variant_text.dart
```

Future areas may be added when needed:

```txt
src/
  loader/
  cache/
  devtools/
  analytics/
```

Keep the runtime narrow. Prefer explicit slot widgets over generic variant
rendering.

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
