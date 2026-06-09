return {
  -- Command and arguments to start the server.
  -- marksman is an LSP server for Markdown (providing completion, diagnostics, and link tracking).
  -- Install via: pacman -S marksman (or via Mason)
  cmd = { 'marksman', 'server' },

  -- Filetypes to automatically attach to
  filetypes = { 'markdown', 'md' },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains a .marksman.toml configuration file, or a
  -- standard project marker like a .git folder.
  root_markers = {
    '.marksman.toml',
    '.git',
  },
}
