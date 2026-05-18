local cache = os.getenv("XDG_CACHE_HOME")
if cache == nil then
  hl.notification.create({ text = "XDG_CACHE_HOME is not set — skipping color conf generation", timeout = 5000, icon = 3 })
else
  local conf_gen = require("modules.utils.conf_gen")
  local colors   = require("modules.colors")
  conf_gen.write(cache .. "/hypr/colors.conf", colors)
end

require("modules.monitors")
require("modules.workspaces")
require("modules.input")
require("modules.looknfeel")
require("modules.windows")
require("modules.autostart")
require("modules.bindings.media")
require("modules.bindings.clipboard")
require("modules.bindings.tiling")
require("modules.bindings.utilities")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
