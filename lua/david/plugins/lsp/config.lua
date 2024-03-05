return function()
  require('neodev').setup()

  local lspConfig = require 'lspconfig'
  local masonLspConfig = require 'mason-lspconfig'
  local lspSettings = require 'david.plugins.lsp.settings'

  local servers = {
    -- LSP's
    gopls = lspSettings.go,
    lua_ls = lspSettings.lua,
    tsserver = lspSettings.ts,
    angularls = lspSettings.angular,
    html = { filetypes = { 'html', 'hbs' } },
    -- cssls = lspSettings.css,
    -- eslint = {},
    -- jsonls = {},
    -- tailwindcss = {}
  }

  masonLspConfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  masonLspConfig.setup_handlers {
    function(serverName)
      lspConfig[serverName].setup {
        on_attach = lspSettings.on_attach,
        capabilities = lspSettings.capabilities,
        settings = servers[serverName].settings or {},
        filetypes = (servers[serverName].settings or {}).filetypes,
        commands = servers[serverName].commands,
      }
    end,
  }

  -- Illuminate settings
  require('illuminate').configure {
    delay = 150,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { 'lsp' },
    },
  }

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
