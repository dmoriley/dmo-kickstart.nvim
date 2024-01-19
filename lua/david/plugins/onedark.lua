return {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('onedark').setup {
            style = 'deep',
            term_colors = true,
            transparent = true,
            -- highlights = { -- could change highlights here instead of ui.lua
            --     CursorLine = { bg = 'none', fmt = 'underline'}
            -- }
        }
        -- lua equivalent of vim.cmd([[colorscheme onedark]])
        -- require('onedark').load()
    end
}
