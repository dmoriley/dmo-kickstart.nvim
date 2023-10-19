-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
vim.o.hlsearch = false -- Set highlight on search
vim.wo.number = true -- Make line numbers default
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this
vim.o.splitbelow = true -- force all horizontal splits to go to the bottom of current window
vim.o.splitright = false -- force all verticle splits to go to the right of current window
vim.o.expandtab = true
vim.o.relativenumber = false -- set relative numbered lines
vim.o.cursorline = true -- highlight the current line
vim.opt.iskeyword:append {"-"} -- make a dash recognized as part of a w instead of W
