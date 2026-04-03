return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { '.git' },
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
