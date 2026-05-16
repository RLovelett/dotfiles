-- Modifier key conventions:
--   SUPER + letter            Window/workspace actions (see tiling-v2.conf)
--   SUPER SHIFT + letter      Application launchers
--   SUPER CTRL + letter       System/control panels and menus
--   SUPER ALT + letter        Window variants / secondary actions
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
end, { description = "Terminal" })
hl.bind("SUPER + SHIFT + ALT + Return", function()
  hl.dispatch(hl.dsp.exec_cmd('uwsm app -- xdg-terminal-exec --dir="' .. terminal_cwd.get() .. '" -e tmux new-session'))
end, { description = "Terminal (new session)" })
hl.bind("SUPER + SHIFT + B", function()
  launcher.browser()
end, { description = "Browser" })
hl.bind("SUPER + SHIFT + ALT + B", function()
  launcher.browser({ private = true })
end, { description = "Browser (private)" })
hl.bind("SUPER + SHIFT + E", function()
  launcher.tui("nvim")
end, { description = "Neovim" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("uwsm app -- nautilus --new-window"), { description = "File manager" })
hl.bind("SUPER + ALT + SHIFT + F", function()
  hl.dispatch(hl.dsp.exec_cmd('uwsm app -- nautilus --new-window "' .. terminal_cwd.get() .. '"'))
end, { description = "File manager (cwd)" })
hl.bind("SUPER + SHIFT + G", function()
  launcher.launch_or_focus("class:^signal$", "uwsm-app -- signal-desktop --password-store=gnome-libsecret")
end, { description = "Signal" })
hl.bind("SUPER + SHIFT + O", function()
  launcher.launch_or_focus("class:^obsidian$", "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime")
end, { description = "Obsidian" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("uwsm app -- typora --enable-wayland-ime"), { description = "Typora" })
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd("uwsm app -- 1password"), { description = "1Password" })

-- Menus (SUPER CTRL + letter)
hl.bind(
  "SUPER + space",
  hl.dsp.exec_cmd("walker --width 644 --maxheight 300 --minheight 300"),
  { description = "Launch apps" }
)
hl.bind(
  "SUPER + Escape",
  hl.dsp.exec_cmd('walker --width 644 --maxheight 300 --minheight 300 --provider "menus:system"'),
  { description = "System menu" }
)
hl.bind(
  "SUPER + CTRL + E",
  hl.dsp.exec_cmd("walker --width 644 --maxheight 300 --minheight 300 --provider symbols"),
  { description = "Emoji picker" }
)
hl.bind(
  "SUPER + CTRL + S",
  hl.dsp.exec_cmd("walker --width 644 --maxheight 300 --minheight 300 --provider snippets"),
  { description = "Snippets" }
)
hl.bind(
  "SUPER + CTRL + V",
  hl.dsp.exec_cmd("walker --width 644 --maxheight 300 --minheight 300 --provider clipboard"),
  { description = "Clipboard manager" }
)
hl.bind(
  "SUPER + CTRL + P",
  hl.dsp.exec_cmd('walker --width 900 --maxheight 900 --minheight 500 --provider "menus:wallpaper"'),
  { description = "Wallpapers" }
)
hl.bind(
  "SUPER + CTRL + K",
  hl.dsp.exec_cmd('walker --width 800 --maxheight 900 --minheight 300 --provider "menus:keybindings"'),
  { description = "Show key bindings" }
)

-- Notifications
hl.bind(
  "SUPER + CTRL + N",
  hl.dsp.exec_cmd("swaync-client --toggle-panel"),
  { description = "Toggle notifications panel" }
)
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client --toggle-dnd"), { description = "Toggle do not disturb" })
hl.bind(
  "SUPER + ALT + N",
  hl.dsp.exec_cmd("swaync-client --close-latest"),
  { description = "Dismiss last notification" }
)
hl.bind(
  "SUPER + SHIFT + ALT + N",
  hl.dsp.exec_cmd("swaync-client --close-all"),
  { description = "Dismiss all notifications" }
)
-- hl.bind("SUPER + CTRL + N",     hl.dsp.exec_cmd("swaync-client --action 0"),      { description = "Invoke last notification" })

-- Captures
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"), { description = "Screenshot (region)" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m window"), { description = "Screenshot (window)" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m output"), { description = "Screenshot (output)" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picker" })

-- Waybar-less information
hl.bind(
  "SUPER + CTRL + ALT + T",
  hl.dsp.exec_cmd('notify-send "    $(date +"%A %H:%M  —  %d %B W%V %Y")"'),
  { description = "Show time" }
)

-- Control panels
hl.bind("SUPER + CTRL + A", function()
  launcher.tui("wiremix")
end, { description = "Audio controls" })
hl.bind("SUPER + CTRL + B", function()
  hl.dispatch(hl.dsp.exec_cmd("rfkill unblock bluetooth"))
  launcher.tui("bluetui")
end, { description = "Bluetooth" })
hl.bind("SUPER + CTRL + I", function()
  launcher.tui("fastfetch", {
    cmd = "bash -c \"fastfetch; read -rsp $'\\nPress any key to close...' -n1\"",
  })
end, { description = "System info" })
hl.bind("SUPER + CTRL + T", function()
  launcher.tui("btop")
end, { description = "Activity" })
hl.bind("SUPER + CTRL + W", function()
  hl.dispatch(hl.dsp.exec_cmd("rfkill unblock wifi"))
  launcher.tui("impala")
end, { description = "Wifi controls" })

-- Zoom
hl.bind("SUPER + CTRL + Z", function()
  local current = hl.get_config("cursor:zoom_factor")
  hl.config({ cursor = { zoom_factor = current + 1 } })
end, { description = "Zoom in" })

hl.bind("SUPER + CTRL + ALT + Z", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end, { description = "Reset zoom" })
