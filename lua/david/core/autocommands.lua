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

-- The claudecode terminal is a native terminal buffer with no filetype set,
-- so a FileType autocmd never fires. Match the terminal command on TermOpen
-- (name looks like `term://<cwd>//<pid>:claude ...`) and unlist it so it is
-- hidden from mini.tabline (which only shows 'buflisted' buffers).
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    local cmd = name:match('term://.*//%d+:(.*)') or ''
    if cmd:match('claude') then
      vim.bo[ev.buf].buflisted = false
    end
  end,
  desc = 'Hide claude terminal buffers from buffer list',
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
