return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({
      style = 'storm',
      term_colors = true,
      transparent = false,
    })
    -- vim.cmd('colorscheme tokyonight-night')
  end,
}
