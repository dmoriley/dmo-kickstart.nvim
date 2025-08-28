return {
  'L3MON4D3/LuaSnip',
  -- follow latest release.
  version = 'v2.*',
  -- install jsregexp (optional!).
  build = 'make install_jsregexp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  opts = {
    history = true,
    delete_check_events = 'TextChanged',
  },
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load({
      paths = {
        vim.fn.stdpath('config') .. '/snippets', -- global custom snippets located ~/.config/snippets
        vim.fn.getcwd() .. '/.vscode', -- project snippets in the  current_working_dir/.vscode
        vim.fn.getcwd() .. '/.snippets', -- project snippets in the  current_working_dir/.vscode
      },
    })
    local luasnip = require('luasnip')
    luasnip.filetype_extend('lua', { 'luadoc' })
    luasnip.filetype_extend('typescript', { 'tsdoc', 'javascript' })
    luasnip.filetype_extend('javascript', { 'jsdoc' })
  end,
}
