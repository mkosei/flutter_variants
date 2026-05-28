# Flutter Variants

## Purpose

This repository builds a Flutter SDK for remotely delivered UI variants.

The product goal is to let teams change copy, visual presentation, campaign
content, CTA labels, images, colors, spacing, and other design-level details
without waiting for an App Store or Play Store release.

This project is Remote UI, not Remote Logic. Flutter app code owns layout,
navigation, button callbacks, authentication, payments, permissions, network
calls, and business behavior.

## Product Model

The primary API should be small remote slots embedded inside native Flutter UI.

Example:

```dart
RemoteText(
  id: 'home.hero.title',
  fallback: 'Welcome',
)
```

The Flutter screen structure remains native:

```dart
Column(
  children: [
    RemoteText(
      id: 'home.hero.title',
      fallback: 'Welcome',
    ),
    ElevatedButton(
      onPressed: onContinue,
      child: RemoteText(
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

Do not build Remote Flutter.

Do not build a full-screen remote renderer as the primary product surface.

Build constrained remote design slots. The native Flutter app should define the
screen structure and behavior; remote data should fill approved presentation
slots.

## What Remote Data May Control

- Text values
- Image URLs or asset references
- Icon identifiers from an approved set
- Colors from an approved schema
- Spacing values within approved constraints
- Visibility for approved slots
- CTA labels
- Design variants for predefined slots

## What Remote Data Must Not Control

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

If interactions are added later, remote data may only reference native-defined
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

Phase 1 focuses on small remote components and variant value delivery.

Build:

- Remote slot identifiers
- Remote value lookup
- Safe fallback values
- Small remote widgets such as `RemoteText`
- Tests for missing, invalid, and valid remote values
- Example usage inside a normal native Flutter layout

Do not build yet:

- Full-screen schema rendering
- Runtime logic execution
- Remote-defined actions
- AB test assignment
- Analytics
- Experiment dashboards
- User segmentation
- Rollback management
- Authentication
- Navigation runtime
- Forms runtime
- Permissions
- Remote business rules

## MVP Target

The first stable API should look like this:

```dart
RemoteVariantScope(
  values: {
    'home.hero.title': {
      'type': 'text',
      'value': 'Try the new onboarding',
    },
  },
  child: RemoteText(
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
      remote_variant_scope.dart
    widgets/
      remote_text.dart
```

Future areas may be added when needed:

```txt
src/
  loader/
  cache/
  devtools/
  analytics/
```

Keep the runtime narrow. Prefer explicit slot widgets over generic remote
rendering.

## Error Handling

Remote data must never crash the app.

If a remote value is missing, malformed, or has the wrong type, the widget must
render its local fallback.

Example:

```dart
RemoteText(
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

- Treat remote design variants as the product goal.
- Prefer small slot widgets over full-screen schema rendering.
- Keep native Flutter code responsible for layout structure and behavior.
- Preserve app stability when remote input is missing or invalid.
- Always provide local fallback values for remote slots.
- Do not introduce runtime logic execution.
- Do not let remote data define button behavior, network calls, business rules,
  permissions, payments, authentication, or navigation behavior.
- If actions are needed, model them as references to native-defined action
  slots, not as remote-defined logic.
- Add tests around fallback behavior, valid values, invalid values, and example
  usage.
