return function()
  local lspConfig = require('lspconfig')
  local masonLspConfig = require('mason-lspconfig')
  local serverSettings = require('david.plugins.lsp.servers')

  local servers = {
    -- LSP's
    gopls = serverSettings.go,
    lua_ls = serverSettings.lua,
    tsserver = serverSettings.ts,
    angularls = serverSettings.angular,
    html = { filetypes = { 'html', 'hbs' } },
    -- cssls = lspSettings.css,
    -- eslint = {},
    -- jsonls = {},
  }

  require('mason').setup()
  masonLspConfig.setup({
    ensure_installed = vim.tbl_keys(servers),
  })

  local installed = masonLspConfig.get_installed_servers()

  for _, value in ipairs(installed) do
    lspConfig[value].setup({
      on_attach = serverSettings.on_attach,
      capabilities = serverSettings.capabilities,
      settings = servers[value].settings or {},
      filetypes = (servers[value].settings or {}).filetypes,
      commands = servers[value].commands,
    })
  end

  -- Illuminate settings
  require('illuminate').configure({
    delay = 150,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { 'lsp' },
    },
  })

  local options = {
    -- bold = true,
    -- italic = true,
    -- underline = true,
    -- undercurl = true,
    -- underdouble = true,
    standout = true,
    -- sp = "yellow"
  }
  local highlights = {
    IlluminatedWord = options,
    IlluminatedCurWord = options,
    IlluminatedWordText = options,
    IlluminatedWordRead = options,
    IlluminatedWordWrite = options,
  }

  for group, value in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, value)
  end

  -- require("david.plugins.lsp.handlers").setup()
end
