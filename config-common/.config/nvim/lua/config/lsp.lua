-- LSP
-------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the LSP setup works in Neovim 0.11 and later.
--
-- This actually just enables the LSP servers.
-- The configuration is found in the LSP folder inside the nvim config folder,
-- so in ~/.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable({
  'bashls',
  'lua_ls'
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

-- Diagnostics
vim.diagnostic.config({
  -- Alternatively, customize specific options
  virtual_lines = true,
  update_in_insert = true,
})
