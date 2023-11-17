return function ()
  require("neodev").setup()

  local lspConfig = require("lspconfig")
  local masonLspConfig = require("mason-lspconfig")
  local lspSettings = require("david.plugins.lsp.settings")

  local servers = {
    gopls = lspSettings.go,
    lua_ls = lspSettings.lua,
    tsserver = lspSettings.ts,
    angularls = lspSettings.angular,
    html = { filetypes = { 'html', 'hbs'} },
    -- cssls = lspSettings.css,
    -- eslint = {},
    -- jsonls = {},
    -- tailwindcss = {}
  }

  masonLspConfig.setup({
    ensure_installed = vim.tbl_keys(servers)
  })


  masonLspConfig.setup_handlers({
    function (serverName)
      lspConfig[serverName].setup({
        on_attach = lspSettings.on_attach,
        capabilities = lspSettings.capabilities,
        settings = servers[serverName],
        filetypes = (servers[serverName] or {}).filetypes
      })
    end
  })


  require("illuminate").configure({
    delay = 200,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { "lsp" }
    }
  })

  -- require("david.plugins.lsp.handlers").setup()
end
