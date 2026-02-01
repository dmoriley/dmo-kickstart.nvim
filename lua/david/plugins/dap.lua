local nnoremap = require('david.core.utils').mapper_factory('n')

---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == 'table' and table.concat(args, ' ') or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input('Run with args: ', args_str)) --[[@as string]]
    if config.type and config.type == 'java' then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require('dap.utils').splitstr(new_args)
  end
  return config
end

return {
  {
    'mfussenegger/nvim-dap',
    recommended = true,
    desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text', -- virtual text for the debugger
      'leoluz/nvim-dap-go',
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'mason.nvim',
        cmd = { 'DapInstall', 'DapUninstall' },
        opts = {
          ensure_installed = {
            'delve', -- go debugger
          },
        },
      },
    },
    keys = {
      {
        '<F8>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Run/Continue',
      },
      {
        '<F9>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F7>',
        function()
          require('dap').step_back()
        end,
        desc = 'Debug: Step Back',
      },
      {
        '<F10>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<F11>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<localleader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<localleader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end,
        desc = 'Debug: Breakpoint Condition',
      },
      {
        '<localleader>da',
        function()
          require('dap').continue({ before = get_args })
        end,
        desc = 'Debug: Run with Args',
      },
      {
        '<localleader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Debug: Run to Cursor',
      },
      {
        '<localleader>dt',
        function()
          require('dap').terminate()
        end,
        desc = 'Debug: Terminate',
      },
      {
        '<localleader>dP',
        function()
          require('dap').pause()
        end,
        desc = 'Debug: Pause',
      },
      {
        '<localleader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = 'Debug: Toggle REPL',
      },
      {
        '<localleader>dR',
        function()
          require('dap').restart()
        end,
        desc = 'Debug: Restart',
      },
      {
        '<localleader>dw',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'Debug: Widgets',
      },
      -- keymaps preserved for possible future use
      -- {
      --   '<localleader>dg',
      --   function()
      --     require('dap').goto_()
      --   end,
      --   desc = 'Go to Line (No Execute)',
      -- },
      -- {
      --   '<localleader>dj',
      --   function()
      --     require('dap').down()
      --   end,
      --   desc = 'Down',
      -- },
      -- {
      --   '<localleader>dk',
      --   function()
      --     require('dap').up()
      --   end,
      --   desc = 'Up',
      -- },
      -- {
      --   '<localleader>dl',
      --   function()
      --     require('dap').run_last()
      --   end,
      --   desc = 'Run Last',
      -- },
      -- {
      --   '<localleader>ds',
      --   function()
      --     require('dap').session()
      --   end,
      --   desc = 'Session',
      -- },
      -- {
      --   '<localleader>dus',
      --   function()
      --     local widgets = require('dap.ui.widgets')
      --     local sidebar = widgets.sidebar(widgets.scopes)
      --     sidebar.open()
      --   end,
      --   desc = 'Widgets',
      -- },
    },
    config = function()
      local dap = require('dap')
      local ui = require('dapui')

      ui.setup()
      require('nvim-dap-virtual-text').setup({})

      nnoremap('<localleader>du', ui.toggle, { desc = 'Debug: UI Toggle' })
      nnoremap('<localleader>de', ui.eval, { desc = 'Debug: Dap Eval' })

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      -- `DapBreakpoint` for breakpoints (default: `B`)
      -- `DapBreakpointCondition` for conditional breakpoints (default: `C`)
      -- `DapLogPoint` for log points (default: `L`)
      -- `DapStopped` to indicate where the debugee is stopped (default: `→`)
      -- `DapBreakpointRejected` to indicate breakpoints rejected by the debug adapter (default: `R`)
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🟠', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '🚫', texthl = '', linehl = '', numhl = '' })

      -- automatically open dapui when debugging
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      -- GO
      --[[ if not dap.adapters.go then
        local function get_unused_port()
          local server = vim.uv.new_tcp()
          assert(server:bind('127.0.0.1', 0)) -- OS allocates an unused port
          local tcp_t = server:getsockname()
          server:close()
          assert(tcp_t and tcp_t.port > 0, 'Failed to get an unused port')
          return tcp_t.port
        end

        dap.adapters.go = function(callback, config)
          local port = config.port or get_unused_port()
          local term_buf = vim.api.nvim_create_buf(false, true)
          local winnr = vim.api.nvim_open_win(term_buf, false, { split = 'below' })
          local current_winnr = vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(winnr)
          vim.fn.jobstart({ 'dlv', 'dap', '-l', '127.0.0.1:' .. port }, { term = true, buffer = term_buf })
          vim.api.nvim_set_current_win(current_winnr)
          vim.defer_fn(function()
            callback({ type = 'server', host = '127.0.0.1', port = port })
          end, 100)
        end

        local dlvToolPath = vim.fn.exepath('dlv')
        dap.configurations.go = {
          {
            type = 'go',
            name = 'Debug main.go',
            request = 'launch',
            showLog = true,
            program = '${workspaceFolder}/main.go',
            dlvToolPath = dlvToolPath,
            port = 11111,
          },
          {
            type = 'go',
            name = 'Debug',
            request = 'launch',
            program = '${file}',
          },
        }
      end ]]
    end,
  },
  {
    'leoluz/nvim-dap-go',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    ft = 'go',
    config = function(_, opts)
      require('dap-go').setup(opts)

      nnoremap('<localleader>dgt', function()
        require('dap-go').debug_test()
      end, { desc = 'Debug: go test' })

      nnoremap('<localleader>dgl', function()
        require('dap-go').debug_last_test()
      end, { desc = 'Debug: last go test' })
    end,
  },
}
