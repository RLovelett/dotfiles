local window_pop = require("modules.utils.window_pop")
local workspace_layout_toggle = require("modules.utils.workspace_layout_toggle")

-- Close windows
hl.bind("SUPER + W", hl.dsp.window.close(), { description = "Close window" })
-- hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("omarchy-hyprland-window-close-all"), { description = "Close all windows" })

-- Control tiling
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" }) -- dwindle only
hl.bind("SUPER + P", hl.dsp.window.pseudo(), { description = "Pseudo window" }) -- dwindle
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle window floating/tiling" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Full screen" })
hl.bind(
  "SUPER + CTRL + F",
  hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }),
  { description = "Tiled full screen" }
)
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })
hl.bind("SUPER + O", window_pop, { description = "Pop window out (float & pin)" })
hl.bind("SUPER + L", workspace_layout_toggle, { description = "Toggle workspace layout" })

-- Move focus with SUPER + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }), { description = "Move window focus left" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }), { description = "Move window focus right" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }), { description = "Move window focus up" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }), { description = "Move window focus down" })

-- Switch / move / move-silently workspaces with SUPER + [1-0], collapsed into loops
for i = 1, 10 do
  hl.bind("SUPER + code:" .. (9 + i), hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
  hl.bind(
    "SUPER + SHIFT + code:" .. (9 + i),
    hl.dsp.window.move({ workspace = i }),
    { description = "Move window to workspace " .. i }
  )
  hl.bind(
    "SUPER + SHIFT + ALT + code:" .. (9 + i),
    hl.dsp.window.move({ workspace = i, follow = false }),
    { description = "Move window silently to workspace " .. i }
  )
end

-- Control scratchpad
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle scratchpad" })
hl.bind(
  "SUPER + ALT + S",
  hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }),
  { description = "Move window to scratchpad" }
)

-- TAB between workspaces
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind("SUPER + CTRL + Tab", hl.dsp.focus({ workspace = "previous" }), { description = "Former workspace" })

-- Move workspaces to other monitors
hl.bind(
  "SUPER + SHIFT + ALT + left",
  hl.dsp.workspace.move({ monitor = "l" }),
  { description = "Move workspace to left monitor" }
)
hl.bind(
  "SUPER + SHIFT + ALT + right",
  hl.dsp.workspace.move({ monitor = "r" }),
  { description = "Move workspace to right monitor" }
)
hl.bind(
  "SUPER + SHIFT + ALT + up",
  hl.dsp.workspace.move({ monitor = "u" }),
  { description = "Move workspace to up monitor" }
)
hl.bind(
  "SUPER + SHIFT + ALT + down",
  hl.dsp.workspace.move({ monitor = "d" }),
  { description = "Move workspace to down monitor" }
)

-- Focus and move windows between monitors
hl.bind("SUPER + comma", hl.dsp.focus({ monitor = "l" }), { description = "Focus left monitor" })
hl.bind("SUPER + period", hl.dsp.focus({ monitor = "r" }), { description = "Focus right monitor" })
hl.bind("SUPER + SHIFT + comma", hl.dsp.window.move({ monitor = "l" }), { description = "Move window to left monitor" })
hl.bind(
  "SUPER + SHIFT + period",
  hl.dsp.window.move({ monitor = "r" }),
  { description = "Move window to right monitor" }
)

-- Swap active window with the one next to it with SUPER + SHIFT + arrow keys
hl.bind("SUPER + SHIFT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window to the left" })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window to the right" })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

-- Cycle through applications on active workspace
-- Two dispatchers on the same key: bind them back-to-back (executed in order)
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle to next window" })
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top(), { description = "Reveal active window on top" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), { description = "Cycle to prev window" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.bring_to_top(), { description = "Reveal active window on top" })

-- Resize active window (code:20 = minus, code:21 = equals)
hl.bind(
  "SUPER + code:20",
  hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
  { description = "Expand window left" }
)
hl.bind(
  "SUPER + code:21",
  hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
  { description = "Shrink window left" }
)
hl.bind(
  "SUPER + SHIFT + code:20",
  hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
  { description = "Shrink window up" }
)
hl.bind(
  "SUPER + SHIFT + code:21",
  hl.dsp.window.resize({ x = 0, y = 100, relative = true }),
  { description = "Expand window down" }
)

-- Scroll through existing workspaces with SUPER + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll active workspace forward" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll active workspace backward" })

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Toggle groups
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle window grouping" })
hl.bind(
  "SUPER + ALT + G",
  hl.dsp.window.move({ out_of_group = true }),
  { description = "Move active window out of group" }
)

-- Join groups
hl.bind(
  "SUPER + ALT + left",
  hl.dsp.window.move({ into_group = "l" }),
  { description = "Move window to group on left" }
)
hl.bind(
  "SUPER + ALT + right",
  hl.dsp.window.move({ into_group = "r" }),
  { description = "Move window to group on right" }
)
hl.bind("SUPER + ALT + up", hl.dsp.window.move({ into_group = "u" }), { description = "Move window to group on top" })
hl.bind(
  "SUPER + ALT + down",
  hl.dsp.window.move({ into_group = "d" }),
  { description = "Move window to group on bottom" }
)

-- Navigate a single set of grouped windows
hl.bind("SUPER + ALT + Tab", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind("SUPER + ALT + SHIFT + Tab", hl.dsp.group.prev(), { description = "Previous window in group" })

-- Window navigation for grouped windows
hl.bind("SUPER + CTRL + left", hl.dsp.group.prev(), { description = "Move grouped window focus left" })
hl.bind("SUPER + CTRL + right", hl.dsp.group.next(), { description = "Move grouped window focus right" })

-- Scroll through a set of grouped windows with SUPER + ALT + scroll
hl.bind("SUPER + ALT + mouse_down", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind("SUPER + ALT + mouse_up", hl.dsp.group.prev(), { description = "Previous window in group" })

-- Activate window in a group by number (1-5), collapsed into a loop
for i = 1, 5 do
  hl.bind(
    "SUPER + ALT + code:" .. (9 + i),
    hl.dsp.group.active({ index = i }),
    { description = "Switch to group window " .. i }
  )
end

-- Cycle monitor scaling
-- hl.bind("SUPER + slash", hl.dsp.exec_cmd("omarchy-hyprland-monitor-scaling-cycle"), { description = "Cycle monitor scaling" })
