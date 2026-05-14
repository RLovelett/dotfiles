-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
-- Hyprland 0.53+ syntax
hl.window_rule({
  match = { class = ".*" },
  suppress_event = "maximize",
})
hl.window_rule({
  match = { fullscreen = true },
  idle_inhibit = "fullscreen",
})

-- Tag all windows for default opacity (apps can override with -default-opacity tag)
hl.window_rule({
  match = { class = ".*" },
  tag = "+default-opacity",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- App-specific tweaks (may remove default-opacity tag)
require("modules.apps")

-- Apply default opacity after apps have had a chance to opt out
hl.window_rule({
  match = { tag = "default-opacity" },
  opacity = "0.97 0.9",
})
