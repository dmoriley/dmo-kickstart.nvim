return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git' },
    keys = {
      { '<leader>gl', '<cmd>vertical Git log %<CR>', mode = 'n', desc = 'Git log of current buffer', noremap = true, silent = true },
      {
        '<leader>gg',
        '<cmd>tabnew<cr><cmd>vertical Git<cr><cmd>vertical resize 60<cr>',
        mode = 'n',
        desc = 'Open Git Fugitive in new tab',
        noremap = true,
        silent = true,
      },
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    keys = {
      { '<leader>go', '<cmd>Gitsigns<CR>', mode = 'n', desc = 'Search Git options', noremap = true, silent = true },
      { '<leader>gh', '<cmd>Gitsigns preview_hunk<CR>', mode = 'n', desc = 'Git preview hunk', noremap = true, silent = true },
      { '<leader>gb', '<cmd>Gitsigns blame_line<CR>', mode = 'n', desc = 'Git blame line', noremap = true, silent = true },
      { '<leader>gd', '<cmd>Gitsigns toggle_deleted<CR>', mode = 'n', desc = 'Git toggle deleted diff', noremap = true, silent = true },
      { '<leader>gw', '<cmd>Gitsigns toggle_word_diff<CR>', mode = 'n', desc = 'Git toggle word diff', noremap = true, silent = true },
      -- { '<leader>gl', '<cmd>Gitsigns toggle_current_line_blame<CR>', mode = 'n', desc = 'Git toggle blame line', noremap = true, silent = true },
      { '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>', mode = 'n', desc = 'Git stage hunk', noremap = true, silent = true },
      { '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>', mode = 'n', desc = 'Git stage buffer', noremap = true, silent = true },
      { '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>', mode = 'n', desc = 'Git reset hunk', noremap = true, silent = true },
      { '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>', mode = 'n', desc = 'Git reset buffer', noremap = true, silent = true },
      { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>', mode = 'n', desc = 'Git undo stage hunk', noremap = true, silent = true },
    },
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = ' +' },
        change = { text = ' ' },
        delete = { text = ' ' },
        untracked = { text = '┆' },
        topdelete = { text = ' ' },
        changedelete = { text = ' ' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Visual mode padding for selection
        local vmap = function(keys, func, desc)
          if desc then
            desc = 'Git: ' .. desc
          end
          local opts = { buffer = bufnr, noremap = true, silent = true, desc = desc }
          vim.keymap.set('v', keys, func, opts)
        end

        vmap('gs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Stage Selected hunks')

        vmap('gu', function()
          gs.undo_stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Undo Staged')

        vmap('gr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Reset Selected hunks')
        -- end of visual mode mapping

        -- don't override the built-in and fugitive keymaps
        vim.keymap.set({ 'n', 'v' }, ']h', function()
          if vim.wo.diff then
            return ']h'
          end
          vim.schedule(function()
            gs.next_hunk()
            vim.cmd.normal('zz') -- center the cursor
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[h', function()
          if vim.wo.diff then
            return '[h'
          end
          vim.schedule(function()
            gs.prev_hunk()
            vim.cmd.normal('zz') -- center the cursor
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },
}
