-- Floating window effects (all match tag floating-window, all different effect types)
hl.window_rule({
  match = { tag = "floating-window" },
  float = true,
  center = true,
  size = { 1600, 900 },
  animation = "slide",
  stay_focused = true,
})

local reverse_dns = "me.lovelett.hyprland"
local p = reverse_dns:gsub("%.", "\\.")

local floating_classes = {
  p .. "\\.bluetui",
  p .. "\\.impala",
  p .. "\\.wiremix",
  p .. "\\.btop",
  p .. "\\.fastfetch",
  p .. "\\.terminal",
  p .. "\\.bash",
  "org\\.gnome\\.NautilusPreviewer",
  "org\\.gnome\\.Evince",
  "com\\.gabm\\.satty",
  "Omarchy",
  "About",
  "TUI\\.float",
  "imv",
  "mpv",
}

-- Floating window sources: by class
hl.window_rule({
  match = {
    class = "(" .. table.concat(floating_classes, "|") .. ")",
  },
  tag = "+floating-window",
})

-- Floating window sources: file dialogs (python3 merged in, fixed regex bugs)
hl.window_rule({
  match = {
    class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org\\.gnome\\.Nautilus|python3)",
    title = "^(Open.*Files?|Open [Ff]older.*|Open|Save.*Files?|[Ss]ave [Aa]s.*|Save|All Files|.*wants to (?:open|save).*|[Cc]hoose.*|[Ff]ile [Uu]pload.*)",
  },
  tag = "+floating-window",
})

-- Floating window sources: browser about dialogs
hl.window_rule({
  match = { tag = "firefox-based-browser", title = "^[Aa]bout.*" },
  tag = "+floating-window",
})

-- Calculator
hl.window_rule({
  match = { class = "org\\.gnome\\.Calculator" },
  float = true,
})

-- Fullscreen screensaver
hl.window_rule({
  match = { class = reverse_dns .. ".screensaver" },
  fullscreen = true,
  float = true,
  animation = "slide",
})

-- No transparency on media windows
hl.window_rule({
  match = {
    class = "^(zoom|vlc|mpv|org\\.kde\\.kdenlive|com\\.obsproject\\.Studio|com\\.github\\.PintaProject\\.Pinta|imv|org\\.gnome\\.NautilusPreviewer)$",
  },
  tag = "-default-opacity",
  opacity = "1 1",
})

-- Popped window rounding
hl.window_rule({
  match = { tag = "pop" },
  rounding = 8,
})

-- Prevent idle while open
hl.window_rule({
  match = { tag = "noidle" },
  idle_inhibit = "always",
})
