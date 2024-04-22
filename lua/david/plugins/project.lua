return {
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    opts = {
      manual_mode = false,
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('project_nvim').setup()
      require('telescope').load_extension('projects')
    end,
    keys = {
      { '<leader>sp', '<Cmd>Telescope projects<CR>', mode = 'n', desc = 'Search Projects', noremap = true, silent = true },
    },
  },
}
