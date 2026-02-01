return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- Lazy load when one of the keymaps is executed
    keys = {
        { '<leader>st', ':TodoTelescope<cr>', mode = 'n', desc = 'Search Todo\'s', noremap = true, silent = true },
        {
            ']t',
            function()
                require('todo-comments').jump_next({ keywords = { 'TODO' } })
            end,
            mode = 'n',
            desc = 'Next todo comment',
            noremap = true,
            silent = true
        },
        {
            '[t',
            function()
                require('todo-comments').jump_prev({ keywords = { 'TODO' } })
            end,
            mode = 'n',
            desc = 'Previous todo comment',
            noremap = true,
            silent = true
        }
    },
    opts = {
        keywords = {
            TODO = {  color = '#FF8C00' },
        }
    }
}
