return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  on_attach = function(_, bufnr)
    -- GTK CSS uses non-standard syntax (@color-name in values, lighter(), alpha(), etc.)
    -- that the CSS language server cannot be taught to accept. Disable diagnostics entirely
    -- for GTK theme files to avoid false positives.
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path:match 'walker/themes' or path:match 'gtk%-' or path:match 'gtk%.' then
      vim.diagnostic.enable(false, { bufnr = bufnr })
    end
  end,
  settings = {
    css = {
      validate = true,
      lint = { unknownAtRules = 'ignore' },
    },
    scss = { validate = true },
    less = { validate = true },
  },
}
