return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'BufReadPre',
    config = function ()
        local buf = require('bufferline')
        vim.keymap.set('n', '<Tab>', buf.pick, { desc = 'Quick pick a bufferline tab'} )
        buf.setup({
            options = {
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = 'File Explorer',
                        highlight = 'Directory',
                        separator = true -- true to just use the default
                    }
                },
                numbers = 'buffer_id',
                buffer_close_icon = 'x',
                modified_icon = '●',
                close_icon = '',
                left_trunc_marker = '',
                right_trunc_marker = '',
                separator_style = 'slant'
            },
        })
    end
}
