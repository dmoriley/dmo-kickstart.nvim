return {
    'folke/which-key.nvim',
    event = "BufReadPre",
    config = function()
        local wk = require("which-key")
        wk.setup({})
        wk.register({
            -- ["1"] = "which_key_ignore",
            -- ["2"] = "which_key_ignore",
            -- ["3"] = "which_key_ignore",
            -- ["4"] = "which_key_ignore",
           -- ["5"] = "which_key_ignore",
            b = { name = '[B]uffer'},
            c = { name = '[C]ode', _ = 'which_key_ignore' },
            d = { name = '[D]ocument', _ = 'which_key_ignore' },
            g = { name = '[G]it', _ = 'which_key_ignore' },
            r = { name = '[R]ename', _ = 'which_key_ignore' },
            s = { name = '[S]earch', _ = 'which_key_ignore' },
            w = { name = '[W]orkspace', _ = 'which_key_ignore' },
            t = { name = '[T]rouble', _ = 'which_key_ignore' },
        }, { prefix = "<leader>"})
    end,
    opts = {}
}
