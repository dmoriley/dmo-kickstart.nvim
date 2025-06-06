local M = {}

---@param kind string
function M.pick(kind)
  return function()
    local actions = require('CopilotChat.actions')
    local items = actions[kind .. '_actions']()
    if not items then
      print('No ' .. kind .. ' found on the current line')
      return
    end
    local ok = pcall(require, 'fzf-lua')
    require('CopilotChat.integrations.' .. (ok and 'fzflua' or 'telescope')).pick(items)
  end
end

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
    cmd = { 'CopilotChat', 'CopilotChatOpen', 'CopilotChatToggle' },
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Clear (CopilotChat)',
        mode = { 'n', 'v' },
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
              require('CopilotChat').ask(input, { selection = require('CopilotChat.select').visual })
            end
          end)
        end,
        desc = 'CopilotChat - Quick chat',
        mode = { 'n', 'v' },
      },
      -- Show help actions with telescope
      { '<leader>ah', M.pick('help'), desc = 'Diagnostic Help (CopilotChat)', mode = { 'n', 'v' } },
      -- Show prompts actions with telescope
      { '<leader>ap', M.pick('prompt'), desc = 'Prompt Actions (CopilotChat)', mode = { 'n', 'v' } },
    },
    opts = function()
      local user = vim.env.USER or 'User'
      return {
        -- default model ( default is gpt-4o)
        -- run :CopilotChatModels for available models
        model = 'gemini-2.0-flash-001',
        chat_autocomplete = true,
        auto_insert_mode = true,
        show_help = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require('CopilotChat.select')
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    config = function(_, opts)
      local chat = require('CopilotChat')
      -- when entering a chat buffer turn off all line numbering
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
}
