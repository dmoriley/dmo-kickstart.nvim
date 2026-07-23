return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gc', '<cmd>CodeDiff<cr>' },
  },
  opts = {
    explorer = {
      focus_on_select = true, --Jump to modified pane after selecting a file
      auto_open_on_cursor = true, -- Rebind j/k/Down/Up in the exporer to also open the file
    },
  },
  keymaps = {
    view = {
      toggle_explorer = '<leader>e',
      focus_explorer = '<leader>e',
      next_hunk = ']h',
      prev_hunk = '[h',
    },
  },
}
