--- conf_gen.lua
--- Writes a Hyprlang-compatible variables file from a Lua table.
--- Only string values are emitted; non-string entries (functions, tables, etc.)
--- are silently skipped so callers can pass a module table directly.
---
--- Usage:
---   local conf_gen = require("modules.utils.conf_gen")
---   conf_gen.write("/path/to/output.conf", require("modules.colors"))
---
--- @module conf_gen

local M = {}

--- Writes a Hyprlang variables file to path from a flat key→value table.
--- Creates parent directories as needed. Each string entry becomes a line
--- of the form `$key = value`. The output file is stamped with a header
--- warning that it is auto-generated.
--- @param path string Absolute path to write the generated file to.
--- @param vars table Map of variable names to values; non-string values are skipped.
--- @return nil
function M.write(path, vars)
  local dir = path:match("^(.*)/[^/]+$")
  if dir then
    os.execute("mkdir -p " .. dir)
  end

  local f = io.open(path, "w")
  if f == nil then
    hl.notification.create({ text = "conf_gen: failed to write " .. path, timeout = 5000, icon = 3 })
    return
  end

  f:write("# AUTO-GENERATED — do not edit by hand\n")
  for k, v in pairs(vars) do
    if type(v) == "string" then
      f:write("$" .. k .. " = " .. v .. "\n")
    end
  end
  f:close()
end

return M
