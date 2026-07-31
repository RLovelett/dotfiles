# Signal Rail architecture

Signal Rail is organized around explicit ownership rather than global visual
state. `shell.qml` owns the design system and long-lived services. Each screen
scope owns its layer surfaces and a per-screen bar model, so monitor removal
also removes every object holding that monitor.

## Layers

- `theme/` contains the Dracula palette and semantic design tokens. Feature
  code does not read palette values directly.
- `components/` contains reusable visual primitives. Capsules and cards share
  the same surface implementation.
- `services/` owns system state and external mutations.
- `models/` adapts external objects into null-safe, readonly view state.
- `features/` owns feature presentation and emits user intent.
- `surfaces/` owns Wayland layer-shell configuration and composition.

Hyprland applies backdrop blur by layer namespace, not by QML component. The
interactive surface uses `signal-rail-bar`, which must remain covered by the
blur rule in `hypr/modules/apps/quickshell.lua`. The track and reservation
surfaces intentionally use separate namespaces so they remain unblurred and
can have independent animation policy.

Signal Rail's entrance is owned by `BarSurface.qml`: the complete bar content
moves down from above the monitor after the layer maps and whenever it returns
from fullscreen suppression. Hyprland animation is disabled for all three
Signal Rail namespaces so the global horizontal layer transition cannot
combine with or replace that motion.

The bar's input mask is expressed in panel-local coordinates. Do not replace
those regions with transformed `item` regions: item mapping can include the
global output origin on secondary monitors. Expanded capsule dimensions remain
bound into the mask so clock and title hovers stay interactive while morphing.

The dependency direction is from surfaces toward features, models, services,
components, and theme. Services never depend on visual components.

## Component contracts

- `InteractiveItem` owns pointer, keyboard, focus, accessibility, secondary
  activation, and wheel input. Feature controls provide intent and content.
- `MorphingCapsule` owns collapsed/expanded geometry, transition order,
  clipping, stable corners, hover lifetime, and expanded-content reveal.
  Header entries are direct children of `headerData`; expanded entries are
  direct default children. A wrapper must explicitly fill its assigned slot.
- `InteractiveRegion` is the only supported bridge from transformed bar
  controls to a layer-window input mask.
- `Card` derives its size from a column of content plus tokenized padding and
  width constraints. Callers should constrain it, not assign arbitrary fixed
  heights.
- `SemanticRoles` is shared by text, symbols, progress indicators, cards, and
  actions. Feature code must not use typography enums as color roles.

Expansion changes bounds, never the corner language. Calendar column slots and
day markers are separate geometry: a marker must fit both dimensions of its
slot. Expanded heights should be derived from content and tokenized padding;
unused whitespace is not an acceptable substitute for layout ownership.

`shell.qml` exposes `reducedMotion`. Motion durations resolve to zero when it is
enabled. New animation code must consume motion tokens so this remains a
shell-wide policy.

Visibility represents lifecycle or data presence. It must not be derived from
an animated opacity value: doing so can prevent initially hidden controls from
ever rendering their entrance. Opacity and transforms own visual transitions.

## Visual semantics

Capsule outlines follow the rail gradient: primary/cyan on the left,
secondary/purple in the center, and tertiary/pink on the right. They identify
position, not runtime state. Every capsule uses the same surface fill.

Workspace fill means active on a monitor. Cyan is active on the focused
monitor; Dracula's Current Line color is active on an unfocused monitor.
Urgency is an orange outline layered over that state. Special workspaces use
purple as their identity.

## Extending the shell

New system integrations begin as services, then expose presentation through a
feature component and, when necessary, a dedicated surface. Notifications can
therefore add a notification service, cards, stack, and drawer without adding
notification behavior to the bar or capsule primitive.

Notifications use `Card`, `IconButton`, semantic urgency roles, and a dedicated
`signal-rail-notifications` surface. The phase-one notification service owns
server registration, lifecycle, timeout, monitor assignment, and raw server
objects; presentation receives snapshots and lifecycle commands only. History,
DND, actions, inline replies, and persistence remain later increments.

Run `./check.sh` from this directory after changes. It lints QML, runs focused
Qt Quick tests, and enforces palette ownership of literal colors.
