return {
  -- neovim api completion
  'folke/lazydev.nvim',
  ft = 'lua',
  cmd = 'LazyDev',
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'lazy.nvim', words = { 'LazyVim' } },
    },
  },
}