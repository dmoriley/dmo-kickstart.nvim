----------------------------------
-- My personal keymap additions --
----------------------------------

local keymap = vim.keymap.set;
local options = function(description)
  if description then
    return { noremap = true, silent = true, desc = description }
  end
  return { noremap = true, silent = true }
end


----------------------------------
------ Normal mode keymaps -------
----------------------------------
-- below keymaps are for netrw explorer when enabled
-- keymap("n", "<leader>xx",  ":Lexplore %:p:h<CR>", options("Open left explore in current file directory"));
-- keymap("n", "<leader>xl",  ":Lexplore<CR>", options("Toggle left explore"));

-- See :help key-notion for which keys map to what string

-- To bind cmd key in mac:
-- bound to Meta + P. Then in iterm2 settings -> profiles -> keys -> keymapping -> add new (cmd + p) + (text with vim special characters) + (\<M-p>)
-- This is to map cmd+p to meta+p so that I can use cmd+p as a explicit shortcut I define. Leading backslash is required otherwise will print literally

-- To bind the alt keys in mac
-- Use literal result of alt key. For example Alt + P = π. So put π as the keymap.
--
keymap('n', '<M-p>', require('telescope.builtin').git_files, options("Search Git Files"))
keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols, options('[S]earch [D]ocument [S]ymbols'))
keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, options('[S]earch [W]orkspace [S]ymbols'))
keymap('n', '<leader>sk', require('telescope.builtin').keymaps, options("[S]earch [K]eymaps"));

-- fast line movement
keymap({'n', 'v'}, "K", "5k", options("Up faster"));
keymap({'n', 'v'}, "J", "5j", options("Down faster"));

-- remap K and J
keymap({'n', 'v'}, "<leader>j", "J", options("Join lines"));
keymap({'n', 'v'} , '<leader>k', vim.lsp.buf.hover, options('Hover Documentation'))
keymap({'n', 'v'}, '<leader>K', vim.lsp.buf.signature_help, options('LSP: Signature Documentation'))

keymap('n', '<leader>df', vim.lsp.buf.format, options('LSP: [D]ocument [F]ormat'));
keymap('n', '<leader>ds', ':w<cr>', options('[D]ocument save'))
keymap('n', '<leader>ws', ':wa<cr>', options('[W]orkspace save'))
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", options("Move cursor to left window"));
keymap("n", "<C-j>", "<C-w>j", options("Move cursor to below window"));
keymap("n", "<C-k>", "<C-w>k", options("Move cursor to above window"));
keymap("n", "<C-l>", "<C-w>l", options("Move cursor to right window"));
-- Resize window with arrow keys
keymap("n", "<A-Up>", ":resize +2<CR>", options("Resize horizontal window up"))
keymap("n", "<A-Down>", ":resize -2<CR>", options("Resize horizontal window down"))
keymap("n", "<A-Left>", ":vertical :resize -2<CR>", options("Resize vertical window left"))
keymap("n", "<A-Right>", ":vertical :resize +2<CR>", options("Resize vertical window right"))
-- Next and previous buffers
keymap("n", "<S-h>", ":bnext<CR>", options("Next buffer"))
keymap("n", "<S-l>", ":bprev<CR>", options("Previous buffer"))
-- Move text up and down
-- ∆ is <A-j>
keymap("n", "∆", ":m .+1<CR>==", options("Move current line up"));
-- ˚ is <A-k>
keymap("n", "˚", ":m .-2<CR>==", options("Move current line down"));
-- Undo tree
keymap("n", "<leader>u", vim.cmd.UndotreeToggle, options("[U]ndotree toggle"));
--nvim-tree
keymap({'n', 'v'}, "<leader>-", vim.cmd.NvimTreeToggle, options("NvimTree toggle"));
----------------------------------
------ Insert mode keymaps -------
----------------------------------
keymap("i", "jk", "<ESC>", options());
-- ∆ is <A-j>
-- keymap("n", "∆", "<Esc>:m .+1<CR>==gi", options("Move current line up"));
-- ˚ is <A-k>
-- keymap("n", "˚", "<Esc>:m .-2<CR>==gi", options("Move current line down"));

------------------------------
------ Visual mode keymaps -------
----------------------------------
-- Indenting
keymap("v", ">", ">gv", options("Stay in visual mode while indenting right"))
keymap("v", "<", "<gv", options("Stay in visual mode while indenting left"))
-- Move text up and down
-- ∆ is <A-j>
keymap("v", "∆", ":m '>+1<CR>gv=gv", options("Move selected text up one line down"));
-- ˚ is <A-k>
keymap("v", "˚", ":m '<-2<CR>gv=gv", options("Move selected text up one line up"));
-- Pasting behaviour
keymap("v", "p", '"_dP', options("Paste without swapping paste value for deleted value")) -- When pasting in Visual mode, dont replace the paste value with what was deleted

----------------------------------
--- Visual Block mode keymaps ----
----------------------------------

--[[ -- ∆ is <A-j>
keymap("x", "∆", ":m '>+1<CR>gv-gv", options("Move selected text up one line down"));
-- ˚ is <A-k>
keymap("x", "˚", ":m '<-2<CR>gv-gv", options("Move selected text up one line up")); ]]
