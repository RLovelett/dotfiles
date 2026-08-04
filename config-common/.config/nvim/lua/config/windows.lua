local M = {}

local function parent_split(layout, window)
  if layout[1] == 'leaf' then return nil end

  for _, child in ipairs(layout[2]) do
    if child[1] == 'leaf' and child[2] == window then return layout[1] end
    local split = parent_split(child, window)
    if split then return split end
  end
  return nil
end

local function resize(delta)
  local window = vim.api.nvim_get_current_win()
  local split = parent_split(vim.fn.winlayout(), window)
  if not split then
    vim.notify('No parent split to resize', vim.log.levels.INFO)
    return
  end

  if split == 'row' then
    local width = vim.api.nvim_win_get_width(window)
    vim.api.nvim_win_set_width(window, math.max(1, width + delta))
  else
    local height = vim.api.nvim_win_get_height(window)
    vim.api.nvim_win_set_height(window, math.max(1, height + delta))
  end
end

function M.setup()
  vim.keymap.set('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Window: Side-by-side split' })
  vim.keymap.set('n', '<leader>_', '<cmd>split<CR>', { desc = 'Window: Stacked split' })
  vim.keymap.set('n', '<leader>-', function() resize(-2) end, { desc = 'Window: Shrink current split' })
  vim.keymap.set('n', '<leader>=', function() resize(2) end, { desc = 'Window: Grow current split' })
end

return M
