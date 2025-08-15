local env = require('david.core.env')

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
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
  { 'mason-org/mason-lspconfig.nvim', lazy = true },
  {
    'RRethy/vim-illuminate', -- highlighting and cursor over after delay
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
    enabled = not env.NVIM_USER_USE_TS_LS,
  },
  {
    'dmmulroy/tsc.nvim',
    cmd = { 'TSC' },
    config = true,
  },
}
