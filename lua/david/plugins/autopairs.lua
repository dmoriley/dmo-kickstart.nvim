return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require('nvim-autopairs').setup({
      check_ts = true, -- treesitter integration
      enable_check_bracket_line = true,
      fast_wrap = {
        map = 'å',
        highlight = 'PmenuSel',
        highlight_grey = 'LineNr',
      },
    })
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
