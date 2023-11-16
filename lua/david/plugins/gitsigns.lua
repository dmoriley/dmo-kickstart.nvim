return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    keys = {
        { "<leader>gh", "<cmd>Gitsigns preview_hunk<CR>",              mode = 'n', desc = 'Git preview hunk',      noremap = true, silent = true },
        { "<leader>gb", "<cmd>Gitsigns blame_line<CR>",                mode = 'n', desc = 'Git blame line',        noremap = true, silent = true },
        { "<leader>gd", "<cmd>Gitsigns toggle_deleted<CR>",            mode = 'n', desc = 'Git toggle deleted',    noremap = true, silent = true },
        { "<leader>gw", "<cmd>Gitsigns toggle_word_diff<CR>",          mode = 'n', desc = 'Git toggle word diff',  noremap = true, silent = true },
        { "<leader>go", "<cmd>Gitsigns<CR>",                           mode = 'n', desc = 'Git options',           noremap = true, silent = true },
        { "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", mode = 'n', desc = 'Git toggle blame line', noremap = true, silent = true },
    },
    opts = {
        -- See `:help gitsigns.txt`
        signs = {
            add = { text = " +" },
            change = { text = " " },
            delete = { text = " " },
            untracked = { text = "┆" },
            topdelete = { text = " " },
            changedelete = { text = " " },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            -- Visual mode padding for selection
            local vmap = function(keys, func, desc)
                if desc then
                    desc = "Git: " .. desc
                end
                local opts = { buffer = bufnr, noremap = true, silent = true, desc = desc }
                vim.keymap.set("v", keys, func, opts)
            end

            vmap("gs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage Selected")

            vmap("gu", function()
                gs.undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Undo Staged")

            vmap("gr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Reset Selected")
            -- end of visual mode mapping

            -- don't override the built-in and fugitive keymaps
            vim.keymap.set({ 'n', 'v' }, ']c', function()
                if vim.wo.diff then
                    return ']c'
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
            vim.keymap.set({ 'n', 'v' }, '[c', function()
                if vim.wo.diff then
                    return '[c'
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
        end,
    },
}
