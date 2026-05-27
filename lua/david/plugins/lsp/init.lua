return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'mason-org/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        inlay_hints = {
          enabled = true,
        },
        -- document_highlight = {
        --   enable = true,
        -- },
      }
      return ret
    end,
    config = require('david.plugins.lsp.config'),
  },
  {
    'mason-org/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
    lazy = true,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'mason-org/mason.nvim',
    },
    opts = function()
      return {
        ensure_installed = require('david.plugins.lsp.servers').tools,
        run_on_start = true,
      }
    end,
    lazy = true,
  },
  {
    'yioneko/nvim-vtsls',
    ft = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
  },
}
