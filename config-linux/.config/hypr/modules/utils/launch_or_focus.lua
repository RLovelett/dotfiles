--- Focuses an existing window matching the given selector, or launches a command if none is found.
---
--- Useful for keeping only one instance of an application open at a time. If a matching
--- window already exists on any workspace, focus switches to it immediately. If no match
--- is found, the launch command is executed to start a new instance.
---
--- The window selector follows Hyprland's window addressing syntax, e.g.:
---   "class:^signal$"  -- match by window class (regex)
---   "title:Obsidian"  -- match by window title
---
--- Example:
---   local launch_or_focus = require("modules.utils.launch_or_focus")
---   hl.bind("SUPER + SHIFT + G", function()
---     launch_or_focus("class:^signal$", "uwsm app -- signal-desktop")
---   end, { description = "Signal" })
---
---@param window_selector string A Hyprland window selector string used to find an existing window.
---@param launch_cmd string The shell command to execute if no matching window is found.
---@return nil
local function launch_or_focus(window_selector, launch_cmd)
  local w = hl.get_window(window_selector)
  if w ~= nil then
    hl.dispatch(hl.dsp.focus({ window = w }))
  else
    hl.dispatch(hl.dsp.exec_cmd(launch_cmd))
  end
end

return launch_or_focus
