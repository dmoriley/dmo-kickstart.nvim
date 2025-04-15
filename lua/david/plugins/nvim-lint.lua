return {
  'mfussenegger/nvim-lint',
  -- event = {
  --   'BufReadPre',
  --   'BufNewFile',
  -- },
  -- ft = { 'javascriptreact', 'typescriptreact', 'javascript', 'typescript' },
  keys = {
    {
      '<leader>l',
      function()
        require('lint').try_lint()
      end,
      mode = 'n',
      desc = 'Document lint',
      noremap = true,
      silent = true,
    },
  },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    local eslint_d = require('lint').linters.eslint_d
    eslint_d.args = {
      -- '--no-eslintrc',
      -- '--config',
      -- './eslintrc' -- path to global config
      '--format',
      'json',
      '--stdin',
      '--stdin-filename',
      function()
        return vim.api.nvim_buf_get_name(0)
      end,
    }

    -- local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    -- trigger linting on buffer enter, right after writing to a buffer, and when leaving insert mode
    -- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    --   -- could define a pattern to limit the linting to
    --   pattern = { '*.js', '*.ts', '*.tsx', '*.jsx' },
    --   group = lint_augroup,
    --   callback = function()
    --     lint.try_lint()
    --   end,
    -- })

    -- print out running linters
    vim.api.nvim_create_user_command('PrintLintersInfo', function()
      local linters = require('lint').get_running()
      if #linters == 0 then
        return '󰦕'
      end
      -- using input to display message to pause so that the message can be read
      vim.fn.input({ prompt = 'Linters currently running\n󱉶 ' .. table.concat(linters, ', ') })
    end, { nargs = 0 })
  end,
}
