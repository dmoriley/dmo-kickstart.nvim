return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require('conform')

    conform.setup({
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = false,
        async = false,
      },
      formatters_by_ft = {
        -- sub-list to run only the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt' }, --golines
      },
    })

    -- normal mode: format whole file
    -- visual mode: format selection
    vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
      conform.format({
        timeout_ms = 500,
        lsp_fallback = false,
        async = false,
      })
    end, { noremap = true, silent = true, desc = 'Code format file or range (in visual mode)' })
  end,
}
