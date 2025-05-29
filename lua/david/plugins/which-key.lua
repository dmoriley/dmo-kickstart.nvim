return {
  'folke/which-key.nvim',
  event = 'BufReadPre',
  config = function()
    local wk = require('which-key')
    wk.setup({
      preset = 'modern',
    })

    wk.add({
      { '<leader>b', group = '[B]uffer' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>c_', hidden = true },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>d_', hidden = true },
      { '<leader>g', group = '[G]it' },
      { '<leader>g_', hidden = true },
      { '<leader>r', group = '[R]ename' },
      { '<leader>r_', hidden = true },
      { '<leader>s', group = '[S]earch' },
      { '<leader>s_', hidden = true },
      { '<leader>s', group = '[F]ind' },
      { '<leader>t', group = '[T]rouble' },
      { '<leader>t_', hidden = true },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>w_', hidden = true },
    })
    -- visual mode keys
    wk.add({
      {
        mode = { 'v' },
        { '<leader>g', desc = '[G]it' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>sw', desc = '[W]orkspace' },
      },
    })
  end,
  opts = {},
}
