local bind = require("modules.bindings.bind").add
local window_pop = require("modules.utils.window_pop")
local workspace_layout_toggle = require("modules.utils.workspace_layout_toggle")

-- Desktop grammar:
--   SUPER                  compositor/window action
--   SUPER + SHIFT          application launch (defined in utilities.lua)
--   SUPER + CTRL           utility or control surface
--   SUPER + ALT            move or alternate the current desktop object
--   H/J/K/L                left/down/up/right
--   number row             workspace target

bind("SUPER + W", hl.dsp.window.close(), { category = "Windows", label = "Close window" })
bind("SUPER + P", hl.dsp.window.pseudo(), { category = "Windows", label = "Toggle pseudotiling" })
bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), {
  category = "Windows",
  label = "Toggle floating",
})
bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), {
  category = "Windows",
  label = "Toggle fullscreen",
})
bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), {
  category = "Windows",
  label = "Toggle maximized",
})
bind("SUPER + O", window_pop, { category = "Windows", label = "Pop out and pin window" })
bind("SUPER + backslash", hl.dsp.layout("togglesplit"), {
  category = "Layout",
  label = "Rotate current split",
})
bind("SUPER + ALT + backslash", workspace_layout_toggle, {
  category = "Layout",
  label = "Toggle dwindle/master layout",
})

local directions = {
  { key = "H", arrow = "left", direction = "l", label = "left" },
  { key = "J", arrow = "down", direction = "d", label = "down" },
  { key = "K", arrow = "up", direction = "u", label = "up" },
  { key = "L", arrow = "right", direction = "r", label = "right" },
}

for _, direction in ipairs(directions) do
  local focus = hl.dsp.focus({ direction = direction.direction })
  local swap = hl.dsp.window.swap({ direction = direction.direction })

  bind("SUPER + " .. direction.key, focus, {
    category = "Navigation",
    label = "Focus " .. direction.label,
  })
  bind("SUPER + " .. direction.arrow, focus, { guide = false })

  bind("SUPER + ALT + " .. direction.key, swap, {
    category = "Windows",
    label = "Swap window " .. direction.label,
  })
  bind("SUPER + ALT + " .. direction.arrow, swap, { guide = false })
end

local workspace_keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
for index, key in ipairs(workspace_keys) do
  bind("SUPER + " .. key, hl.dsp.focus({ workspace = index }), {
    category = "Workspaces",
    label = "Switch to workspace " .. index,
  })
  bind("SUPER + ALT + " .. key, hl.dsp.window.move({ workspace = index }), {
    category = "Workspaces",
    label = "Move window to workspace " .. index,
  })
  bind("SUPER + CTRL + ALT + " .. key, hl.dsp.window.move({ workspace = index, follow = false }), {
    category = "Workspaces",
    label = "Move window silently to workspace " .. index,
  })
end

bind("SUPER + Tab", hl.dsp.focus({ workspace = "e+1" }), {
  category = "Workspaces",
  label = "Next workspace",
})
bind("SUPER + ALT + Tab", hl.dsp.focus({ workspace = "e-1" }), {
  category = "Workspaces",
  label = "Previous workspace",
})
bind("SUPER + CTRL + Tab", hl.dsp.focus({ workspace = "previous" }), {
  category = "Workspaces",
  label = "Former workspace",
})
bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), {
  category = "Workspaces",
  label = "Next workspace by scrolling",
})
bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), {
  category = "Workspaces",
  label = "Previous workspace by scrolling",
})

bind("SUPER + comma", hl.dsp.focus({ monitor = "l" }), {
  category = "Monitors",
  label = "Focus left monitor",
})
bind("SUPER + period", hl.dsp.focus({ monitor = "r" }), {
  category = "Monitors",
  label = "Focus right monitor",
})
bind("SUPER + ALT + comma", hl.dsp.window.move({ monitor = "l" }), {
  category = "Monitors",
  label = "Move window to left monitor",
})
bind("SUPER + ALT + period", hl.dsp.window.move({ monitor = "r" }), {
  category = "Monitors",
  label = "Move window to right monitor",
})
bind("SUPER + CTRL + ALT + comma", hl.dsp.workspace.move({ monitor = "l" }), {
  category = "Monitors",
  label = "Move workspace to left monitor",
})
bind("SUPER + CTRL + ALT + period", hl.dsp.workspace.move({ monitor = "r" }), {
  category = "Monitors",
  label = "Move workspace to right monitor",
})

bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = -100, relative = true }), {
  category = "Windows",
  label = "Shrink window",
  options = { repeating = true },
})
bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 100, relative = true }), {
  category = "Windows",
  label = "Grow window",
  options = { repeating = true },
})

bind("ALT + Tab", hl.dsp.window.cycle_next(), {
  category = "Navigation",
  label = "Cycle to next window",
})
-- The companion dispatcher raises the newly focused floating window; it is an
-- implementation detail of the Alt-Tab action, not a second user-facing bind.
bind("ALT + Tab", hl.dsp.window.bring_to_top(), { guide = false })
bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), {
  category = "Navigation",
  label = "Cycle to previous window",
})
bind("ALT + SHIFT + Tab", hl.dsp.window.bring_to_top(), { guide = false })

bind("SUPER + mouse:272", hl.dsp.window.drag(), {
  category = "Windows",
  label = "Drag window",
  options = { mouse = true },
})
bind("SUPER + mouse:273", hl.dsp.window.resize(), {
  category = "Windows",
  label = "Resize window with mouse",
  options = { mouse = true },
})

bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"), {
  category = "Scratchpad",
  label = "Toggle scratchpad",
})
bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), {
  category = "Scratchpad",
  label = "Move window to scratchpad",
})

bind("SUPER + G", hl.dsp.group.toggle(), { category = "Groups", label = "Toggle window group" })
bind("SUPER + ALT + G", hl.dsp.window.move({ out_of_group = true }), {
  category = "Groups",
  label = "Leave window group",
})
bind("SUPER + ALT + N", hl.dsp.group.next(), { category = "Groups", label = "Next grouped window" })
bind("SUPER + ALT + P", hl.dsp.group.prev(), { category = "Groups", label = "Previous grouped window" })
