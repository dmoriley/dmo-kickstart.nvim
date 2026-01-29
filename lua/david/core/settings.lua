local set = vim.o
local opt = vim.opt

set.hlsearch = false -- Set highlight on search
set.mouse = 'a'
set.number = true -- Make line numbers default
set.relativenumber = true -- set relative numbered lines
-- set.clipboard = 'unnamed' // always sync with system clipboard
set.breakindent = true -- Enable break indent
set.undofile = true -- Save undo history
set.ignorecase = true -- ignore letter case when searching
set.smartcase = true -- case insensitive unless capitals are used
set.incsearch = true -- start searching as soon as typing, without enter needed
set.wrap = false -- word wrapping
set.termguicolors = true -- NOTE: You should make sure your terminal supports this
set.splitbelow = true -- force all horizontal splits to go to the bottom of current window
set.splitright = true -- force all verticle splits to go to the right of current window
set.cursorline = true -- highlight the current line
set.spell = true -- spell checking
set.pumblend = 10 -- Make builtin completion menus slightly transparent
set.pumheight = 10 -- Make popup menu smaller
set.winblend = 10 -- Make floating windows slightly transparent
set.scrolloff = 8 -- Keeps at least 1 line visible above/below the cursor when scrolling vertically
set.sidescroll = 1 -- When horizontal scrolling is needed, scroll by 1 column at a time (smoother)
set.sidescrolloff = 2 -- Keeps at least 2 columns visible to the left/right of the cursor when scrolling horizontally

-- indentation
set.smarttab = true
set.tabstop = 2 -- size of a hard tabstop
set.shiftwidth = 2 --size of an indentation
set.softtabstop = 2 -- number of space a <Tab> counts for. When 0, feature is off
set.expandtab = true -- always use spaces instead of tab characters
set.smartindent = true -- autoindenting when starting new lines

-- Decrease update time
set.updatetime = 250
set.timeoutlen = 300

opt.iskeyword:append({ '-' }) -- make a dash recognized as part of a w instead of W

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- if ripgrep is available, use as the default grep function from vim cmd
if vim.fn.executable('rg') == 1 then
  set.grepprg = 'rg --vimgrep --smart-case --follow'
end

-- Global Variables
vim.g.mapleader = ' '
vim.g.maplocalleader = ',' --<localleader>

-- disable netrw from starting in favour of using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.netrw_banner = 0 -- no top banner
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30 -- set netrw windows to 30% when split
