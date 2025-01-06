local nnoremap = require('david.core.utils').mapper_factory('n')
--
-- :VtsExec {command}
-- :VtsRename {from} {to}
--
return {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      preferences = {
        -- Include the `type` keyword in auto-imports whenever possible.
        -- Requires using TypeScript 5.3+ in the workspace.
        preferTypeOnlyAutoImports = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  on_attach = function(_, bufnr)
    local vtsls = require('vtsls')

    vim.api.nvim_create_user_command('TypescriptSelectWorkspaceVersion', function()
      local params = {
        command = 'typescript.selectTypeScriptVersion',
        -- arguments = { vim.api.nvim_buf_get_name(0) },
        title = 'Select TS workspace version',
      }
      vim.lsp.buf.execute_command(params)
    end, { nargs = 0, desc = 'Select TS workspace version' })

    vim.api.nvim_create_user_command('TypescriptRestartServer', function()
      vtsls.commands.restart_tsserver()
    end, { nargs = 0, desc = 'Select TS workspace version' })

    nnoremap('<localleader>co', function()
      vtsls.commands.organize_imports()
    end, { desc = 'LSP: Organize imports' })

    nnoremap('<localleader>cm', function()
      vtsls.commands.add_missing_imports()
    end, { desc = 'LSP: add missing imports' })
  end,
}
