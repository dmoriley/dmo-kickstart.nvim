return {
  'mbbill/undotree',
  keys = {
    { '<leader>u', '<CMD>UndotreeToggle<cr>', mode = 'n', desc = 'Undotree toggle', noremap = true, silent = true },
  },
  cmd = { 'UndotreeToggle', 'UndotreeShow' },
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_WindowLayout = 2
  end,
}
