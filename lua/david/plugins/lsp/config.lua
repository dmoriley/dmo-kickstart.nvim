return function()
  local lspConfig = require('lspconfig')
  local servers = require('david.plugins.lsp.servers').servers
  local lsp_mappings = require('david.plugins.lsp.mappings')

  require('mason').setup()

  local masonLspConfig = require('mason-lspconfig')
  masonLspConfig.setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = true, -- could be redundant cause of lsp.enable call in loop further down
  })
  local installed = masonLspConfig.get_installed_servers()

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

  for _, name in ipairs(installed) do
    -- add capabilities to the config obj
    local config = vim.tbl_deep_extend('force', servers[name] or {}, { capabilities = capabilities })
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end

  -- Illuminate settings
  -- require('illuminate').configure({
  --   delay = 150,
  --   large_file_cutoff = 2000,
  --   large_file_overrides = {
  --     providers = { 'lsp' },
  --   },
  -- })
  --
  -- local options = {
  --   -- bold = true,
  --   -- italic = true,
  --   -- underline = true,
  --   -- undercurl = true,
  --   -- underdouble = true,
  --   standout = true,
  --   -- sp = "yellow"
  -- }
  -- local highlights = {
  --   IlluminatedWord = options,
  --   IlluminatedCurWord = options,
  --   IlluminatedWordText = options,
  --   IlluminatedWordRead = options,
  --   IlluminatedWordWrite = options,
  -- }
  --
  -- for group, value in pairs(highlights) do
  --   vim.api.nvim_set_hl(0, group, value)
  -- end
end
