--- Toggles the active window between a pinned floating overlay and its normal tiled state.
---
--- On the first call, the window is floated, resized to the given dimensions, positioned
--- (or centered if no position is given), pinned so it persists across workspace switches,
--- raised to the top of the z-order, and tagged with "+pop" for window rule targeting.
---
--- On a subsequent call to a window already in the popped state, all of the above is
--- reversed: the window is unpinned, returned to tiling, and the "pop" tag is removed.
---
--- Intended to be bound to a key and called with no arguments for default behaviour:
---   local window_pop = require("modules.utils.window_pop")
---   hl.bind("SUPER + O", window_pop, { description = "Pop window out (float & pin)" })
---
--- Or called with explicit dimensions and position from another function:
---   window_pop(1600, 1000, 100, 50)
---
---@param width? integer Width of the floating window in pixels. Defaults to 1300.
---@param height? integer Height of the floating window in pixels. Defaults to 900.
---@param x? integer X screen coordinate to place the window. Must be provided together with y.
---@param y? integer Y screen coordinate to place the window. Must be provided together with x. If neither x nor y are provided, the window is centered on screen.
---@return nil
local function window_pop(width, height, x, y)
  width = width or 1300
  height = height or 900

  local w = hl.get_active_window()
  if w == nil then
    return
  end

  if w.pinned then
    hl.dispatch(hl.dsp.window.pin({ window = w }))
    hl.dispatch(hl.dsp.window.float({ action = "toggle", window = w }))
    hl.dispatch(hl.dsp.window.tag({ tag = "-pop", window = w }))
  else
    hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))
    hl.dispatch(hl.dsp.window.resize({ x = width, y = height, relative = false, window = w }))
    if x ~= nil and y ~= nil then
      hl.dispatch(hl.dsp.window.move({ x = x, y = y }))
    else
      hl.dispatch(hl.dsp.window.center({ window = w }))
    end
    hl.dispatch(hl.dsp.window.pin({ window = w }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top", window = w }))
    hl.dispatch(hl.dsp.window.tag({ tag = "+pop", window = w }))
  end
end

return window_pop
