return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    dashboard.section.header.val = {
      [[                                                 ]],
      [[                                                 ]],
      [[                                                 ]],
      [[                                                 ]],
      [[                                                 ]],
      [[ ███╗  ██╗███████╗ █████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗ ██║██╔════╝██╔══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗██║█████╗  ██║  ██║╚██╗ ██╔╝██║██╔████╔██║]],
      [[ ██║╚████║██╔══╝  ██║  ██║ ╚████╔╝ ██║██║╚██╔╝██║]],
      [[ ██║ ╚███║███████╗╚█████╔╝  ╚██╔╝  ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚══╝╚══════╝ ╚════╝    ╚═╝   ╚═╝╚═╝     ╚═╝]],
      [[                                                 ]],
      [[                                                 ]],
      [[                                                 ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('SPC f f', '  Find files', '<CMD>FzfLua files <CR>'),
      dashboard.button('SPC f o', '  Recently used files', '<CMD>FzfLua oldfiles <CR>'),
      dashboard.button('SPC s e', '  Find text', '<CMD>FzfLua live_grep <CR>'),
      dashboard.button('SPC e', '  File Explorer', '<CMD>lua require(\'mini.files\').open()<CR>'),
      dashboard.button('c', '  Configuration', '<CMD>cd $HOME/.config/nvim/ | lua require(\'fzf-lua\').files()<CR>'),
      dashboard.button('e', '  New file', '<CMD>ene <BAR> startinsert <CR>'),
      dashboard.button('p', '📁 Find Project', '<CMD>lua require(\'persistence\').select()<CR>'),
      dashboard.button('s', '  Current Directory Session', '<CMD>lua require(\'persistence\').load()<CR>'),
      dashboard.button('l', '⏪ Last Session', '<CMD>lua require(\'persistence\').load({ last = true })<CR>'),
      dashboard.button('q', '  Quit Neovim', '<CMD>qa<CR>'),
    }

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local version = vim.version()
        local nvim_version = 'v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
        
        dashboard.section.footer.val = {
          '⚡ Neovim ' .. nvim_version .. ' loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms ⚡',
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- dashboard.section.footer.opts.hl = 'Type'
    -- dashboard.section.header.opts.hl = 'Include'
    -- dashboard.section.buttons.opts.hl = 'Keyword'

    dashboard.opts.opts.noautocmd = true -- prevent keymaps aside from defined above in alpha menu
    alpha.setup(dashboard.opts)
  end,
}
