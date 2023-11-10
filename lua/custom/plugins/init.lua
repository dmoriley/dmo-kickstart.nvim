-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        'goolord/alpha-nvim',
        lazy = false,
        config = function ()
            -- require('alpha').setup(require'alpha.themes.dashboard'.config)
            require('custom.configs.alpha-nvim')
        end
    },
    {
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
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require('custom.configs.nvim-tree')
        end
    },
    {
        -- for how to use see :help nvim-surround.usage
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        -- Auto pair, automatically add closing brackets
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        -- Optional dependency
        dependencies = { 'hrsh7th/nvim-cmp' },
        config = function()
            require("nvim-autopairs").setup {}
            -- If you want to automatically add `(` after selecting a function or method
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
    },
    {
        "mbbill/undotree",
        event = "VeryLazy",
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_WindowLayout = 2
        end
    },
    {
        "nvimtools/none-ls.nvim",
        lazy = true,
        ft = "go", -- filetype to load for
        opts = function()
            return require "custom.configs.none-ls"
        end
    },
    -- {
    --     -- syntax highlights for inline templates, inline styles and specific HTML highlighting
    --     "nvim-treesitter/nvim-treesitter-angular"
    -- }
    --[[ {
        "nvim-neo-tree/neo-tree.nvim",
        version = "*",
        dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        },
        config = function ()
        require('neo-tree').setup {}
        end,
    } ]]
}
