return {
  'folke/which-key.nvim',
  event = 'BufReadPre',
  config = function()
    local wk = require('which-key')
    wk.setup({})
    -- wk.register({
    --   -- ["1"] = "which_key_ignore",
    --   -- ["2"] = "which_key_ignore",
    --   -- ["3"] = "which_key_ignore",
    --   -- ["4"] = "which_key_ignore",
    --   -- ["5"] = "which_key_ignore",
    --   b = { name = '[B]uffer' },
    --   c = { name = '[C]ode', _ = 'which_key_ignore' },
    --   d = { name = '[D]ocument', _ = 'which_key_ignore' },
    --   g = { name = '[G]it', _ = 'which_key_ignore' },
    --   r = { name = '[R]ename', _ = 'which_key_ignore' },
    --   s = { name = '[S]earch', _ = 'which_key_ignore' },
    --   w = { name = '[W]orkspace', _ = 'which_key_ignore' },
    --   t = { name = '[T]rouble', _ = 'which_key_ignore' },
    -- }, { prefix = '<leader>' })

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
      { '<leader>t', group = '[T]rouble' },
      { '<leader>t_', hidden = true },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>w_', hidden = true },
    })

    -- wk.register({
    --   g = { '[G]it' },
    --   s = {
    --     name = '[S]earch',
    --     w = { '[W]orkspace' },
    --   },
    -- }, { mode = 'v', prefix = '<leader>' })

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
