return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>', desc = 'Focus split or tmux pane left' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>', desc = 'Focus split or tmux pane down' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>', desc = 'Focus split or tmux pane up' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>', desc = 'Focus split or tmux pane right' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>', desc = 'Focus previous split or tmux pane' },
    },
  },
}
