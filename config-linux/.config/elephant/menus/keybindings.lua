Name = "keybindings"
NamePretty = "keybindings"
FixedOrder = true
HideFromProviderlist = false
Cache = false

--- @class Entry
--- @field Text string The display name / description of the keybinding
--- @field Subtext string The formatted key combination (e.g. "SUPER + T")
--- @field Value string The dispatcher and argument joined as a single string
--- @field Icon string The icon name for the entry

--- @type table<number, string> A map of numeric keycodes to their symbol names (e.g. 36 → "Return")
local KEYCODE_MAP = {}

---@type table<string, string> A map of raw key strings to human-readable display names
local KEY_NAMES = {
  -- Mouse
  ["mouse:272"] = "Left Click",
  ["mouse:273"] = "Right Click",
  ["mouse:274"] = "Middle Click",
  ["mouse_down"] = "Scroll Down",
  ["mouse_up"] = "Scroll Up",
  -- Media / XF86
  ["XF86AudioRaiseVolume"] = "Volume Up",
  ["XF86AudioLowerVolume"] = "Volume Down",
  ["XF86AudioMute"] = "Mute",
  ["XF86AudioMicMute"] = "Mute Microphone",
  ["XF86AudioPlay"] = "Play",
  ["XF86AudioPause"] = "Pause",
  ["XF86AudioNext"] = "Next Track",
  ["XF86AudioPrev"] = "Previous Track",
  ["XF86AudioStop"] = "Stop",
  ["XF86MonBrightnessUp"] = "Brightness Up",
  ["XF86MonBrightnessDown"] = "Brightness Down",
}

--- Populates `KEYCODE_MAP` with `table<number, string>` pairs
--- by compiling the keymap and parsing keycode/symbol pairs from it.
local function build_keycode_map()
  local handle = io.popen(
    "xkbcli compile-keymap | awk '\n"
      .. '  /xkb_keycodes/ { sec="codes"; next }\n'
      .. '  /xkb_symbols/  { sec="syms";  next }\n'
      .. '  sec=="codes" && match($0, /<([A-Za-z0-9_]+)>[[:space:]]*=[[:space:]]*([0-9]+)/, m) { code_by_name[m[1]] = m[2] }\n'
      .. '  sec=="syms"  && match($0, /key[[:space:]]*<([A-Za-z0-9_]+)>[[:space:]]*\\{[[:space:]]*\\[[[:space:]]*([^, \\]]+)/, m) { sym_by_name[m[1]] = m[2] }\n'
      .. '  END { for (k in code_by_name) { c = code_by_name[k]; s = sym_by_name[k]; if (c != "" && s != "" && s != "NoSymbol") print c "," s } }\n'
      .. "'"
  )
  if not handle then
    return
  end
  for line in handle:lines() do
    local code, sym = line:match("^(%d+),(.+)$")
    if code and sym then
      KEYCODE_MAP[tonumber(code)] = sym
    end
  end
  handle:close()
end
build_keycode_map()

