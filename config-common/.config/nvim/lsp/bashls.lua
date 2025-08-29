return {
  -- Command and arguments to start the server.
  cmd = { 'bash-language-server', 'start' },

  -- Filetypes to automatically attach to
  filetypes = { 'zsh', 'sh', 'bash' },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a ".luarc.jsonc"
  -- file. Files that share a root directory will reuse the connection to the
  -- same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = {
    { '.bashrc', '.zshrc' },
    '.git'
  },

  -- Specific settings to send to the server.
  settings = {
  },
}
