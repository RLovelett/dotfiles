return {
  cmd = { 'ansible-language-server', '--stdio' },
  filetypes = { 'yaml.ansible' },
  root_markers = { 'ansible.cfg', '.ansible-lint', 'galaxy.yml', '.git' },
  settings = {
    ansible = {
      ansible = {
        path = 'ansible',
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = 'ansible-lint',
        },
      },
    },
  },
}
