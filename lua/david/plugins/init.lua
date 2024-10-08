-- plugins that don't need configs
return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit' },
  },
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
