--- Toggles the tiling layout of the active workspace between dwindle and scrolling.
---
--- Reads the current layout of the active workspace and switches to the other. Any layout
--- other than dwindle is treated as "not dwindle" and will toggle to dwindle. A notification
--- is displayed confirming the new layout.
---
--- Intended to be bound directly to a key:
---   local workspace_layout_toggle = require("modules.utils.workspace_layout_toggle")
---   hl.bind("SUPER + L", workspace_layout_toggle, { description = "Toggle workspace layout" })
---
---@return nil
local function workspace_layout_toggle()
  local ws = hl.get_active_workspace()
  if ws ~= nil then
    local workspace_id = tostring(ws.id)
    local new_layout = (ws.tiled_layout == "dwindle") and "master" or "dwindle"
    local message = "Workspace " .. workspace_id .. " layout changed from " .. ws.tiled_layout .. " to " .. new_layout
    hl.notification.create({ text = message, timeout = 3000, icon = 1 })
    hl.workspace_rule({ workspace = workspace_id, layout = new_layout })
  else
    hl.notification.create({
      text = "There is no active workspace",
      duration = 3000,
      icon = 3,
    })
  end
end

return workspace_layout_toggle
