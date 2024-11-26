local M = {}

-- get language server settings
M.lua = require('david.plugins.lsp.servers.lua')
M.ts = require('david.plugins.lsp.servers.ts')
M.go = require('david.plugins.lsp.servers.go')
M.angular = require('david.plugins.lsp.servers.angular')

-- extend completion capabilities with cmp_nvim
M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local keymap = vim.keymap.set
local options = function(description)
  if description then
    return { noremap = true, silent = true, desc = 'LSP: ' .. description }
  end
  return { noremap = true, silent = true }
end

M.on_attach = function(_, bufnr)
  -- if client.name == 'tsserver' then
  --   client.server_capabilities.documentFormattingProvider = false
  -- end
  -- if client.name == 'lua_ls' then
  --   client.server_capabilities.documentFormattingProvider = false
  -- end

  keymap('n', '<leader>vrn', vim.lsp.buf.rename, options('[V]im [R]e[n]ame'))
  keymap('n', '<leader>vca', vim.lsp.buf.code_action, options('[V]im [C]ode [A]ction'))
  keymap('n', '<leader>vrr', vim.lsp.buf.references, options('[V]im refe[rr]ences in quickfix'))

  keymap('n', 'gD', vim.lsp.buf.declaration, options('[G]oto [D]eclaration'))

  keymap('n', '<leader>k', vim.lsp.buf.hover, options('Hover Documentation'))
  keymap('n', '<leader>K', vim.lsp.buf.signature_help, options('Signature Documentation'))

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- require("illuminate").on_attach(client)
end

return M
