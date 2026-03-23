Name = "wallpaper"
NamePretty = "wallpaper"
FixedOrder = false
HideFromProviderlist = false
Cache = false

local home = os.getenv("HOME")
local data_home = os.getenv("XDG_DATA_HOME") or home .. "/.local/share"
local state_home = os.getenv("XDG_STATE_HOME") or home .. "/.local/state"
local wallpaper_dir = data_home .. "/backgrounds"
local wallpaper_state = state_home .. "/wallpaper"
local current_link = wallpaper_state .. "/current"

Actions = {
  activate = "lua:SetWallpaper",
}

local function ShellEscape(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function FormatName(filename)
  local name = filename:gsub("%.[^%.]+$", "")
  name = name:gsub("_?%d+[xX]%d+_?", "")
  name = name:gsub("[_%-]", " ")
  name = name:gsub("%S+", function(word)
    return word:sub(1, 1):upper() .. word:sub(2):lower()
  end)
  return name
end

function SetWallpaper(value)
  os.execute("mkdir -p " .. ShellEscape(wallpaper_state))
  os.execute("ln -sf " .. ShellEscape(value) .. " " .. ShellEscape(current_link))
  os.execute("hyprctl hyprpaper wallpaper '," .. current_link .. ",'")
end

function GetEntries()
  local entries = {}

  local handle = io.popen(
    "find -L "
      .. ShellEscape(wallpaper_dir)
      .. " -maxdepth 1 -type f \\( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.gif' -o -name '*.bmp' -o -name '*.webp' \\) 2>/dev/null | sort"
  )

  if handle then
    for background in handle:lines() do
      local filename = background:match("([^/]+)$")
      if filename then
        table.insert(entries, {
          Text = FormatName(filename),
          Subtext = background,
          Value = background,
          Preview = background,
          PreviewType = "file",
        })
      end
    end
    handle:close()
  end

  return entries
end
