return {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('onedark').setup {
            style = 'deep',
            term_colors = true,
            transparent = true
        }
        require('onedark').load()
        vim.cmd.colorscheme 'onedark'
    end
}
