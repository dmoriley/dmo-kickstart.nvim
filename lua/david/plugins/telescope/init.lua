return {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    -- cmd = 'Telescope'
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    config = function()
        local actions = require('telescope.actions')
        local custom_pickers = require('david.plugins.telescope.custom_pickers')

        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                        -- after the selection of a telescope item, center the cursor vertically on the buffer window
                        ['<CR>'] = actions.select_default + actions.center,
                    },
                    n = {
                        ['<CR>'] = actions.select_default + actions.center,
                    }
                }
            },
            pickers = {
                help_tags = {
                    mappings = {
                        n = {
                            ['<CR>'] = actions.select_vertical
                        },
                        i = {
                            ['<CR>'] = actions.select_vertical
                        }
                    }
                },
                oldfiles = {
                    sort_lastused = true
                },
                find_files = {
                    path_display = { "truncate" },
                    find_command = {
                        'rg',
                        '--files',
                        '--color',
                        'never'
                    }
                },
                live_grep = {
                    -- ripgrep is the default tool for live_grep and grep_string
                    path_display = { "shorten" },
                    mappings = {
                        i = {
                            ['<C-k>'] = custom_pickers.actions.set_extension,
                            ['<C-i>'] = custom_pickers.actions.set_ignore_extension,
                            ['<C-l>'] = custom_pickers.actions.set_folders,
                        }
                    }
                    -- consider disabling treesitter in preview window for performance
                    -- preview = {
                    --     treesitter = false
                    -- }
                }
            }
        }


        -- Enable telescope fzf native, if installed
        require('telescope').load_extension('fzf')

        local keymap = vim.keymap.set;
        local options = function(description)
            if description then
                return { noremap = true, silent = true, desc = description }
            end
            return { noremap = true, silent = true }
        end

        --[[
        -- Telescope live_grep in git root
        -- Function to find the git root directory based on the current buffer's path
        local function find_git_root()
            -- Use the current buffer's path as the starting point for the git search
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir
            local cwd = vim.fn.getcwd()
            -- If the buffer is not associated with a file, return nil
            if current_file == '' then
                current_dir = cwd
            else
                -- Extract the directory from the current file's path
                current_dir = vim.fn.fnamemodify(current_file, ':h')
            end

            -- Find the Git root directory from the current file's path
            local git_root = vim.fn.systemlist('git -C ' ..
                vim.fn.escape(current_dir, ' ') .. " rev-parse --show-toplevel")[1]
            if vim.v.shell_error ~= 0 then
                print('Not a git repository. Searching on current working directory')
                return cwd
            end
            return git_root
        end

        -- Grep functions

        -- Custom live_grep function to search in git root
        local function live_grep_git_root()
            local git_root = find_git_root()
            if git_root then
                require('telescope.builtin').live_grep({
                    search_dirs = { git_root },
                })
            end
        end
        -- assign a function to user defined command and use in keymap
        vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
        keymap('n', '<leader>sG', '<Cmd>LiveGrepGitRoot<CR>', options('[S]earch by Grep on Git Root')) 
        
        ]]

        local function telescope_live_grep_open_files()
            require('telescope.builtin').live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end
        keymap('n', '<leader>s/', telescope_live_grep_open_files, options('Search by Grep in open files'))
        keymap('n', '<leader>sg', require('telescope.builtin').live_grep, options('[S]earch by Grep'))

        -- -------


        vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles,
            { desc = '[S]earch recently [o]pened files' })
        vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
            { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
                layout_config = {
                    height = 35
                }
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        keymap('n', '<leader>sz', require('telescope.builtin').builtin, options('[S]earch Telescope builtin'))
        keymap('n', '<leader>sf', require('telescope.builtin').find_files, options('[S]earch Files'))
        keymap('n', '<leader>sh', require('telescope.builtin').help_tags, options('[S]earch Help'))
        keymap('n', '<leader>sr', require('telescope.builtin').resume, options('[S]earch Resume'))
        -- Search the nvim config workspace to tweak things on the fly
        keymap('n', '<leader>sc',
            function()
                require('telescope.builtin').find_files({ cwd = '~/.config/nvim' })
            end,
            options('Search nvim config workspace')
        )

        keymap('n', '<M-p>', require('telescope.builtin').git_files, options('Search Git Files'))
        keymap('n', '<leader>sdd', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, options('[S]earch [D]ocument [D]iagnostics'))
        keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols,
            options('[S]earch [D]ocument [S]ymbols'))
        keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
            options('[S]earch [W]orkspace [S]ymbols'))
        keymap('n', '<leader>sk', require('telescope.builtin').keymaps, options('[S]earch [K]eymaps'));
        keymap('n', '<leader>sww', require('telescope.builtin').grep_string, options('Search workspace for current word'))
        keymap('n', '<leader>sx', require('telescope.builtin').commands, options('[S]earch commands'))
        -- vim.keymap.set('x', '<leader>sww',  '"zy<Cmd>Telescope live_grep<CR><C-r>z', options('Search workspace for selection') ) -- alternative search workspace for selection
        keymap('x', '<leader>sww',
            '"zy<Cmd>lua require("telescope.builtin").grep_string({search=vim.fn.getreg("z")})<CR>',
            options('Search workspace for selection'))
        keymap('n', '<leader>sm', require('telescope.builtin').marks, options('[S]earch marks'))

        keymap('n', 'gr', function() require('telescope.builtin').lsp_references({ fname_width = 50, trim_text = false}) end, options('Goto References'))
        -- lsp_definitions is async so the zz command happens before definitions completes. Need to look into how to do this. For now it doesn't center
        keymap('n', 'gd', "<CMD>lua require('telescope.builtin').lsp_definitions()<CR> <bar> <CMD> lua vim.cmd.normal('zz')<CR>", options('Goto Definition'))
        keymap('n', 'gtd', require('telescope.builtin').lsp_type_definitions, options('Goto Type Definition'))
        keymap('n', 'gI', require('telescope.builtin').lsp_implementations, options('Goto Implementation'))
        keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols, options('Search Document Symbols'))
        keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, options('Search Workspace Symbols'))
    end

}
