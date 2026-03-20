return {
  -- Command and arguments to start the server.
  cmd = { 'ruff', 'server' },

  -- Filetypes to automatically attach to.
  filetypes = { 'python' },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains one of these markers.
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },

  on_attach = function(client, _)
    -- Disable hover in favor of pyright, which provides richer hover info.
    client.server_capabilities.hoverProvider = false
  end,
}
