return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require('tokyonight').setup {
            style = 'storm',
            term_colors = true,
            transparent = true,
            on_highlights = function(hl, _)
                local colour = "#c23bf7"
                hl.TelescopeNormal = {
                }
                hl.TelescopeBorder = {
                    fg = colour,
                }
                hl.TelescopePromptNormal = {
                    fg = colour,
                }
                hl.TelescopePromptBorder = {
                    fg = colour,
                }
                hl.TelescopePromptTitle = {
                    fg = colour,
                }
                hl.TelescopePreviewTitle = {
                    fg = colour,
                }
                hl.TelescopeResultsTitle = {
                    fg = colour
                }
            end,
        }
    end

}
