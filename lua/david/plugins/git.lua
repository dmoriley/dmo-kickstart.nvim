local mapper = require('david.core.utils').mapper_factory
local nxnoremap = mapper({ 'n', 'x' })
local xnoremap = mapper('x')

return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git' },
    keys = {
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
    event = 'VeryLazy',
    keys = {
      { '<leader>go', '<cmd>Gitsigns<CR>', mode = 'n', desc = 'Search Git options', noremap = true, silent = true },
      { '<leader>gb', '<cmd>Gitsigns blame_line<CR>', mode = 'n', desc = 'Git blame line', noremap = true, silent = true },
      { '<leader>gd', '<cmd>Gitsigns toggle_deleted<CR>', mode = 'n', desc = 'Git toggle deleted diff', noremap = true, silent = true },
      { '<leader>gw', '<cmd>Gitsigns toggle_word_diff<CR>', mode = 'n', desc = 'Git toggle word diff', noremap = true, silent = true },
      -- { '<leader>gl', '<cmd>Gitsigns toggle_current_line_blame<CR>', mode = 'n', desc = 'Git toggle blame line', noremap = true, silent = true },
      -- { '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>', mode = 'n', desc = 'Git stage buffer', noremap = true, silent = true },
      -- { '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>', mode = 'n', desc = 'Git reset buffer', noremap = true, silent = true },
      -- hunks
      { 'ghp', '<cmd>Gitsigns preview_hunk<CR>', mode = 'n', desc = 'Git hunk preview', noremap = true, silent = true },
      { 'ghs', '<cmd>Gitsigns stage_hunk<CR>', mode = 'n', desc = 'Git hunk stage', noremap = true, silent = true },
      { 'ghr', '<cmd>Gitsigns reset_hunk<CR>', mode = 'n', desc = 'Git hunk reset', noremap = true, silent = true },
      { 'ghu', '<cmd>Gitsigns undo_stage_hunk<CR>', mode = 'n', desc = 'Git hunk undo stage', noremap = true, silent = true },
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
        xnoremap('ghs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Hunk Stage Selected' })

        xnoremap('ghu', function()
          gs.undo_stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Hunk Undo Stage Selected' })

        xnoremap('ghr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Hunk Reset Selected' })

        -- don't override the built-in and fugitive keymaps
        nxnoremap(']h', function()
          if vim.wo.diff then
            return ']h'
          end
          vim.schedule(function()
            gs.next_hunk()
            vim.cmd.normal('zz') -- center the cursor
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })

        nxnoremap('[h', function()
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
