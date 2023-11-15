return {
    'lukas-reineke/indent-blankline.nvim',
    event = "BufReadPre",
    main = 'ibl',
    config = function()
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#2a090c" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#2b1f08" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#082a45" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#3b2612" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#243518" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#320f3d" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#143438" })
        end)

        require("ibl").setup({
            indent = {
                highlight = highlight
            },
            -- whitespace = {
            --     highlight = {
            --         "CursorColumn",
            --         "Whitespace"
            --     }
            -- }
        })
    end
}
