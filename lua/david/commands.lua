-- Preform grep silently and then open the quickfix window with the results
local function Grep(opts)
  local args = table.concat({ opts.args }, ' ')
  -- silent so grep doesnt log, %q to surround args substitution with quotes
  local command = string.format('silent grep! %q', args)
  vim.cmd(command)
  -- run copen right after grep search finishes
  vim.cmd('copen')
end

vim.api.nvim_create_user_command('Grep', Grep, { nargs = 1 })

-- Toggle word wrap
vim.api.nvim_create_user_command('WordWrapToggle', function()
  vim.o.wrap = not vim.o.wrap
end, { nargs = 0 })

-- save without formatting
vim.api.nvim_create_user_command('SaveWithoutFormat', function()
  vim.cmd('noautocmd w')
end, { nargs = 0 })

-- save all without format
vim.api.nvim_create_user_command('SaveAllWithoutFormat', function()
  vim.cmd('noautocmd wa')
end, { nargs = 0 })
