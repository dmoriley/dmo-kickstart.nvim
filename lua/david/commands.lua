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
