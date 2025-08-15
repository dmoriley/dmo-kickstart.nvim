return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    lazy = false,
    branch = 'master', -- Switch branch to main in the future when its the default
    build = ':TSUpdate',
    config = function()
      -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
      vim.defer_fn(function()
        ---@diagnostic disable
        require('nvim-treesitter.configs').setup({
          -- Add languages to be installed here that you want installed for treesitter
          ensure_installed = {
            -- 'c',
            -- 'cpp',
            'go',
            'gomod',
            'gowork',
            'gosum',
            'lua',
            'tsx',
            'javascript',
            'typescript',
            'vimdoc',
            'vim',
            'bash',
            'css',
            'scss',
            'html',
            'markdown',
            'yaml',
            'dockerfile',
          },
          ignore_install = {},
          sync_install = false,
          -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
          auto_install = false,
          modules = {},

          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<c-space>',
              node_incremental = '<c-space>',
              scope_incremental = '<c-s>',
              node_decremental = '<M-space>',
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
              },
              goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
              },
              goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
              },
              goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
              },
            },
          },
        })
        require('treesitter-context').setup({
          enable = true,
        })
      end, 0)
    end,
  },
  -- treesitter dep, but seperate from dep table so it can be lazy loaded based on file type
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'javascript', 'typescript', 'astro', 'handlebars', 'xml', 'markdown' },
    opts = {
      autotag = {
        enable_close_on_slash = false,
      },
    },
  },
}
