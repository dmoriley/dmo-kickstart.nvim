return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      'williamboman/mason.nvim',
      opts = {}
    },
    'williamboman/mason-lspconfig.nvim',
    'folke/neodev.nvim',
    'folke/trouble.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    "RRethy/vim-illuminate", -- highlighting and cursor over after delay
  },
  event = "BufReadPre",
  config = require("david.plugins.lsp.config")
}
