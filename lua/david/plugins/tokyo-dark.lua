-- see tokyodark.pallete.lua for more colours
local fgColour = '#d2a8ff'
local bgColour = '#06020C'

return {
  'tiagovla/tokyodark.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    custom_highlights = {
      FloatBorder = { fg = fgColour, bg = bgColour },
      NormalFloat = { bg = bgColour },
      TelescopeNormal = { bg = bgColour },
      TelescopeBorder = { fg = fgColour },
    },
  },
  config = function(_, opts)
    require('tokyodark').setup(opts)
    vim.cmd('colorscheme tokyodark')
  end,
}
