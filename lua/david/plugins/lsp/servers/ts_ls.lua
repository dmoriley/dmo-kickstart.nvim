local nnoremap = require('david.core.utils').mapper_factory('n')

local function organize_imports()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = '',
  }
  vim.lsp.buf.execute_command(params)
end

return {
  settings = {
    typescript = {
      -- https://code.visualstudio.com/docs/typescript/typescript-editing#_inlay-hints
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
      preferences = {
        -- Include the `type` keyword in auto-imports whenever possible.
        -- Requires using TypeScript 5.3+ in the workspace.
        preferTypeOnlyAutoImports = true,
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_user_command('TypescriptOrganizeImports', organize_imports, { nargs = 0, desc = 'Organize imports' })
    nnoremap('<localleader>oi', '<Cmd>TypescriptOrganizeImports<CR>', { buffer = bufnr, desc = 'LSP: Organize imports' })
  end,
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}
