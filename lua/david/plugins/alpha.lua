return {
    "goolord/alpha-nvim",
    config = function()
        local alpha = require('alpha');
        local dashboard = require('alpha.themes.dashboard');

        dashboard.section.header.val = {
            [[                                                 ]],
            [[                                                 ]],
            [[                                                 ]],
            [[                                                 ]],
            [[                                                 ]],
            [[ ███╗  ██╗███████╗ █████╗ ██╗   ██╗██╗███╗   ███╗]],
            [[ ████╗ ██║██╔════╝██╔══██╗██║   ██║██║████╗ ████║]],
            [[ ██╔██╗██║█████╗  ██║  ██║╚██╗ ██╔╝██║██╔████╔██║]],
            [[ ██║╚████║██╔══╝  ██║  ██║ ╚████╔╝ ██║██║╚██╔╝██║]],
            [[ ██║ ╚███║███████╗╚█████╔╝  ╚██╔╝  ██║██║ ╚═╝ ██║]],
            [[ ╚═╝  ╚══╝╚══════╝ ╚════╝    ╚═╝   ╚═╝╚═╝     ╚═╝]],
            [[                                                 ]],
            [[                                                 ]],
            [[                                                 ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", "<CMD>Telescope find_files <CR>"),
            dashboard.button("e", "  New file", "<CMD>ene <BAR> startinsert <CR>"),
            dashboard.button("r", "  Recently used files", "<CMD>Telescope oldfiles <CR>"),
            dashboard.button("t", "  Find text", "<CMD>Telescope live_grep <CR>"),
            dashboard.button("p", "📁  Find Project", "<CMD>Telescope projects<CR>"),
            dashboard.button("c", "  Configuration", "<CMD>cd $HOME/.config/nvim/ | lua require('telescope.builtin').find_files()<CR>"),
            dashboard.button("o", "  Current Directory Session", "<CMD>lua require('persistence').load()<CR>"),
            dashboard.button("l", "⏪  Last Session", "<CMD>lua require('persistence').load({ last = true })<CR>"),
            dashboard.button("x", "  File Explorer", "<cmd>Oil<CR>"),
            dashboard.button("q", "  Quit Neovim", "<CMD>qa<CR>"),
        }

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡" .. stats.count .. " plugins loaded in " .. ms .. "ms" .. " ⚡"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true -- prevent keymaps aside from defined above in alpha menu
        alpha.setup(dashboard.opts);
    end
}
