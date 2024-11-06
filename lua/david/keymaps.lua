local utils = require('david.core.utils')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local keymap = vim.keymap.set
local options = function(description)
  if description then
    return { noremap = true, silent = true, desc = description }
  end
  return { noremap = true, silent = true }
end
-- modes: n,v,i,x
-- n = normal mode
-- i = insert mode
-- x = all select modes, visual and block
-- v = just visual mode

-- below keymaps are for netrw explorer when enabled
-- keymap("n", "<leader>xx",  ":Lexplore %:p:h<CR>", options("Open left explore in current file directory"));
-- keymap("n", "<leader>xl",  ":Lexplore<CR>", options("Toggle left explore"));

-- See :help key-notation for which keys map to what string

-- To bind cmd key in mac:
-- bound to Meta + P. Then in iterm2 settings -> profiles -> keys -> keymapping -> add new (cmd + p) + (text with vim special characters) + (\<M-p>)
-- This is to map cmd+p to meta+p so that I can use cmd+p as a explicit shortcut I define. Leading backslash is required otherwise will print literally

-- To bind the alt keys in mac
-- Use literal result of alt key. For example Alt + P = π. So put π as the keymap.

-- To execute a vim command in lua 'lua vim.api.nvim_command('write')<CR>'

-- fast line movement
keymap({ 'n', 'x' }, 'K', '5k', options('Up faster'))
keymap({ 'n', 'x' }, 'J', '5j', options('Down faster'))

-- remap K and J
keymap('n', '<leader>j', 'J', options('Join lines'))
keymap('n', '<leader>k', vim.lsp.buf.hover, options('Hover Documentation'))
keymap('n', '<leader>K', vim.lsp.buf.signature_help, options('LSP: Signature Documentation'))

keymap('n', '<leader>ds', '<cmd>write<cr>', options('Document Save'))
keymap('n', '<leader>ws', '<cmd>wall<cr>', options('Workspace Save'))
keymap('n', '<C-S>', '<CMD>silent! update | redraw<CR>', options('Document Save'))

keymap({ 'i', 'x' }, '<C-S>', '<ESC><CMD>silent! update | redraw<CR>', options('Document Save and go to normal mode'))

-- Better window navigation
keymap('n', '<C-S-H>', function()
  utils.navigate_pane_or_window('h')
end, options('Move cursor to left window'))
keymap('n', '<C-S-J>', function()
  utils.navigate_pane_or_window('j')
end, options('Move cursor to below window'))
keymap('n', '<C-S-L>', function()
  utils.navigate_pane_or_window('l')
end, options('Move cursor to right window'))
keymap('n', '<C-S-K>', function()
  utils.navigate_pane_or_window('k')
end, options('Move cursor to below window'))

-- Line start and end navigation
keymap({ 'n', 'x' }, '<S-h>', '^', options('Move cursor to first character in line'))
keymap({ 'n', 'x' }, '<S-l>', '$', options('Move cursor to last character in line'))

-- Resize window with arrow keys
vim.keymap.set('n', '<A-Right>', '"<Cmd>vertical resize -" . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Decrease window width' })
vim.keymap.set('n', '<A-Up>', '"<Cmd>resize -"          . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Decrease window height' })
vim.keymap.set('n', '<A-Down>', '"<Cmd>resize +"          . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Increase window height' })
vim.keymap.set('n', '<A-Left>', '"<Cmd>vertical resize +" . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Increase window width' })

-- Buffers
keymap('n', '<C-h>', ':bprev<CR>', options('Next buffer'))
keymap('n', '<C-l>', ':bnext<CR>', options('Previous buffer'))

-- center screen on movement
keymap('n', '<C-d>', '<C-d>zz', options('Move down screen and center on line'))
keymap('n', '<C-u>', '<C-u>zz', options('Move up screen and center on line'))
keymap('n', '<C-o>', '<C-o>zz', options('Go back and center on line'))
keymap('n', '<C-i>', '<C-i>zz', options('Go forward and center on line'))

-- avoid registers
keymap('n', 'x', '"_x', options('x deletion but dont save to buffer'))
keymap('x', 'p', '"_dP', options('Paste without swapping paste value for deleted value')) -- When pasting in Visual mode, dont replace the paste value with what was deleted

-- copy pasting
keymap({ 'n', 'x' }, 'gy', '"+y', options('Copy to system clipboard'))
keymap('n', 'gp', '"+p', options('Paste from system clipboard'))
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
keymap('x', 'gp', '"+P', options('Paste from system clipboard'))

-- change to normal mode faster
keymap('i', 'jk', '<ESC>', options())
keymap('i', 'JK', '<ESC>', options())

-- Indenting
keymap('x', '>', '>gv', options('Stay in visual mode while indenting right'))
keymap('x', '<', '<gv', options('Stay in visual mode while indenting left'))

-- search and replace
keymap('n', '<leader>sR', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], options('Search and replace'))
keymap('x', '<leader>sv', '<esc>/\\%V', options('Search inside visual selection'))

-- easier way to select alternate buffer
keymap('n', '<Tab>', '<C-6>', options('Select alternate buffer'))

-- CMD a to select all. Configuration for passing cmd keys in wezterm using hex codes
keymap({ 'n', 'i' }, '<Char-0xAA>', 'ggVG', options('Select all'))

-- diagnostics
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

vim.keymap.set('n', '<leader><C-t>', function()
  vim.cmd.vsplit()
  vim.cmd.term()
end, { desc = 'Open terminal in split window' })

-- Move by visible lines. Notes:
-- - Don't map in Operator-pending mode because it severely changes behavior:
--   like `dj` on non-wrapped line will not delete it.
-- - Condition on `v:count == 0` to allow easier use of relative line numbers.
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
