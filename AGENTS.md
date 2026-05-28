# Flutter Remote UI Runtime

## Purpose

This repository builds the runtime layer for remotely delivered UI in Flutter.

The primary product goal is to let teams ship UI experiments, design variants,
campaign screens, onboarding changes, and CTA updates to users without waiting
for an App Store or Play Store release.

The runtime renderer is the foundation for that goal. It should safely fetch a
remote UI definition, parse it, and render it as Flutter widgets inside the app.

This is not a project to recreate Flutter over the network.

Build a constrained, stable, operational Remote UI Runtime that can later power
experiments, segmentation, campaigns, and rollback systems.

## Product Vision

Turn Flutter apps from static binaries into remotely operated product surfaces.

Today, even small UI changes usually require:

```txt
Code change
-> Build
-> Review
-> Store submission
-> Release
```

This is too slow for product iteration, AB tests, campaign UI, onboarding
updates, CTA experiments, and visual design trials.

The intended future workflow is:

```txt
Create UI variant
-> Publish remote schema
-> Deliver to selected users
-> Measure result
-> Roll forward or roll back
```

Phase 1 only builds the safe rendering foundation for this workflow.

## Core Principle

Do not build Remote Flutter.

Build a constrained UI DSL that is safe, explicit, and practical to operate.

The framework should behave more like a remote component system than a full
copy of Flutter's widget catalog. The schema should describe approved product
UI patterns, not arbitrary app code.

## Phase 1 Scope

Phase 1 focuses only on the runtime UI rendering layer.

Build:

- Remote schema loading
- Schema parsing
- Widget tree rendering
- Widget registry
- Safe fallbacks for invalid schema
- Basic cache behavior
- Minimal debug tooling

Do not build yet:

- AB test assignment
- Analytics
- Experiment dashboards
- User segmentation
- Rollback management
- Authentication
- Navigation runtime
- Forms runtime
- Permissions
- Runtime logic execution
- Remote business rules

These are future platform capabilities. The Phase 1 runtime should be designed
so they can be added later without turning the renderer into an unsafe scripting
engine.

## MVP Target

The following API should be possible:

```dart
RemotePage(
  endpoint: '/home',
)
```

The app should fetch the schema for the endpoint and render it.

Rendering directly from a schema should also be supported:

```dart
RemoteRenderer(
  schema: schema,
)
```

The minimum product outcome is:

```txt
Server schema changes
-> Flutter UI changes
-> No app release required
```

## Example Schema

```json
{
  "type": "column",
  "children": [
    {
      "type": "text",
      "value": "Try the new checkout flow"
    },
    {
      "type": "button",
      "text": "Continue"
    }
  ]
}
```

## Runtime Flow

```txt
Schema
-> Parser
-> Remote node tree
-> Widget factory
-> Flutter widgets
```

## Architecture

```txt
RemotePage
  -> SchemaLoader
  -> Parser
  -> WidgetFactory
  -> Flutter UI
```

Recommended package structure:

```txt
remote_ui_runtime/
  core/
  parser/
  renderer/
  widgets/
  cache/
  devtools/
```

## Supported Widgets For Phase 1

Layout:

- column
- row
- stack
- padding
- center

Content:

- text
- image
- icon

Interaction:

- button
- gesture

Utility:

- spacer
- divider

Keep this widget surface intentionally small. Add widgets only when they support
real remote product UI use cases.

## Widget Registry

Widgets should be dynamically registerable.

Example:

```dart
RemoteRegistry.register(
  'text',
  RemoteTextWidget.new,
)
```

Prefer a registry-based design over hard-coded widget branching where possible.

The registry is the boundary between remote schema and native Flutter
implementation. Remote schema may request known component types, but native code
must decide what those types are allowed to do.

## Error Handling

Remote schema must never crash the app.

Invalid, unsupported, or unknown schema should render a safe fallback instead
of throwing during normal UI rendering.

Example:

```json
{
  "type": "unknown_widget"
}
```

Expected result:

```txt
UnknownWidgetFallback
```

Parsing and rendering errors should be observable in debug tooling.

This matters because future experiments and campaigns may be changed without an
app release. The runtime must tolerate bad remote input and preserve the host
app's stability.

## Cache Strategy

Use a stale-while-revalidate style startup flow:

```txt
Cached schema
-> Instant render
-> Background fetch
-> Hot swap when fresh schema arrives
```

The cache should support:

- Fast startup
- Basic offline rendering
- Resilience when the server is unavailable
- Safe fallback when a newly fetched schema is invalid

## Devtools

Include minimal debug tooling from the beginning.

Example:

```dart
RemoteDebugOverlay()
```

The debug overlay should expose:

- Current schema
- Render tree
- Parsing errors
- Rendering errors
- Render timings

This will become important later when debugging experiments, UI variants, and
remote delivery issues.

## Design Constraints

Avoid these directions:

- Full Flutter compatibility
- Arbitrary runtime code execution
- Large implicit behavior hidden in JSON
- Business logic embedded in the schema
- Unbounded widget surface area
- Experiment logic mixed into rendering code

Prefer these directions:

- Small explicit schema
- Stable widget contracts
- Safe defaults
- Clear fallbacks
- Observable errors
- Extensible registry
- Runtime boundaries that can support future experimentation features

## Future Platform Capabilities

These are not Phase 1 work, but the runtime should not make them impossible:

- AB test assignment
- UI variant targeting
- User segmentation
- Analytics integration
- Feature flags
- Experiment dashboards
- Remote campaign management
- Rollback system
- Navigation runtime
- Forms runtime
- Auth bridge
- Remote actions
- AI-generated UI
- Dashboard CMS

## Agent Guidance

When working in this repository:

- Treat remote experimentation and UI delivery as the product goal.
- Treat the renderer as the safe foundation, not the whole product.
- Keep implementations scoped to the constrained runtime vision.
- Prefer small, explicit schema contracts over broad Flutter compatibility.
- Preserve app stability when remote input is invalid.
- Keep experiment assignment, analytics, and targeting out of Phase 1 unless
  explicitly requested.
- Add tests around parsing, fallback behavior, widget registration, and cache
  behavior.
- Do not introduce runtime logic execution unless explicitly requested.
- Do not expand Phase 1 scope without a clear reason.
