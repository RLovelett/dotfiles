return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'package.json', '.git' },
  settings = {
    json = {
      validate = { enabled = true },
      schemas = require('schemastore').json.schemas(),
    },
  },
  init_options = {
    provideFormatter = true,
  },
}
