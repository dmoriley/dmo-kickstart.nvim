return {
  'tpope/vim-fugitive',
  cmd = { 'G', 'Git' },
  keys = {
    {
      '<leader>gg',
      '<cmd>tabnew<cr><cmd>vertical Git<cr><cmd>vertical resize 60<cr>',
      mode = 'n',
      desc = 'Open Git Fugitive in new tab',
      noremap = true,
      silent = true,
    },
  },
}
