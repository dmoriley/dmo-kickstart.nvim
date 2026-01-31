return {
  -- commenting supported natively in neovim 0.10, but doesnt do block comments yet
  -- can probably remove when that is available
  'numToStr/Comment.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('Comment').setup()
    -- @see https://github.com/numToStr/Comment.nvim/issues/70
    vim.keymap.set('n', 'gC', function()
      local count = vim.v.count1
      local api = require('Comment.api')
      vim.api.nvim_feedkeys('V', 'n', false)
      if count > 1 then
        vim.api.nvim_feedkeys((count - 1) .. 'j', 'n', false)
      end
      vim.api.nvim_feedkeys('yP', 'nx', false)
      api.comment.linewise.count(count)
      vim.api.nvim_feedkeys('`<^i', 'n', false)
    end, { noremap = true, silent = true, desc = 'Duplicate and comment selected text' })
    vim.keymap.set(
      'x',
      'gC',
      'V<Esc>gvy`>pgv<Esc>`><cmd>lua require"Comment.api".comment.linewise("V")<CR><Down>^',
      { noremap = true, silent = true, desc = 'Duplicate and comment selected text' }
    )
  end,
}
