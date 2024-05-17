-- see tokyodark.pallete.lua for more colours
local fgColour = '#d2a8ff'
local bgColour = '#06020C'

return {
  'tiagovla/tokyodark.nvim',
  opts = {},
  config = {
    custom_highlights = {
      FloatBorder = { fg = fgColour, bg = bgColour },
      NormalFloat = { bg = bgColour },
      TelescopeNormal = { bg = bgColour },
      TelescopeBorder = { fg = fgColour },
    },
  },
}
