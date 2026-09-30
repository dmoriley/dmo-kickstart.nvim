return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gc', '<cmd>CodeDiff<cr>', desc = 'CodeDiff working tree' },
    { '<leader>gH', '<cmd>CodeDiff history<cr>', desc = 'CodeDiff commit history' },
  },
  init = function()
    -- "s" in the explorer stages/unstages the file under the cursor. Remaps to the
    -- plugin's toggle_stage key ("-"), which is tab-wide, so "s" stays free in diff buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'codediff-explorer',
      callback = function(ev)
        vim.keymap.set('n', 's', '-', { buffer = ev.buf, remap = true, desc = 'Stage/unstage file' })
      end,
    })
  end,
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
