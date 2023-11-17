--`:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { import = 'david.plugins' },
}

local options = {
  git = {
    -- configure lazyvim to use ssh instead of https
    url_format = "git@github.com:%s.git",
  },
}

require('lazy').setup(plugins, options)
