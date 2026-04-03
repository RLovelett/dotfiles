return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = 'BufReadPre', -- Lazy-load when opening a file
  opts = {
    default_mappings = false,
  },
  config = function(_, opts)
    require('git-conflict').setup(opts)

    local wk = require 'which-key'

    -- Workaround: remove once https://github.com/akinsho/git-conflict.nvim/pull/122 is merged
    -- Neovim 0.10+ replaced vim.diagnostic.disable(bufnr) with
    -- vim.diagnostic.enable(false, { bufnr = bufnr })
    local AUGROUP_NAME = 'GitConflictDiagnostics'
    vim.api.nvim_create_augroup(AUGROUP_NAME, { clear = true })

    vim.api.nvim_create_autocmd('User', {
      group = AUGROUP_NAME,
      pattern = 'GitConflictDetected',
      callback = function(args)
        local bufnr = args.buf
        local map = function(key, cmd, desc)
          vim.keymap.set('n', key, cmd, { buffer = bufnr, desc = desc })
        end
        -- Add which-key bindings for plugin commands
        wk.add {
          buffer = bufnr,
          { '<leader>g', group = '[G]it Conflict' },
        }
        map('<leader>go', '<cmd>GitConflictChooseOurs<cr>', '[G]it Conflict: Choose [O]urs')
        map('<leader>gt', '<cmd>GitConflictChooseTheirs<cr>', '[G]it Conflict: Choose [T]heirs')
        map('<leader>gb', '<cmd>GitConflictChooseBoth<cr>', '[G]it Conflict: Choose [B]oth')
        map('<leader>gn', '<cmd>GitConflictChooseNone<cr>', '[G]it Conflict: Choose [N]one')
        map('<leader>gq', '<cmd>GitConflictListQf<cr>', '[G]it Conflict: List in [Q]uickfix')
        map(']x', '<cmd>GitConflictNextConflict<cr>', 'Git Conflict: Next')
        map('[x', '<cmd>GitConflictPrevConflict<cr>', 'Git Conflict: Previous')
        -- Workaround: remove once https://github.com/akinsho/git-conflict.nvim/pull/122 is merged
        vim.diagnostic.enable(false, { bufnr = bufnr })
        vim.notify('Git conflict detected — diagnostics paused', vim.log.levels.WARN)
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = AUGROUP_NAME,
      pattern = 'GitConflictResolved',
      callback = function(args)
        local bufnr = args.buf
        -- Remove the which-key bindings for the plugin commands
        local keys = { '<leader>go', '<leader>gt', '<leader>gb', '<leader>gn', '<leader>gq', ']x', '[x' }
        for _, key in ipairs(keys) do
          pcall(vim.keymap.del, 'n', key, { buffer = bufnr })
        end
        -- Workaround: remove once https://github.com/akinsho/git-conflict.nvim/pull/122 is merged
        vim.diagnostic.enable(true, { bufnr = bufnr })
        vim.notify('Git conflicts resolved — diagnostics resumed', vim.log.levels.INFO)
      end,
    })
  end,
}
