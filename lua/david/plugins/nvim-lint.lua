return {
  'mfussenegger/nvim-lint',
  -- event = {
  --   'BufReadPre',
  --   'BufNewFile',
  -- },
  ft = { 'javascriptreact', 'typescriptreact', 'javascript', 'typescript' },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    -- trigger linting on buffer enter, right after writing to a buffer, and when leaving insert mode
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      -- could define a pattern to limit the linting to
      -- pattern = {'*.js', '*.ts'},
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>dl', function()
      lint.try_lint()
    end, { noremap = true, silent = true, desc = 'Document lint' })
  end,
}
