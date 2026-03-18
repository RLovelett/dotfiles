return {
  -- Command and arguments to start the server.
  -- taplo is a TOML toolkit that includes an LSP server.
  -- Install via: cargo install taplo-cli --locked --features lsp
  cmd = { 'taplo', 'lsp', 'stdio' },

  -- Filetypes to automatically attach to
  filetypes = { 'toml' },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a "taplo.toml" or ".taplo.toml"
  -- file. Files that share a root directory will reuse the connection to the
  -- same LSP server.
  root_markers = {
    'taplo.toml',
    '.taplo.toml',
    '.git'
  },
}
