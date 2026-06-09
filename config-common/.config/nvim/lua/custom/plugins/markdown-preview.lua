return {
  'selimacerbas/markdown-preview.nvim',
  ft = { 'markdown' },
  dependencies = { 'selimacerbas/live-server.nvim' },
  init = function()
    local status_ok, wk = pcall(require, 'which-key')
    if status_ok then
      wk.add {
        { '<leader>m', group = 'Markdown' },
        { '<leader>mp', group = 'Preview' },
      }
    end
  end,
  keys = {
    { '<leader>mps', '<cmd>MarkdownPreview<cr>', desc = 'Markdown: Start preview' },
    { '<leader>mpS', '<cmd>MarkdownPreviewStop<cr>', desc = 'Markdown: Stop preview' },
    { '<leader>mpr', '<cmd>MarkdownPreviewRefresh<cr>', desc = 'Markdown: Refresh preview' },
  },
  opts = {
    instance_mode = 'takeover',
    port = 0,
    open_browser = true,
    default_theme = 'dark',
    debounce_ms = 300,
  },
}
