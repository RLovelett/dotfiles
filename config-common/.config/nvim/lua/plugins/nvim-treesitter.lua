--- Ensure that the specified treesitter parsers are installed in Neovim.
-- This function checks the current list of installed parsers and installs any
-- missing parsers from the ensure_installed list. Additionally, it uninstalls
-- any parsers that are currently installed but not required.
--
-- This operation involves asynchronous installation and uninstallation of
-- parsers and prints the lists of installed and uninstalled parsers upon
-- completion. For synchronous operation (e.g., in a bootstrapping script),
-- you need to `wait()` for it:
-- @usage
-- local ts = require('nvim-treesitter')
-- local ensure_installed = {
--   'bash', 'python', 'lua', 'rust'
-- }
-- ensure_parsers_installed(ts, ensure_installed)
--
-- @param ts table: Treesitter module obtained by `require('nvim-treesitter')`.
-- @param ensure_installed string[]: List of parsers to ensure are installed.
local function ensure_parsers_installed(treesitter, parser_table)
  -- Get the installed parsers
  local installed_parsers = treesitter.get_installed()

  local to_uninstall = vim.iter(installed_parsers)
      :filter(function(parser) return not vim.tbl_contains(parser_table, parser) end)
      :totable()

  treesitter.install(to_install)

  -- Uninstall unnecessary parsers
  if #to_uninstall > 0 then
    treesitter.uninstall(to_uninstall)
  end
end

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'bitbake',
      'c',
      'c_sharp',
      'cmake',
      'cpp',
      'css',
      'csv',
      'diff',
      'dockerfile',
      'editorconfig',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'hcl',
      'html',
      'java',
      'javadoc',
      'jinja',
      'jinja_inline',
      'jq',
      'jsdoc',
      'json',
      'json5',
      'jsonc',
      'llvm',
      'lua',
      'luadoc',
      'make',
      'markdown',
      'markdown_inline',
      'mermaid',
      'ninja',
      'perl',
      'powershell',
      'python',
      'query',
      'rust',
      'scss',
      'sql',
      'ssh_config',
      'swift',
      'terraform',
      'tmux',
      'typescript',
      'vim',
      'vimdoc'
    }
  },
  config = function(_, opts)
    local ts = require('nvim-treesitter')
    ts.setup({})

    ensure_parsers_installed(ts, opts.ensure_installed)
  end,
}
