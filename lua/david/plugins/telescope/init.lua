return {
  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    -- cmd = 'Telescope'
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
    config = function()
      local actions = require('telescope.actions')
      local custom_pickers = require('david.plugins.telescope.custom_pickers')

      require('telescope').setup({
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
            flex = {
              -- breakpoints for flex layout, when to swap between vertical and horizontal
              -- flip_lines = 20,
              flip_columns = 170,
            },
          },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              -- after the selection of a telescope item, center the cursor vertically on the buffer window
              ['<CR>'] = actions.select_default + actions.center,
            },
            n = {
              ['<CR>'] = actions.select_default + actions.center,
              ['<C-c>'] = actions.close,
            },
          },
        },
        pickers = {
          help_tags = {
            mappings = {
              n = {
                ['<CR>'] = actions.select_vertical,
              },
              i = {
                ['<CR>'] = actions.select_vertical,
              },
            },
          },
          oldfiles = {
            sort_lastused = true,
          },
          find_files = {
            path_display = { 'truncate' },
            find_command = {
              'rg',
              '--files',
              '--color',
              'never',
            },
            mappings = {
              i = {
                ['<C-h>'] = custom_pickers.actions.toggle_find_files_hidden,
                ['<C-i>'] = custom_pickers.actions.toggle_find_files_no_ignore,
              },
            },
          },
          git_files = {
            show_untracked = true,
          },
          live_grep = {
            -- ripgrep is the default tool for live_grep and grep_string
            path_display = { truncate = 3 },
            mappings = {
              i = {
                ['<C-k>'] = custom_pickers.actions.set_extension,
                ['<C-i>'] = custom_pickers.actions.set_ignore_extension,
              },
            },
            -- consider disabling treesitter in preview window for performance
            -- preview = {
            --     treesitter = false
            -- }
          },
          grep_string = {
            path_display = { truncate = 3 },
          },
          buffers = {
            sort_lastused = true,
            sort_mru = true,
            ignore_current_buffer = true,
            theme = 'dropdown',
            previewer = false,
            mappings = {
              i = { ['<C-d>'] = actions.delete_buffer },
              n = { ['<C-d>'] = actions.delete_buffer },
            },
          },
          builtin = {
            theme = 'dropdown',
            include_extensions = true,
            use_default_opts = true,
            layout_config = {
              width = 50,
              height = 0.5,
            },
          },
          diagnostics = {
            sort_by = 'severity',
          },
        },
        extensions = {
          file_browser = {
            mappings = {
              n = {
                ['<CR>'] = actions.select_default,
              },
              i = {
                ['<CR>'] = actions.select_default,
              },
            },
          },
        },
      })

      -- Enable telescope fzf native, if installed
      require('telescope').load_extension('fzf')

      local keymap = vim.keymap.set
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
        require('telescope.builtin').live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end
      keymap('n', '<leader>s/', telescope_live_grep_open_files, options('Search by Grep in open files'))
      keymap('n', '<leader>sg', custom_pickers.custom_live_grep, options('[S]earch by Grep'))
      keymap('n', '<leader>so', require('telescope.builtin').oldfiles, options('[S]earch recently [o]pened files'))
      keymap('n', '<leader><space>', require('telescope.builtin').buffers, options('[ ] Find existing buffers'))
      keymap('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, options('Current Buffer Fuzzy'))
      keymap('n', '<leader>sz', require('telescope.builtin').builtin, options('[S]earch Telescope builtin'))
      keymap('n', '<leader>sf', custom_pickers.custom_find_files, options('[S]earch Files'))
      keymap('n', '<leader>sh', require('telescope.builtin').help_tags, options('[S]earch Help'))
      keymap('n', '<leader>sr', require('telescope.builtin').resume, options('[S]earch Resume'))
      -- Search the nvim config workspace to tweak things on the fly
      keymap('n', '<leader>sx', function()
        require('telescope.builtin').find_files({ cwd = '~/.config/nvim' })
      end, options('Search nvim config workspace'))

      keymap('n', '<leader>sdd', function()
        require('telescope.builtin').diagnostics({ bufnr = 0 })
      end, options('[S]earch [D]ocument [D]iagnostics'))
      keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols, options('[S]earch [D]ocument [S]ymbols'))
      keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, options('[S]earch [W]orkspace [S]ymbols'))
      keymap('n', '<leader>sk', require('telescope.builtin').keymaps, options('Search Keymaps'))
      keymap('n', '<leader>sww', require('telescope.builtin').grep_string, options('Search workspace for current word'))
      keymap('n', '<leader>sc', require('telescope.builtin').commands, options('Search commands'))
      -- vim.keymap.set('x', '<leader>sww',  '"zy<Cmd>Telescope live_grep<CR><C-r>z', options('Search workspace for selection') ) -- alternative search workspace for selection
      keymap('n', '<leader>sm', require('telescope.builtin').marks, options('[S]earch marks'))
      keymap(
        'x',
        '<leader>sww',
        '"zy<Cmd>lua require("telescope.builtin").grep_string({search=vim.fn.getreg("z")})<CR>',
        options('Search workspace for selection')
      )
      keymap('n', 'gr', function()
        require('telescope.builtin').lsp_references({ fname_width = 50, trim_text = false })
      end, options('Goto References'))
      -- lsp_definitions is async so the zz command happens before definitions completes. Need to look into how to do this. For now it doesn't center
      keymap('n', 'gd', "<CMD>lua require('telescope.builtin').lsp_definitions()<CR> <bar> <CMD> lua vim.cmd.normal('zz')<CR>", options('Goto Definition'))
      keymap('n', 'gtd', require('telescope.builtin').lsp_type_definitions, options('Goto Type Definition'))
      keymap('n', 'gI', require('telescope.builtin').lsp_implementations, options('Goto Implementation'))
      keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols, options('Search Document Symbols'))
      keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, options('Search Workspace Symbols'))

      -- git stuff
      keymap('n', '<leader>gf', require('telescope.builtin').git_files, options('Search Git Files'))
    end,
  },
  -- telescope dep, but seperate from dep table so it can be lazy loaded
  require('david.plugins.telescope.telescope_file_browser'),
}
