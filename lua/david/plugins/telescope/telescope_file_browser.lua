return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>sF',
      '<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>',
      mode = 'n',
      desc = 'Telescope file browser',
      noremap = true,
      silent = true,
    },
  },
  cmd = { 'Telescope file_browser' },
  config = function()
    require('telescope').load_extension('file_browser')
  end,
}
