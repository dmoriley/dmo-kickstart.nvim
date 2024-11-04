-- plugins that don't need configs
return {
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },
  -- {
  --     "kylechui/nvim-surround",
  --     event = "InsertEnter",
  --     opts = {}
  -- },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },
}
