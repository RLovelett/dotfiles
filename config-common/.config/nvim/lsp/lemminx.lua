return {
  -- Command and arguments to start the server.
  cmd = { 'lemminx' },

  -- Filetypes to automatically attach to
  filetypes = { 'xml' },

  -- Specific settings to send to the server.
  settings = {
    xml = {
      validation = { enabled = true },
      format = { enabled = true, splitAttributes = true },
      completion = { autoCloseTags = true },
    },
  },
}
