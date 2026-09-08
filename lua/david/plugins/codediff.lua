return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gc', '<cmd>CodeDiff<cr>', desc = 'CodeDiff working tree' },
    { '<leader>gH', '<cmd>CodeDiff history<cr>', desc = 'CodeDiff commit history' },
  },
  opts = {
    explorer = {
      focus_on_select = true, --Jump to modified pane after selecting a file
      auto_open_on_cursor = true, -- Rebind j/k/Down/Up in the exporer to also open the file
    },
    history = {
      -- position = 'left', -- Commit list on the left instead of the bottom
    },
    keymaps = {
      view = {
        toggle_explorer = '<leader>E',
        focus_explorer = '<leader>e',
        next_hunk = ']]',
        prev_hunk = '[[',
      },
    },
  },
}
