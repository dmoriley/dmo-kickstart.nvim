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
    local notify = require('mini.notify')
    notify.setup()
    vim.notify = notify.make_notify({
      ERROR = { duration = 10000, hl_group = 'DiagnosticError' },
      WARN = { duration = 5000, hl_group = 'DiagnosticWarn' },
      INFO = { duration = 5000, hl_group = 'DiagnosticInfo' },
      DEBUG = { duration = 0, hl_group = 'DiagnosticHint' },
      TRACE = { duration = 0, hl_group = 'DiagnosticOk' },
      OFF = { duration = 0, hl_group = 'MiniNotifyNormal' },
    })

    vim.api.nvim_create_user_command('NotificationLog', notify.show_history, { nargs = 0, desc = 'Show MiniNotify log history' })

    -- tabline instead of using lualine tabline
    require('mini.tabline').setup()

    require('mini.surround').setup({
      n_lines = 500,
    })

    require('mini.files').setup({
      mappings = {
        close = '<C-c>',
        go_in_plus = '<Enter>',
        synchronize = 's',
      },
      windows = {
        preview = true,
        width_preview = 50,
      },
    })
    vim.keymap.set('n', '<leader>e', function() -- Open directory of current file (in last used state) focused on the file
      if not _G.MiniFiles.close() then
        _G.MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end
    end, { noremap = true, silent = true, desc = 'Toggle file explorer' })
    vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { fg = '#d2a8ff' })
  end,
}
