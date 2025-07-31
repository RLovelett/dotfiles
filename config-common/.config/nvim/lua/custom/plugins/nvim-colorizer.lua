return {
  'norcalli/nvim-colorizer.lua',
  ft = { 'css', 'scss', 'sass', 'less', 'html', 'javascript', 'typescript', 'sh', 'zsh', 'bash' },
  config = function()
    vim.opt.termguicolors = true
    require('colorizer').setup({ '*' }, {
      RGB = true, -- #RGB
      RRGGBB = true, -- #RRGGBB
      RRGGBBAA = true, -- #RRGGBBAA
      rgb_fn = true, -- rgb(...) and rgba(...)
      hsl_fn = true, -- hsl(...) and hsla(...)
      css = true, -- all css formats
      css_fn = true, -- rgb(), hsl(), etc.
    })
  end,
}
