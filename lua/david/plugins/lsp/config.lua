return function()
  local lspConfig = require('lspconfig')
  local servers = require('david.plugins.lsp.servers').servers
  local lsp_mappings = require('david.plugins.lsp.mappings')

  require('mason').setup()

  -- local masonLspConfig = require('mason-lspconfig')
  -- masonLspConfig.setup({
  --   ensure_installed = vim.tbl_keys(servers),
  --   -- automatic_enable = true, -- could be redundant cause of lsp.enable call in loop further down
  -- })
  -- local installed = masonLspConfig.get_installed_servers()

  -- attach common lsp callbacks
  local groupId = vim.api.nvim_create_augroup('user-lsp-attach', {})
  vim.api.nvim_create_autocmd('LspAttach', {
    group = groupId,
    callback = function(args)
      lsp_mappings.attach(args)
    end,
  })

  -- update capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

  -- folding settings for nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  for name, value in pairs(servers) do
    -- add capabilities to the config obj
    local config = vim.tbl_deep_extend('force', value or {}, { capabilities = capabilities })
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end
