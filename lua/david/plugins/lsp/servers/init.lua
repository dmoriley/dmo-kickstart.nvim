local M = {}
local NIL = {}

-- server names are according to lspconfig (see :h lspconfig-all)
M.servers = {
  lua_ls = require('david.plugins.lsp.servers.lua'),
  ts_ls = require('david.plugins.lsp.servers.ts'),
  gopls = require('david.plugins.lsp.servers.go'),
  angularls = require('david.plugins.lsp.servers.angular'),
  html = NIL,
  -- cssls = NIL
  -- eslint = NIL,
  -- jsonls = NIL,
}

M.formatters = {
  -- "eslint_d",
  'prettierd',
}

return M
