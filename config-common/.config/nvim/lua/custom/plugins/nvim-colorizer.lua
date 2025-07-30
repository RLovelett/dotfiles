return {
  'norcalli/nvim-colorizer.lua',
  ft = { 'css', 'scss', 'sass', 'less', 'html', 'javascript', 'typescript' },
  config = function()
    vim.opt.termguicolors = true
    require('colorizer').setup({ '*' }, {
      RGB = true, -- #RGB
      RRGGBB = true, -- #RRGGBB
      RRGGBBAA = true, -- #RRGGBBAA
      css = true, -- all css formats
      css_fn = true, -- rgb(), hsl(), etc.
    })
  end,
}
