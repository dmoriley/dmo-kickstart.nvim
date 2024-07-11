return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      debounce = 100,
      suggestion = {
        keymap = {
          accept = '<C-Enter>',
          next = '<C-j>',
          prev = '<C-k>',
          dismiss = '<C-c>',
        },
      },
      filetypes = {
        markdown = true,
      },
    })
  end,
}
