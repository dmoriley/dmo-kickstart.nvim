local mapper = require('david.core.utils').mapper_factory
local nnoremap = mapper('n')

return {
  'nvim-mini/mini.nvim',
  version = false,
  event = { 'BufReadPost', 'BufNewFile' },
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
    nnoremap('<leader>bd', function()
      MiniBufremove.delete(vim.api.nvim_get_current_buf())
    end, { desc = 'Delete current buffer' })

    nnoremap('<leader>bD', function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if buf ~= vim.api.nvim_get_current_buf() then
          MiniBufremove.delete(buf)
        end
      end
    end, { desc = 'Delete all but current buffer' })

    nnoremap('<C-q>', function()
      MiniBufremove.wipeout(vim.api.nvim_get_current_buf())
    end, { desc = 'Wipeout current buffer' })

    nnoremap('<leader>bw', function()
      MiniBufremove.wipeout(vim.api.nvim_get_current_buf())
    end, { desc = 'Wipeout current buffer' })

    nnoremap('<leader>bW', function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if buf ~= vim.api.nvim_get_current_buf() then
          MiniBufremove.wipeout(buf)
        end
      end
    end, { desc = 'Wipeout all but current buffer' })

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
    nnoremap('<leader>e', function()
      if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end
    end, { desc = 'Toggle file explorer', silent = true })
    vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { fg = '#d2a8ff' })

    require('mini.cursorword').setup({ delay = 150 })
    vim.cmd('hi MiniCursorword gui=standout guifg=standout guibg=standout')

    require('mini.ai').setup({
      -- custom text object using m for matching pair, ex: yim
      custom_textobjects = {
        m = {
          { '%b()', '%b[]', '%b{}' },
          '^.().*().$',
        },
      },
    })
  end,
}
