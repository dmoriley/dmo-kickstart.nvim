return {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
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
        local actions = require("telescope.actions")
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                        -- after the selection of a telescope item, center the cursor vertically on the buffer window
                        ['<CR>'] = actions.select_default + actions.center,
                    },
                },
                path_display = { "truncate" }
            },
        }


        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')

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

        local function telescope_live_grep_open_files()
            require('telescope.builtin').live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end


        local keymap = vim.keymap.set;
        local options = function(description)
            if description then
                return { noremap = true, silent = true, desc = description }
            end
            return { noremap = true, silent = true }
        end

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
        keymap('n', '<leader>sf', require('telescope.builtin').find_files, options('[S]earch [F]iles'))
        keymap('n', '<leader>sh', require('telescope.builtin').help_tags, options('[S]earch [H]elp'))
        keymap('n', '<leader>sr', require('telescope.builtin').resume, options('[S]earch [R]esume'))
        -- Search the nvim config workspace to tweak things on the fly
        keymap('n', '<leader>sc',
            function()
                require('telescope.builtin').find_files({ cwd = '~/.config/nvim' })
            end,
            options('Search nvim config workspace')
        )

        keymap('n', '<M-p>', require('telescope.builtin').git_files, options('Search Git Files'))
        keymap('n', '<leader>sG', '<Cmd>LiveGrepGitRoot<CR>', options('[S]earch by [G]rep on Git Root'))
        keymap('n', '<leader>s/', telescope_live_grep_open_files, options('Search by grep in open files'))
        keymap('n', '<leader>sg', require('telescope.builtin').live_grep, options('[S]earch by [G]rep'))
        keymap('n', '<leader>sdd', require('telescope.builtin').diagnostics, options('[S]earch [D]ocument [D]iagnostics'))
        keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols,
            options('[S]earch [D]ocument [S]ymbols'))
        keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
            options('[S]earch [W]orkspace [S]ymbols'))
        keymap('n', '<leader>sk', require('telescope.builtin').keymaps, options('[S]earch [K]eymaps'));
        keymap('n', '<leader>sww', require('telescope.builtin').grep_string, options('Search workspace for current word'))
        -- vim.keymap.set('x', '<leader>sww',  '"zy<Cmd>Telescope live_grep<CR><C-r>z' ) -- alternative to the below command using live_grep
        keymap('x', '<leader>sww',
            '"zy<Cmd>lua require("telescope.builtin").grep_string({search=vim.fn.getreg("z")})<CR>',
            options('Search workspace for selection'))
    end

}
