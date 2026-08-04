Name = "keybindings"
NamePretty = "Hyprland Keybindings"
Description = "Search the effective Hyprland keybindings"
Icon = "preferences-desktop-keyboard-shortcuts"
SearchName = true
FixedOrder = true
HideFromProviderlist = false
Cache = false

local CATEGORY_ORDER = {
  Applications = 10,
  Menus = 20,
  Navigation = 30,
  Windows = 40,
  Layout = 50,
  Workspaces = 60,
  Monitors = 70,
  Scratchpad = 80,
  Groups = 90,
  Clipboard = 100,
  Capture = 110,
  Media = 120,
  Notifications = 130,
  Utilities = 140,
  Accessibility = 150,
  Other = 999,
}

local KEY_NAMES = {
  ["mouse:272"] = "Left click",
  ["mouse:273"] = "Right click",
  mouse_down = "Scroll down",
  mouse_up = "Scroll up",
  minus = "−",
  equal = "+",
  backslash = "\\",
  comma = ",",
  period = ".",
  slash = "/",
  XF86AudioRaiseVolume = "Volume up",
  XF86AudioLowerVolume = "Volume down",
  XF86AudioMute = "Mute",
  XF86AudioMicMute = "Mute microphone",
  XF86AudioPlay = "Play",
  XF86AudioPause = "Pause",
  XF86AudioNext = "Next track",
  XF86AudioPrev = "Previous track",
}

local function modifiers(mask)
  local names = {}
  if math.floor(mask / 64) % 2 == 1 then table.insert(names, "SUPER") end
  if math.floor(mask / 4) % 2 == 1 then table.insert(names, "CTRL") end
  if math.floor(mask / 8) % 2 == 1 then table.insert(names, "ALT") end
  if math.floor(mask / 1) % 2 == 1 then table.insert(names, "SHIFT") end
  return names
end

local function chord(binding)
  local key = binding.key or ""
  if key == "" and binding.keycode and binding.keycode ~= 0 then
    key = "keycode:" .. binding.keycode
  end
  if key == "" then key = "Unknown" end
  key = KEY_NAMES[key] or key

  local parts = modifiers(binding.modmask or 0)
  table.insert(parts, key)
  return table.concat(parts, " + ")
end

local function metadata(description)
  local category, label = description:match("^([^:]+):%s*(.+)$")
  if not category then return "Other", description end
  return category, label
end

function GetEntries()
  local handle = io.popen("hyprctl binds -j")
  if not handle then return {} end

  local output = handle:read("*a")
  handle:close()
  if not output or output == "" then return {} end

  local ok, bindings = pcall(jsonDecode, output)
  if not ok then
    return {{ Text = "Unable to read Hyprland keybindings", Subtext = tostring(bindings), Icon = Icon }}
  end

  local entries = {}
  for _, binding in ipairs(bindings) do
    local description = binding.description or ""
    if description ~= "" then
      local category, label = metadata(description)
      local keys = chord(binding)
      table.insert(entries, {
        Text = label,
        Subtext = keys .. " · " .. category,
        Value = (binding.dispatcher or "") .. " " .. (binding.arg or ""),
        Icon = binding.mouse and "input-mouse" or Icon,
        Keywords = { category, keys, description },
        Category = category,
      })
    end
  end

  table.sort(entries, function(a, b)
    local category_a = CATEGORY_ORDER[a.Category] or CATEGORY_ORDER.Other
    local category_b = CATEGORY_ORDER[b.Category] or CATEGORY_ORDER.Other
    if category_a ~= category_b then return category_a < category_b end
    if a.Text ~= b.Text then return a.Text < b.Text end
    return a.Subtext < b.Subtext
  end)

  return entries
end
