vim.keymap.set('n', '<leader>X', '<cmd>source %<CR>', { buffer = true, desc = 'Execute current lua buffer' })
vim.keymap.set('n', '<leader>x', '<cmd>.lua<cr>', { buffer = true, desc = 'Execute current lua line' })
-- some reason visual mode version only works with command as ":"
vim.keymap.set('v', '<leader>x', ':lua<cr>', { buffer = true, desc = 'Execute current selectd lines' })
