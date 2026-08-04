local M = {}

--- Declare a Hyprland binding and, when visible, encode its guide metadata in
--- the description that Hyprland exposes through `hyprctl binds -j`.
---@param keys string
---@param dispatcher function|table
---@param spec table
function M.add(keys, dispatcher, spec)
  local options = {}
  for key, value in pairs(spec.options or {}) do
    options[key] = value
  end

  if spec.guide ~= false then
    assert(spec.category and spec.label, "guided bindings require a category and label")
    options.description = spec.category .. ": " .. spec.label
  end

  hl.bind(keys, dispatcher, options)
end

return M
