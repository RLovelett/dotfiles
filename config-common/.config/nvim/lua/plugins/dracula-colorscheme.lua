return {
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'Mofiqul/dracula.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    show_end_of_buffer = true,
    transparent_bg = true,
    lualine_bg_color = '#44475a',
    italic_comment = true,
  },
  init = function()
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'dracula'
  end,
}
