return {
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                component_separators = '|',
                section_separators = '',
            },
            tabline = {
                lualine_a = { 'buffers' },
                -- lualine_b = {},
                -- lualine_c = {},
                -- lualine_x = {},
                lualine_y = {'diagnostics'},
                lualine_z = {'diff'}
            },
        })
    end
}
