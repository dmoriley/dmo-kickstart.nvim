local env = require('david.core.env')
local M = {}
local NIL = {}

-- server names are according to lspconfig (see :h lspconfig-all)
M.servers = {
  lua_ls = require('david.plugins.lsp.servers.lua'),
  gopls = require('david.plugins.lsp.servers.go'),
  angularls = require('david.plugins.lsp.servers.angular'),
  html = NIL,
  -- cssls = NIL
  -- eslint = NIL,
  -- jsonls = NIL,
}

if env.NVIM_USER_USE_TS_LS then
  M.servers.ts_ls = require('david.plugins.lsp.servers.ts_ls')
  M.servers.vtsls = {
    enabled = false,
  }
else
  M.servers.vtsls = require('david.plugins.lsp.servers.vtsls')
  M.servers.ts_ls = {
    enabled = false,
  }
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

M.dap = {
  'delve', -- GO debugger
}

return M
