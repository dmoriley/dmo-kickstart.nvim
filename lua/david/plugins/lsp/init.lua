return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        'williamboman/mason.nvim',
        config = true,
      },
      'williamboman/mason-lspconfig.nvim',
      'folke/trouble.nvim',
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
    ft = { 'javascriptreact', 'typescriptreact', 'javascript', 'typescript' },
    cmd = { 'TSC' },
    opts = true,
  },
}