--- Calculates the sort priority of a keybinding based on its description.
--- Lower values appear first. Defaults to 50 for unrecognized entries.
--- @param text string The keybinding description to evaluate
--- @return number priority A sort priority value between 0 and 99
local function get_priority(text)
  -- Applications
  if text:match("Terminal") then
    return 0
  end
  if text:match("Browser") then
    return 1
  end
  if text:match("Signal") then
    return 2
  end
  if text:match("1Password") then
    return 3
  end
  if text:match("Neovim") then
    return 4
  end
  if text:match("File manager") then
    return 5
  end
  if text:match("Obsidian") then
    return 6
  end
  if text:match("Typora") then
    return 7
  end
  if text:match("Launch apps") then
    return 8
  end
  if text:match("System menu") then
    return 9
  end

  -- Window management
  if text:match("Full screen") then
    return 11
  end
  if text:match("Full width") then
    return 12
  end
  if text:match("Close window") then
    return 13
  end
  if text:match("Toggle window floating") then
    return 14
  end
  if text:match("Toggle window split") then
    return 15
  end
  if text:match("Toggle workspace layout") then
    return 16
  end
  if text:match("Pop window") then
    return 17
  end

  -- Clipboard / input
  if text:match("Universal") then
    return 20
  end
  if text:match("Clipboard") then
    return 21
  end

  -- Controls and panels
  if text:match("Audio controls") then
    return 25
  end
  if text:match("Bluetooth") then
    return 26
  end
  if text:match("Wifi controls") then
    return 27
  end
  if text:match("System info") then
    return 28
  end
  if text:match("Activity") then
    return 29
  end

  -- Menus and pickers
  if text:match("Emoji picker") then
    return 32
  end
  if text:match("Color picker") then
    return 33
  end
  if text:match("Screenshot") then
    return 34
  end
  if text:match("Snippets") then
    return 35
  end
  if text:match("Wallpapers") then
    return 36
  end
  if text:match("Show key bindings") then
    return 37
  end
  if text:match("Show time") then
    return 38
  end
  if text:match("Zoom") then
    return 39
  end

  -- Workspace and monitor navigation
  if
    text:match("Switch.*workspace")
    or text:match("Next.*workspace")
    or text:match("Former.*workspace")
    or text:match("Previous.*workspace")
    or text:match("Move.*workspace")
    or text:match("Focus.*monitor")
  then
    return 42
  end
  if text:match("Move window to workspace") then
    return 43
  end
  if text:match("Move window silently") then
    return 44
  end
  if text:match("Move window to.*monitor") then
    return 45
  end

  -- Window movement and resizing
  if text:match("Swap window") then
    return 50
  end
  if text:match("Move window focus") then
    return 51
  end
  if text:match("Move window$") then
    return 52
  end
  if text:match("Resize window") then
    return 53
  end
  if text:match("Expand window") then
    return 54
  end
  if text:match("Shrink window") then
    return 55
  end

  -- Scratchpad
  if text:match("scratchpad") then
    return 60
  end

  -- Notifications
  if text:match("notification") or text:match("Notification") or text:match("do not disturb") then
    return 65
  end

  -- Groups
  if text:match("group") then
    return 80
  end

  -- Cycling / scrolling
  if text:match("Scroll active workspace") then
    return 85
  end
  if text:match("Cycle to") then
    return 86
  end
  if text:match("Reveal active") then
    return 87
  end

  return 99
end

local function resolve_key(key, keycode)
  if key ~= "" then
    return KEY_NAMES[key] or key
  end
  if keycode and keycode ~= 0 then
    return KEYCODE_MAP[keycode] or ("keycode:" .. keycode)
  end
  return "?"
end

--- Converts a modifier bitmask into a list of modifier name strings.
--- @param modmask number The bitmask representing active modifiers
--- @return string[] mods A list of modifier names (e.g. {"SUPER", "SHIFT"})
local function get_mods(modmask)
  local mods = {}
  if math.floor(modmask / 64) % 2 == 1 then
    -- table.insert(mods, "󰘳")
    table.insert(mods, "SUPER")
  end
  if math.floor(modmask / 8) % 2 == 1 then
    -- table.insert(mods, "󰘵")
    table.insert(mods, "ALT")
  end
  if math.floor(modmask / 4) % 2 == 1 then
    -- table.insert(mods, "󰘴")
    table.insert(mods, "CTRL")
  end
  if math.floor(modmask / 1) % 2 == 1 then
    -- table.insert(mods, "󰘶")
    table.insert(mods, "SHIFT")
  end
  return mods
end

function GetEntries()
  if next(KEYCODE_MAP) == nil then
    print("Rebuilding keycode map...")
    build_keycode_map()
  end

  local entries = {}
  local handle = io.popen("hyprctl binds -j")

  if not handle then
    return entries
  end

  local output = handle:read("*a")
  handle:close()

  if not output or output == "" then
    return entries
  end

  local status, data = pcall(jsonDecode, output)
  if not status then
    table.insert(entries, {
      Text = "JSON Error",
      Subtext = tostring(data),
    })
    return entries
  end

  for _, bind in ipairs(data) do
    local icon = bind.mouse and "input-mouse" or "preferences-desktop-keyboard-shortcuts"
    local modmask = bind.modmask or 0
    local keycode = bind.keycode or 0
    local desc = bind.description or ""
    local dispatch = bind.dispatcher or ""
    local arg = bind.arg or ""

    if desc == "" then
      goto continue
    end

    local key_name = resolve_key(bind.key or "", keycode)
    local mods_table = get_mods(modmask)
    local key_icons = table.concat(mods_table, " ")
    local display_keys = #mods_table > 0 and (key_icons .. " + " .. key_name) or key_name

    table.insert(entries, {
      Text = desc,
      Subtext = display_keys,
      Value = dispatch .. " " .. arg,
      Icon = icon,
    })

    ::continue::
  end

  table.sort(entries, function(a, b)
    local a_prior = get_priority(a.Text)
    local b_prior = get_priority(b.Text)
    return a_prior < b_prior
  end)

  return entries
end
