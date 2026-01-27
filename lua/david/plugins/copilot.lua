local M = {}

-- ---@param kind string
-- function M.pick(kind)
--   return function()
--     local actions = require('CopilotChat.actions')
--     local items = actions[kind .. '_actions']()
--     if not items then
--       print('No ' .. kind .. ' found on the current line')
--       return
--     end
--     local ok = pcall(require, 'fzf-lua')
--     require('CopilotChat.integrations.' .. (ok and 'fzflua' or 'telescope')).pick(items)
--   end
-- end

return {
  {
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
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    cmd = { 'CopilotChat', 'CopilotChatOpen', 'CopilotChatToggle', 'CopilotChatModels' },
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'x' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Clear (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>aq',
        function()
          -- local ok, input = pcall(vim.fn.input('Quick Chat: '))
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input and input ~= '' then
              -- if something is selected in visual will use that as context
              require('CopilotChat').ask(input, { resources = 'selection' })
            end
          end)
        end,
        desc = 'CopilotChat - Quick chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ap',
        function()
          return require('CopilotChat').select_prompt({})
        end,
        desc = 'Prompt Actions (CopilotChat)',
        mode = { 'n', 'v' },
      },
    },
    opts = function()
      local user = vim.env.USER or 'User'
      return {
        -- Included/Default  models are: GPT-4.1 and GPT 4.o
        -- run :CopilotChatModels for available models
        -- gpt-4.1
        -- gpt-5.1
        -- gpt-5
        -- gemini-2.5-pro
        model = 'claude-sonnet-4.5',
        temperature = 0.1, -- Lower = focused, higher = creative
        chat_autocomplete = true,
        auto_insert_mode = true,
        show_help = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        -- window = {
        --   width = 0.8,
        --   height = 0.8,
        --   -- width = 80, -- Fixed width in columns
        --   -- height = 20, -- Fixed height in rows
        --   layout = 'float', --vertical, horizontal, float
        --   border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        --   title = '🤖 Copilot Chat',
        --   zindex = 100, -- Ensure window stays on top
        -- },
        headers = {
          user = '👨‍💻 You',
          assistant = '💻 Copilot',
          tool = '🔧 Tool',
        },
        separator = '━━',
        -- auto_fold = true, -- Automatically folds non-assistant messages
        selection = function(source)
          local select = require('CopilotChat.select')
          return select.get(source)
          -- return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    config = function(_, opts)
      local chat = require('CopilotChat')
      -- when entering a chat buffer turn off all line numbering
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })

      chat.setup(opts)
      vim.api.nvim_set_hl(0, 'CopilotChatPrompt', { fg = '#76B947', bold = true })
      vim.api.nvim_set_hl(0, 'CopilotChatSeparator', { fg = '#7199EE' })
      vim.api.nvim_set_hl(0, 'CopilotChatHelp', { fg = '#494F56' })
    end,
  },
}
