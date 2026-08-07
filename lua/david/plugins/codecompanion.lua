-- Configure CodeCompanion to use the Claude Code adapter for chat and inline interactions.
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'franco-ruggeri/codecompanion-spinner.nvim',
  },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = 'n', desc = 'Open AI Actions (CC)', silent = true },
    { '<leader>ac', '<cmd>CodeCompanionChat<cr>', mode = 'n', desc = 'Open New AI Chat (CC)', silent = true },
    { '<leader>af', '<cmd>CodeCompanionChat Toggle<cr>', mode = 'n', desc = 'Toggle Open AI Chat (CC)', silent = true },
    {
      '<leader>af',
      function()
        -- Open chat if it doesn't exist, then focus it
        local ok = pcall(vim.cmd, 'CodeCompanionChat toggle')

        if not ok then
          print('Chat not toggled')
        end

        -- marks will persist after existing visual mode
        vim.api.nvim_input('<Esc>')

        -- Send the visual selection (works whether chat exists or not)
        vim.cmd("'<,'>CodeCompanionChat Add")

        -- Only jump to end if we're inside the chat buffer
        local chat_bufname = vim.fn.bufname()
        if chat_bufname:match('codecompanion') then
          vim.cmd('normal! Gzz')
        end
      end,
      mode = 'v',
      desc = 'Add Selection to AI Chat (CC)',
      silent = true,
    },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = 'n', desc = 'Inline AI Request (CC)', silent = true },
    { '<leader>ai', "<cmd>'<,'>CodeCompanion<cr>", mode = 'v', desc = 'Inline AI Request (CC)', silent = true },
  },
  opts = {
    extensions = {
      spinner = {},
    },
    display = {
      chat = {
        show_settings = false,
        -- Required for CodeCompanionChatHeader to be applied at all: the header
        -- extmark is only set when this is on (see colors.lua for the colours).
        show_header_separator = true,
      },
    },
    adapters = {
      acp = {
        extend = {
          claude_code = {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = 'CLAUDE_CODE_OAUTH_TOKEN',
            },
          },
        },
      },
      http = {
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            env = {
              url = 'https://ollama.com',
              api_key = 'OLLAMA_API_KEY',
            },
            headers = {
              ['Content-Type'] = 'application/json',
              ['Authorization'] = 'Bearer ${api_key}',
            },
            schema = {
              model = {
                -- Free models I found that worked
                -- default = 'gemma4:31b',
                -- default = 'nemotron-3-ultra'
                default = 'minimax-m3',
              },
            },
            -- handlers = {
            --   -- The built-in ollama adapter indexes `json.message` without checking it
            --   -- exists, so any error body (401, unknown model, ...) throws a Lua error
            --   -- instead of surfacing the message. Surface it instead.
            --   inline_output = function(self, data, context)
            --     if not data or data == '' then
            --       return
            --     end
            --
            --     local ok, json = pcall(vim.json.decode, data.body, { luanil = { object = true } })
            --     if not ok then
            --       return { status = 'error', output = data.body }
            --     end
            --
            --     if json.error then
            --       local err = json.error
            --       return {
            --         status = 'error',
            --         output = type(err) == 'string' and err or vim.inspect(err),
            --       }
            --     end
            --
            --     if json.message and json.message.content then
            --       return { status = 'success', output = json.message.content }
            --     end
            --
            --     return { status = 'error', output = data.body }
            --   end,
            -- },
          })
        end,
      },
    },
    interactions = {
      background = {
        adapter = 'claude_code',
        model = 'haiku',
      },
      chat = {
        adapter = 'ollama',
        roles = {
          ---The header name for the LLM's messages
          ---@type string|fun(adapter: CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter): string
          llm = function(adapter)
            return '  ' .. adapter.model.name .. ' (' .. adapter.formatted_name .. ')'
          end,

          ---The header name for your messages
          ---@type string
          user = ' Me',
        },
        keymaps = {
          close2 = {
            modes = {
              n = '<C-d>',
              i = '<C-d>',
            },
            index = 23,
            callback = 'keymaps.close',
            description = 'Close the chat buffer',
          },
        },
      },
      -- only http adapters work for inline
      inline = {
        adapter = 'ollama',
      },
    },
  },
}
