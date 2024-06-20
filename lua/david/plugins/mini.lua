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
    vim.keymap.set('n', '<leader>bd', function()
      -- _G is global table that MiniBufremove was added to in the setup function
      -- could have just used a require call
      _G.MiniBufremove.delete(vim.api.nvim_get_current_buf())
    end, { noremap = true, silent = true, desc = 'Delete current buffer' })

    vim.keymap.set('n', '<leader>bD', function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if buf ~= vim.api.nvim_get_current_buf() then
          _G.MiniBufremove.delete(buf)
        end
      end
    end, { noremap = true, silent = true, desc = 'Delete all but current buffer' })

    vim.keymap.set('n', '<C-q>', function()
      -- _G is global table that MiniBufremove was added to in the setup function
      -- could have just used a require call
      _G.MiniBufremove.wipeout(vim.api.nvim_get_current_buf())
    end, { noremap = true, silent = true, desc = 'Wipeout current buffer' })

    vim.keymap.set('n', '<leader>bw', function()
      -- _G is global table that MiniBufremove was added to in the setup function
      -- could have just used a require call
      _G.MiniBufremove.wipeout(vim.api.nvim_get_current_buf())
    end, { noremap = true, silent = true, desc = 'Wipeout current buffer' })

    vim.keymap.set('n', '<leader>bW', function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if buf ~= vim.api.nvim_get_current_buf() then
          _G.MiniBufremove.wipeout(buf)
        end
      end
    end, { noremap = true, silent = true, desc = 'Wipeout all but current buffer' })

    -- line and word jumping

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
