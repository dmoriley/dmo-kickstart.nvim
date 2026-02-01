local env = require('david.core.env')
local M = {}

-- server names are according to lspconfig (see :h lspconfig-all)
M.servers = {
  lua_ls = require('david.plugins.lsp.servers.lua'),
  gopls = require('david.plugins.lsp.servers.go'),
  angularls = require('david.plugins.lsp.servers.angular'),
  html = {},
  -- cssls = NIL
  -- eslint = NIL,
  -- jsonls = NIL,
}
if env.NVIM_USER_USE_TS_LS then
  M.servers.ts_ls = require('david.plugins.lsp.servers.ts_ls')
else
  M.servers.vtsls = require('david.plugins.lsp.servers.vtsls')
end

M.formatters = {
  -- "eslint_d",
  'prettierd',

  -- Golang formatters
  'goimports',
  'gofumpt',
  -- 'golines',
  'gomodifytags',
  'impl',
}

return M
