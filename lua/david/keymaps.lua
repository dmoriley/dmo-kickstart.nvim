vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local keymap = vim.keymap.set;
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
--

-- fast line movement
keymap({ 'n', 'x' }, "K", "5k", options("Up faster"));
keymap({ 'n', 'x' }, "J", "5j", options("Down faster"));

-- remap K and J
keymap('n', "<leader>j", "J", options("Join lines"));
keymap('n', '<leader>k', vim.lsp.buf.hover, options('Hover Documentation'))
keymap('n', '<leader>K', vim.lsp.buf.signature_help, options('LSP: Signature Documentation'))

keymap('n', '<leader>df', vim.lsp.buf.format, options('LSP: [D]ocument [F]ormat'));
keymap('n', '<leader>ds', ':w<cr>', options('[D]ocument save'))
keymap('n', '<leader>ws', ':wa<cr>', options('[W]orkspace save'))

-- Better window navigation
-- keymap("n", "<C-h>", "<C-w>h", options("Move cursor to left window"));
-- keymap("n", "<C-j>", "<C-w>j", options("Move cursor to below window"));
-- keymap("n", "<C-k>", "<C-w>k", options("Move cursor to above window"));
-- keymap("n", "<C-l>", "<C-w>l", options("Move cursor to right window"));

-- Line start and end navigation
keymap({ 'n', 'x' }, '<S-h>', '^', options("Move cursor to first character in line"))
keymap({ 'n', 'x' }, '<S-l>', '$', options("Move cursor to last character in line"))

-- Resize window with arrow keys
keymap("n", "<A-Up>", ":resize +2<CR>", options("Resize horizontal window up"))
keymap("n", "<A-Down>", ":resize -2<CR>", options("Resize horizontal window down"))
keymap("n", "<A-Left>", ":vertical :resize -2<CR>", options("Resize vertical window left"))
keymap("n", "<A-Right>", ":vertical :resize +2<CR>", options("Resize vertical window right"))

-- Buffers
keymap("n", "<C-h>", ":bprev<CR>", options("Next buffer"))
keymap("n", "<C-l>", ":bnext<CR>", options("Previous buffer"))
keymap("n", "<leader>ba", ":%bd|e#<cr>", options("Close all buffers but not current one"))

-- Move text up and down
-- ∆ is <A-j>
keymap("n", "∆", ":m .+1<CR>==", options("Move current line up"));
-- ˚ is <A-k>
keymap("n", "˚", ":m .-2<CR>==", options("Move current line down"));
-- ∆ is <A-j>
keymap("v", "∆", ":m '>+1<CR>gv=gv", options("Move selected text up one line down"));
-- ˚ is <A-k>
keymap("v", "˚", ":m '<-2<CR>gv=gv", options("Move selected text up one line up"));
--[[ -- ∆ is <A-j>
keymap("x", "∆", ":m '>+1<CR>gv-gv", options("Move selected text up one line down"));
-- ˚ is <A-k>
keymap("x", "˚", ":m '<-2<CR>gv-gv", options("Move selected text up one line up")); ]]

-- center screen on movement
keymap('n', "<C-d>", "<C-d>zz", options("Move down screen and center on line"))
keymap('n', "<C-u>", "<C-u>zz", options("Move up screen and center on line"))
keymap('n', "<C-o>", "<C-o>zz", options("Go back and center on line"))
keymap('n', "<C-i>", "<C-i>zz", options("Go forward and center on line"))

-- avoid registers
keymap('n', 'x', '"_x', options("x deletion but dont save to buffer"))
keymap('x', "p", '"_dP', options("Paste without swapping paste value for deleted value")) -- When pasting in Visual mode, dont replace the paste value with what was deleted

-- copy pasting
keymap({ 'n', 'x' }, '<leader>y', '"+y', options("copy to system clipboard"))
keymap({ 'n', 'x' }, '<leader>p', '"+p', options("paste from system clipboard"))
-- keymap("n", "<leader>Y", [["+Y]], opts) -- copy current line to system clipboard
-- keymap("n", "<leader>vp", "`[v`]", opts) -- reselect pasted text

-- change to normal mode faster
keymap("i", "jk", "<ESC>", options());
keymap("i", "JK", "<ESC>", options());
-- keymap("i", "kj", "<ESC>", options());
-- keymap("i", "KJ", "<ESC>", options());

-- Indenting
keymap('x', ">", ">gv", options("Stay in visual mode while indenting right"))
keymap('x', "<", "<gv", options("Stay in visual mode while indenting left"))

-- search and replace
keymap('n', "<leader>sR", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], options("Search and replace"))

-- diagnostics

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
