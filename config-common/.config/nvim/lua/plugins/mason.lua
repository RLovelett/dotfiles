return {
  'mason-org/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Listed as a dependency to ensure blink.cmp is loaded before this
    -- plugin's config runs, so we can broadcast its capabilities to all
    -- LSP servers via vim.lsp.config('*', ...).
    'saghen/blink.cmp',
  },
  config = function()
    require('mason').setup()

    -- Broadcast blink.cmp's extended capabilities to all LSP servers globally.
    -- Must be called before any server starts (i.e. before any file is opened).
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    -- Ensure the following tools are installed via Mason.
    -- Note: Mason package names differ from LSP server names (e.g.
    -- 'lua-language-server' installs the binary that lua_ls uses).
    -- Tools not listed here (bashls, hyprls, taplo) are expected to be
    -- installed via the system package manager or cargo.
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- LSP servers
        'bash-language-server',
        'css-lsp',
        'hyprls',
        'json-lsp',
        'lua-language-server',
        'pyright',
        'ruff',
        'taplo',
        -- Formatters
        'stylua',
      },
    }
  end,
}
