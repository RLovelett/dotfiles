# Quickshell-Native Animation and Notification Architecture

## Summary

Adopt the relevant Caelestia architecture while keeping the Signal Rail's existing visual identity:

- Quickshell owns the wallpaper surface and performs reliable image crossfades.
- Hyprland no longer applies a global horizontal layer animation.
- The Signal Rail gets one explicit top-down entrance animation.
- Quickshell owns notifications, history, DND, actions, and popup presentation.
- The previous notification daemon and hyprpaper are removed from the active desktop UI path.

Caelestia's implementation confirms that this is the reliable model: its background keeps the previous image alive while the new image fades in, and its notification service owns a persistent tracked notification model rather than treating popups as standalone surfaces.

References:

- [Caelestia background implementation](https://github.com/caelestia-dots/shell/blob/main/modules/background/Wallpaper.qml)
- [Caelestia notification service](https://github.com/caelestia-dots/shell/blob/main/services/Notifs.qml)
- [Quickshell NotificationServer API](https://quickshell.org/docs/types/Quickshell.Services.Notifications)
- [Hyprland animations](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/)
- [Hyprland layer rules](https://wiki.hypr.land/Configuring/Basics/Window-Rules/)

## Key Changes

### 1. Make layer animation namespace-specific

Update `config-linux/.config/hypr/modules/animations.lua`:

- Remove `slide right` from global `layersIn` and `layersOut`.
- Use a neutral default for unclassified layers.
- Keep window and workspace animation behavior unchanged.

Update layer rules with explicit namespaces:

- `signal-rail-bar`: top-down layer entrance.
- `signal-rail-track`: no animation.
- `signal-rail-reservation`: no animation.
- `signal-rail-notifications`: independent notification animation.
- `signal-rail-background`: no compositor animation; Quickshell owns the fade.
- Walker and SwayOSD retain their existing behavior.

Use explicit `WlrLayershell.namespace` values in each Quickshell surface. Avoid matching the broad `quickshell` namespace because it couples unrelated surfaces together.

### 2. Animate the Signal Rail as one object

Refactor `Bar.qml`:

- Set its namespace to `signal-rail-bar`.
- Put all four capsules inside one animated content container.
- Animate the container from above the monitor to its resting position.
- Use a short ease-out entrance around 180–220 ms.
- Remove the per-capsule `entered` and negative `anchors.topMargin` startup animations.
- Retain internal animations for clock expansion, focus opacity, hover scaling, metric bars, and workspace state changes.

Keep the reservation surface static. Its purpose is geometry, not visual animation.

This produces one clean top-down entrance instead of a compositor slide combined with four independent capsule drops.

### 3. Move wallpaper rendering into Quickshell

Replace hyprpaper as the rendered wallpaper backend.

Add a dedicated Quickshell background surface modeled after Caelestia's `Background.qml` and `Wallpaper.qml`:

- Full-screen `PanelWindow`.
- Namespace: `signal-rail-background`.
- `WlrLayer.Background`.
- `ExclusionMode.Ignore`.
- Transparent or black base surface.
- Current wallpaper and previous wallpaper coexist during transition.
- New image loads asynchronously.
- New image fades from opacity `0` to `1`.
- Previous image is destroyed only after the fade completes.
- Missing or invalid images fall back to the existing wallpaper state or a solid background.

Update the Elephant wallpaper provider so it changes the shared wallpaper state consumed by Quickshell rather than directly calling hyprpaper.

Remove hyprpaper autostart and its active configuration once Quickshell rendering is verified. Keep wallpaper selection, symlink/state conventions, and the existing wallpaper directory unchanged where possible.

This avoids depending on whether hyprpaper recreates its layer surface when changing images.

### 4. Build notifications incrementally

Phase one is a transient-card daemon, not a notification center:

- Register `NotificationServer` and keep raw notification objects inside the service.
- Present app/icon, summary, normalized plain-text body, urgency, and timeout.
- Assign notifications to the focused monitor at arrival and keep them there.
- Show three cards per monitor and queue overflow until a slot opens.
- Pause expiry on hover; dismiss one, latest, or all through service methods.
- Queue low and normal urgency during fullscreen while allowing critical cards.
- Animate vertically from the top with QML on a dedicated `signal-rail-notifications` surface.

History, DND, actions, inline replies, persistence, grouping, and swipe gestures are
later phases. Existing applications such as Zen Browser, Signal Desktop, Hyprshot,
and `notify-send` are captured through `org.freedesktop.Notifications`.

Existing applications such as Zen Browser and Signal Desktop should be captured automatically when they use the standard `org.freedesktop.Notifications` D-Bus service. Only one notification daemon may own that service, so no competing daemon may be running.

### 5. Route notification controls through Quickshell

Update `bindings/utilities.lua`:

- Route notification commands through Quickshell IPC.
- Bind dismiss-latest and dismiss-all to Quickshell IPC.
- Leave history and DND unbound until those features exist.
- Keep `notify-send` compatibility unchanged.
- Keep the shell independent of an external notification daemon.

Expose a small stable notification command interface:

- `notifications.dismissLatest()`
- `notifications.clear()`

The Hyprland bindings should call those commands through Quickshell IPC rather than reaching into QML state directly.

### 6. Share the Signal Rail theme

Extend `Theme.qml` with:

- Animation durations and easing curves.
- Background transition duration.
- Notification width and spacing.
- Notification stack limit.
- Low, normal, and critical urgency accents.
- Shared shadow and border tokens.

Use the existing Dracula palette and capsule language. Caelestia's structural patterns are useful, but its Material You visual system should not replace the existing Signal Rail design.

## Test Plan

Verify:

- Signal Rail enters vertically from the top.
- No Quickshell surface slides from the left or right.
- Wallpaper changes crossfade without compositor movement.
- The old wallpaper remains visible until the new image is ready.
- Rapid wallpaper changes do not leave stale images or blank frames.
- Wallpaper selection works from Elephant.
- Fullscreen windows hide or suppress the correct surfaces.
- Reservation spacing remains unchanged.
- Notifications appear below the top-right utility capsule.
- Notifications stack, expire, dismiss, and clear correctly.
- DND suppresses popups but preserves history.
- Notification actions invoke correctly.
- History survives Quickshell reload and restart.
- No competing process owns `org.freedesktop.Notifications`.
- All implemented notification shortcuts work through Quickshell IPC.
- Multi-monitor wallpaper, Rail, and notification behavior remain independent.
- `notify-send`, a real Signal notification, and a Zen Browser notification are all received.

## Assumptions

- Wallpaper rendering will ultimately move from hyprpaper to Quickshell because that provides deterministic crossfading.
- The Signal Rail remains visually distinct from Caelestia even where its architecture is borrowed.
- Notifications use a top-right transient stack plus a separate history drawer.
- Existing unrelated changes in `base/.gitconfig` and `next.md` remain untouched.
- The Caelestia source remains a read-only design reference at `/tmp/caelestia-shell-reference`.
