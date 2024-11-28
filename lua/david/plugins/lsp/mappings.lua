local M = {}
local mapper = require('david.core.utils').mapper_factory
local nnoremap = mapper('n')
local nvnoremap = mapper({ 'n', 'v' })

M.attach = function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  local bufnr = args.buf

  nvnoremap('<localleader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'LSP: Code action' })
  nnoremap('<localleader>rn', vim.lsp.buf.rename, { desc = 'LSP: Rename' })
  nnoremap('<localleader>rr', vim.lsp.buf.references, { desc = 'LSP: List references in quickfix' })
  nnoremap('<localleader>k', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' })
  nnoremap('<localleader>K', vim.lsp.buf.signature_help, { desc = 'LSP Signature Documentation' })
  nnoremap('gD', vim.lsp.buf.declaration, { desc = 'LSP: Go to declaration' })
  nnoremap('gI', vim.lsp.buf.implementation, { desc = 'LSP: Go to implementation' })

  if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    nnoremap('<localleader>th', function()
      local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not is_enabled)
      vim.notify((is_enabled and 'Disabled' or 'Enabled') .. ' inlay hint', vim.log.levels.INFO)
    end, { desc = 'LSP: Toggle inlay hints' })
  end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_buf_create_user_command(bufnr, 'LspCapabilities', function(_)
    print(vim.inspect(vim.lsp.get_clients()[1].server_capabilities))
  end, { desc = 'Show lsp capabilities' })
end

return M
