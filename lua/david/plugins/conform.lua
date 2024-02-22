return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = false,
        async = false,
      },
      formatters_by_ft = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        lua = { 'stylua' },
        go = { 'goimports', 'golines' }, -- goimports also does gofmt
      },
    }

    -- normal mode: format whole file
    -- visual mode: format selection
    vim.keymap.set({ 'n', 'v' }, '<leader>df', function()
      conform.format {
        timeout_ms = 500,
        lsp_fallback = false,
        async = false,
      }
    end, { noremap = true, silent = true, desc = 'Document format or range (in visual mode)' })
  end,
}
