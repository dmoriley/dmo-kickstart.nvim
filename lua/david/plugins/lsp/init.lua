return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
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
    cmd = { 'TSC' },
    config = true,
  },
}
