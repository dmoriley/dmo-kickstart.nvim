return {
  'tpope/vim-fugitive',
  cmd = { 'G', 'Git' },
  keys = {
    {
      '<leader>gg',
      function()
        if vim.bo.filetype == 'fugitive' then
          vim.cmd('tabclose')
          return
        end

        vim.cmd('tab Git')
      end,
      mode = 'n',
      desc = 'Toggle Git Fugitive tab',
      noremap = true,
      silent = true,
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'fugitive',
      callback = function(event)
        vim.keymap.set('n', 'q', '<cmd>close<cr>', {
          buffer = event.buf,
          desc = 'Close Fugitive',
          silent = true,
        })

        for _, mode in ipairs({ 'n', 'x', 'o' }) do
          -- Fugitive exposes its original actions through <Plug> mappings. remap = true expands those
          -- mappings, allowing gu and gU to invoke each other's actions instead of literal key input.
          vim.keymap.set(mode, 'gu', '<Plug>fugitive:gU', { buffer = event.buf, remap = true }) -- jump to Unstaged files
          vim.keymap.set(mode, 'gU', '<Plug>fugitive:gu', { buffer = event.buf, remap = true }) -- jump to Untracked files
        end
      end,
    })
  end,
}
