return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'BufReadPre',
  config = function()
    require('mini.indentscope').setup({
      draw = {
        animation = require('mini.indentscope').gen_animation.quadratic({ duration = 5 }),
        -- animation = require('mini.indentscope').gen_animation.none() -- for no animation
      },
      options = {
        try_as_border = true,
      },
      -- symbol = '╎' -- default
      -- symbol = '█',-- thick line
      symbol = '┃',
    })
    -- vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = 'red' }) -- set highlight colour if needed

    -- Better buffer deletion
    require('mini.bufremove').setup()
    vim.keymap.set('n', '<leader>bd', '<CMD>bdelete<CR>', { noremap = true, silent = true, desc = 'Delete Buffer' })

    -- line and word jumping
    require('mini.jump2d').setup()

    -- move selected lines or current line in normal
    require('mini.move').setup()

    -- highlighted notifications in floating window
    require('mini.notify').setup()

    -- tabline instead of using lualine tabline
    require('mini.tabline').setup()

    require('mini.surround').setup({
      n_lines = 500,
    })
  end,
}
