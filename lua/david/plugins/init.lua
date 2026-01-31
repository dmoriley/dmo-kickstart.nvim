-- plugins that don't need configs
return {
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    event = 'VeryLazy',
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },
  {
    -- Better f/F/t/T finding
    'rhysd/clever-f.vim',
    event = 'VeryLazy',
  },
}
