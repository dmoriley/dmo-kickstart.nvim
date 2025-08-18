local utils = require('david.core.utils')
--
-- modes: n,v,i,x,t
-- n = normal mode
-- i = insert mode
-- x = all select modes, visual and block
-- v = just visual mode
-- t = terminal
--
local mapper = utils.mapper_factory
local nnoremap = mapper('n')
local nxnoremap = mapper({ 'n', 'x' })
local ntnoremap = mapper({ 'n', 't' })
local inoremap = mapper('i')
local xnoremap = mapper('x')

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

mapper({ 'n', 'v' })('<Space>', '<Nop>')

-- fast line movement
nxnoremap('K', '5k', { desc = 'Up faster' })
nxnoremap('J', '5j', { desc = 'Down faster' })

-- Move by visible lines. Notes:
-- - Don't map in Operator-pending mode because it severely changes behavior:
--   like `dj` on non-wrapped line will not delete it.
-- - Condition on `v:count == 0` to allow easier use of relative line numbers.
nxnoremap('j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
nxnoremap('k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

-- remap K and J
nnoremap('<leader>j', 'J', { desc = 'Join lines' })
-- nnoremap('<leader>ds', '<cmd>write<cr>', { desc = 'Document Save' })
nnoremap('<leader>ws', '<cmd>wall<cr>', { desc = 'Workspace Save' })
nnoremap('<C-S>', '<CMD>silent! update | redraw<CR>', { desc = 'Document Save' })

mapper({ 'i', 'x' })('<C-S>', '<ESC><CMD>silent! update | redraw<CR>', { desc = 'Document Save and go to normal mode' })

nnoremap('<leader>\\', '<cmd>vsplit<cr>', { desc = 'Vertical split buffer' })

-- Better window navigation
ntnoremap('<C-S-H>', function()
  utils.navigate_pane_or_window('h')
end, { desc = 'Move cursor to left window' })
ntnoremap('<C-S-J>', function()
  utils.navigate_pane_or_window('j')
end, { desc = 'Move cursor to below window' })
ntnoremap('<C-S-L>', function()
  utils.navigate_pane_or_window('l')
end, { desc = 'Move cursor to right window' })
ntnoremap('<C-S-K>', function()
  utils.navigate_pane_or_window('k')
end, { desc = 'Move cursor to below window' })

-- Line start and end navigation
nxnoremap('<S-h>', '^', { desc = 'Move cursor to first character in line' })
nxnoremap('<S-l>', '$', { desc = 'Move cursor to last character in line' })

-- Resize window with arrow keys
nnoremap('<A-Right>', '"<Cmd>vertical resize -" . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Decrease window width' })
nnoremap('<A-Up>', '"<Cmd>resize -"          . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Decrease window height' })
nnoremap('<A-Down>', '"<Cmd>resize +"          . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Increase window height' })
nnoremap('<A-Left>', '"<Cmd>vertical resize +" . v:count1 . "<CR>"', { expr = true, replace_keycodes = false, desc = 'Increase window width' })

-- Buffers
nnoremap('<C-h>', '<cmd>bprev<CR>', { desc = 'Next buffer' })
nnoremap('<C-l>', '<cmd>bnext<CR>', { desc = 'Previous buffer' })

-- center screen on movement
nnoremap('<C-d>', '<C-d>zz', { desc = 'Move down screen and center on line' })
nnoremap('<C-u>', '<C-u>zz', { desc = 'Move up screen and center on line' })
nnoremap('<C-o>', '<C-o>zz', { desc = 'Go back and center on line' })
nnoremap('<C-i>', '<C-i>zz', { desc = 'Go forward and center on line' })
nnoremap('n', 'nzzzv')
nnoremap('N', 'Nzzzv')

-- avoid registers
nnoremap('x', '"_x', { desc = 'x deletion but dont save to buffer' })
xnoremap('p', '"_dP', { desc = 'Paste without swapping paste value for deleted value' }) -- When pasting in Visual mode, dont replace the paste value with what was deleted

-- copy pasting
nxnoremap('gy', '"+y', { desc = 'Copy to system clipboard' })
nnoremap('gp', '"+p', { desc = 'Paste from system clipboard' })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
xnoremap('gp', '"+P', { desc = 'Paste from system clipboard' })

-- change to normal mode faster
inoremap('jk', '<ESC>')
inoremap('JK', '<ESC>')

mapper('t')('jk', '<ESC>')
mapper('t')('JK', '<ESC>')

-- Indenting
xnoremap('>', '>gv', { desc = 'Stay in visual mode while indenting right' })
xnoremap('<', '<gv', { desc = 'Stay in visual mode while indenting left' })

-- search and replace
nnoremap('<leader>sR', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<left><left><left>]], { desc = 'Search and replace' })
-- Quick find and replace
xnoremap('<leader>rw', [["zy:%s/<C-r><C-o>"/]], { desc = 'Replace visually selected text in buffer', silent = false })
nnoremap('<leader>rw', [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], { desc = 'Replace word under cursor in buffer', silent = false })

-- easier way to select alternate buffer
nnoremap('<Tab>', '<C-6>', { desc = 'Select alternate buffer' })

-- CMD a to select all. Configuration for passing cmd keys in wezterm using hex codes
mapper({ 'n', 'i' })('<Char-0xAA>', 'ggVG', { desc = 'Select all' })

-- diagnostics
nnoremap('[d', function()
  vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Go to previous diagnostic message' })

nnoremap(']d', function()
  vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Go to next diagnostic message' })
nnoremap('<C-w><C-d>', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

nnoremap('<leader><C-t>', function()
  vim.cmd.vsplit()
  vim.cmd.term()
end, { desc = 'Open terminal in split window' })

-- `dd` but don't yank if the line is empty
nnoremap('dd', function()
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return [["_dd]]
  else
    return [[dd]]
  end
end, { expr = true })
