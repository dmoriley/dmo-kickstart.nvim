-- TODO: delete later after use to new theme
return {
--[[     -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('onedark').setup {
            style = 'deep',
            term_colors = true,
            transparent = true,
        }
    end ]]
}
