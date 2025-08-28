-- ~/.config/nvim-new/plugin/plugins.lua
vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { load = true })

require("gitsigns").setup({ signcolumn = false })

vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({})
