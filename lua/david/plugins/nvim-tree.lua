return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    cmd = { 'NvimTreeToggle'},
    -- event = 'BufReadPre',
    keys = {
        { '<leader>-', ':NvimTreeToggle<cr>', mode = 'n', desc = 'NvimTree toggle', noremap = true, silent = true }
    },
    opts = function()
        -- local HEIGHT_RATIO = 0.8
        -- local WIDTH_RATIO = 0.5

        return {
            disable_netrw = true,
            hijack_netrw = true,
            respect_buf_cwd = true,
            sync_root_with_cwd = true,
            view = {
                width = 35,
                adaptive_size = true,
                side = "left",
                -- float = {
                --     enable = false, -- enable for floating instead of left aligned
                --     open_win_config = function()
                --         local screen_w = vim.opt.columns:get()
                --         local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                --         local window_w = screen_w * WIDTH_RATIO
                --         local window_h = screen_h * HEIGHT_RATIO
                --         local window_w_int = math.floor(window_w)
                --         local window_h_int = math.floor(window_h)
                --         local center_x = (screen_w - window_w) / 2
                --         local center_y = ((vim.opt.lines:get() - window_h) / 2)
                --             - vim.opt.cmdheight:get()
                --         return {
                --             border = "rounded",
                --             relative = "editor",
                --             row = center_y,
                --             col = center_x,
                --             width = window_w_int,
                --             height = window_h_int,
                --         }
                --     end
                -- }
            },
            update_focused_file = {
                enable = true
            }
        }
    end
}
