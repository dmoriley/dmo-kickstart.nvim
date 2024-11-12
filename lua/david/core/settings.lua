-- See `:help vim.o`
vim.o.hlsearch = false -- Set highlight on search
vim.wo.number = true -- Make line numbers default
vim.o.mouse = 'a'

-- vim.o.clipboard = 'unnamed' // always sync with system clipboard

vim.o.breakindent = true -- Enable break indent

vim.o.undofile = true -- Save undo history

vim.o.ignorecase = true -- ignore letter case when searching
vim.o.smartcase = true -- case insensitive unless capitals are used
vim.o.incsearch = true -- start searching as soon as typing, without enter needed

vim.o.wrap = false -- word wrapping

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this
vim.o.splitbelow = true -- force all horizontal splits to go to the bottom of current window
vim.o.splitright = true -- force all verticle splits to go to the right of current window
vim.o.relativenumber = true -- set relative numbered lines
vim.o.cursorline = true -- highlight the current line
vim.opt.iskeyword:append({ '-' }) -- make a dash recognized as part of a w instead of W
vim.o.spell = true -- spell checking

-- tabs
vim.o.smarttab = true
vim.o.tabstop = 2 -- size of a hard tabstop
vim.o.shiftwidth = 2 --size of an indentation
vim.o.softtabstop = 2 -- number of space a <Tab> counts for. When 0, feature is off
vim.o.expandtab = true -- always use spaces instead of tab characters

vim.o.smartindent = true -- autoindenting when starting new lines

vim.o.pumblend = 10 -- Make builtin completion menus slightly transparent
vim.o.pumheight = 10 -- Make popup menu smaller
vim.o.winblend = 10 -- Make floating windows slightly transparent

-- if ripgrep is available, use as the default grep function from vim cmd
if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep --smart-case --follow'
end

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
  desc = 'Highlight text on yank',
})

-- toggle relative number based on mode
local augroup = vim.api.nvim_create_augroup('numbertoggle', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = augroup,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = augroup,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false

      vim.cmd('redraw')
    end
  end,
})
