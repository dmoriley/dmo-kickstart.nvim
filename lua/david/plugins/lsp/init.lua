return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        dependencies = {
          'williamboman/mason-lspconfig.nvim',
        },
        build = ':MasonUpdate',
        config = function()
          require('mason').setup({
            ui = {
              border = 'rounded',
              icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗',
              },
            },
          })
        end,
      },
      'RRethy/vim-illuminate', -- highlighting and cursor over after delay
    },
    event = 'BufReadPre',
    -- opts = {
    --   inlay_hints = {
    --     enable = true,
    --   },
    --   document_highlight = {
    --     enable = true,
    --   },
    -- },
    config = require('david.plugins.lsp.config'),
  },
  -- not apart of lsp config, but tsc is a part of language server stuff, so putting in the same file
  {
    'dmmulroy/tsc.nvim',
    cmd = { 'TSC' },
    config = true,
  },
}
