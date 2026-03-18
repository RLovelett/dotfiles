return {
  -- Command and arguments to start the server.
  -- https://github.com/hyprland-community/hyprls
  cmd = { 'hyprls', '--stdio' },

  -- Filetypes to automatically attach to.
  -- Neovim has built-in detection for hyprlang: hyprland.conf, hyprlock.conf,
  -- hypridle.conf, hyprpaper.conf, and any *.conf under a hypr/ directory.
  filetypes = { 'hyprlang' },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains a ".git" directory.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { '.git' },

  -- Specific settings to send to the server.
  settings = {
    hyprls = {
      preferIgnoreFile = true,
    },
  },
}
