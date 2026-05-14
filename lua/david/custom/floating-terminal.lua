local open_floating_window = require('david.core.utils').open_floating_window
local ntkeymap = require('david.core.utils').mapper_factory({ 'n', 't' })

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local toggle_terminal = function()
  -- check if a valid window has already been created (or already opened)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = open_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      -- call terminal inside of the new buffer
      vim.cmd.terminal()
    end
    vim.bo[state.floating.buf].buflisted = false -- don't list buffer so it doens't appear in tab list

    -- disable some keymaps in normal mode for the floating buffer window
    for _, lhs in ipairs({ '<Tab>', '<C-6>', '<C-^>' }) do
      vim.keymap.set('n', lhs, '<Nop>', {
        buffer = state.floating.buf,
        desc = 'Disable alternate buffer in floating terminal',
      })
    end

    vim.cmd.startinsert() -- start in insert mode
  else
    -- window already opened so hide it
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('FloatingTerminal', toggle_terminal, { desc = 'Toggle a terminal in a floating window' })
ntkeymap('<C-/>', toggle_terminal, { desc = 'Toggle a teriminal in a floating window' })
