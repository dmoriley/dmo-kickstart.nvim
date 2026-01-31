return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
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
    lazy = true, -- never auto lazy loads. Needs to be manually init by called one of the ft, cmd's or requiring it.
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
