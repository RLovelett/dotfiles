-- Modifier key conventions are defined alongside the window bindings in
-- tiling.lua. This module owns the application and utility layers.
--
-- Special keys (intentional exceptions to the letter convention):
--   SUPER + SPACE             Launch apps (walker)
--   SUPER + ESCAPE            System menu (walker)
local launcher = require("modules.utils.launcher")
local terminal_cwd = require("modules.utils.terminal-cwd")

-- Application launchers
hl.bind("SUPER + SHIFT + Return", function()
  hl.dispatch(
    hl.dsp.exec_cmd(
      'uwsm app -- xdg-terminal-exec --dir="' .. terminal_cwd.get() .. '" -e tmux new-session -A -s default -n default'
    )
  )
end, { description = "Applications: Terminal" })
hl.bind("SUPER + SHIFT + ALT + Return", function()
  hl.dispatch(hl.dsp.exec_cmd('uwsm app -- xdg-terminal-exec --dir="' .. terminal_cwd.get() .. '" -e tmux new-session'))
end, { description = "Applications: Terminal (new session)" })
hl.bind("SUPER + SHIFT + B", function()
  launcher.browser()
end, { description = "Applications: Browser" })
hl.bind("SUPER + SHIFT + ALT + B", function()
  launcher.browser({ private = true })
end, { description = "Applications: Browser (private)" })
hl.bind("SUPER + SHIFT + E", function()
  launcher.tui("nvim")
end, { description = "Applications: Neovim" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("uwsm app -- nautilus --new-window"), { description = "Applications: File manager" })
hl.bind("SUPER + ALT + SHIFT + F", function()
  hl.dispatch(hl.dsp.exec_cmd('uwsm app -- nautilus --new-window "' .. terminal_cwd.get() .. '"'))
end, { description = "Applications: File manager (cwd)" })
hl.bind("SUPER + SHIFT + G", function()
  launcher.launch_or_focus("class:^signal$", "uwsm-app -- signal-desktop --password-store=gnome-libsecret")
end, { description = "Applications: Signal" })
hl.bind("SUPER + SHIFT + O", function()
  launcher.launch_or_focus("class:^obsidian$", "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime")
end, { description = "Applications: Obsidian" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("uwsm app -- typora --enable-wayland-ime"), { description = "Applications: Typora" })
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd("uwsm app -- 1password"), { description = "Applications: 1Password" })

-- Menus (SUPER CTRL + letter)
local walker = "walker --width 644 --maxheight 300 --minheight 300"
hl.bind(
  "SUPER + space",
  hl.dsp.exec_cmd(walker),
  { description = "Menus: Launch applications" }
)
hl.bind(
  "SUPER + Escape",
  hl.dsp.exec_cmd(walker .. ' --provider "menus:system"'),
  { description = "Menus: System menu" }
)
hl.bind(
  "SUPER + CTRL + E",
  hl.dsp.exec_cmd(walker .. " --provider symbols"),
  { description = "Menus: Emoji picker" }
)
hl.bind(
  "SUPER + CTRL + S",
  hl.dsp.exec_cmd(walker .. " --provider snippets"),
  { description = "Menus: Snippets" }
)
hl.bind(
  "SUPER + CTRL + V",
  hl.dsp.exec_cmd(walker .. " --provider clipboard"),
  { description = "Menus: Clipboard manager" }
)
hl.bind(
  "SUPER + CTRL + P",
  hl.dsp.exec_cmd('walker --width 900 --maxheight 900 --minheight 500 --provider "menus:wallpaper"'),
  { description = "Menus: Wallpapers" }
)
hl.bind(
  "SUPER + CTRL + K",
  hl.dsp.exec_cmd('walker --width 800 --maxheight 900 --minheight 300 --provider "menus:keybindings"'),
  { description = "Menus: Show key bindings" }
)

-- Notification history and DND intentionally remain unbound until Signal Rail
-- implements those features instead of exposing placeholder behavior.
hl.bind(
  "SUPER + CTRL + N",
  hl.dsp.exec_cmd("qs -c signal-rail ipc call notifications dismissLatest"),
  { description = "Notifications: Dismiss last notification" }
)
hl.bind(
  "SUPER + CTRL + ALT + N",
  hl.dsp.exec_cmd("qs -c signal-rail ipc call notifications clear"),
  { description = "Notifications: Dismiss all notifications" }
)

-- Captures
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"), { description = "Capture: Screenshot region" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m window"), { description = "Capture: Screenshot window" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m output"), { description = "Capture: Screenshot output" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Capture: Color picker" })

-- Waybar-less information
hl.bind(
  "SUPER + CTRL + ALT + T",
  hl.dsp.exec_cmd('notify-send "    $(date +"%A %H:%M  —  %d %B W%V %Y")"'),
  { description = "Utilities: Show time" }
)

-- Control panels
hl.bind("SUPER + CTRL + A", function()
  launcher.tui("wiremix")
end, { description = "Utilities: Audio controls" })
hl.bind("SUPER + CTRL + B", function()
  hl.dispatch(hl.dsp.exec_cmd("rfkill unblock bluetooth"))
  launcher.tui("bluetui")
end, { description = "Utilities: Bluetooth" })
hl.bind("SUPER + CTRL + I", function()
  launcher.tui("fastfetch", {
    cmd = "bash -c \"fastfetch; read -rsp $'\\nPress any key to close...' -n1\"",
  })
end, { description = "Utilities: System information" })
hl.bind("SUPER + CTRL + T", function()
  launcher.tui("btop")
end, { description = "Utilities: Activity monitor" })
hl.bind("SUPER + CTRL + W", function()
  hl.dispatch(hl.dsp.exec_cmd("rfkill unblock wifi"))
  launcher.tui("impala")
end, { description = "Utilities: Wi-Fi controls" })

-- Zoom
hl.bind("SUPER + CTRL + Z", function()
  local current = hl.get_config("cursor:zoom_factor")
  hl.config({ cursor = { zoom_factor = current + 1 } })
end, { description = "Accessibility: Zoom in" })

hl.bind("SUPER + CTRL + ALT + Z", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end, { description = "Accessibility: Reset zoom" })
