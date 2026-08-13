local M = {}
local mapper = require('david.core.utils').mapper_factory
local nnoremap = mapper('n')
local nvnoremap = mapper({ 'n', 'v' })

---@param bufnr integer
function M.toggle_inlay_hints(bufnr)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

  if not vim.lsp.inlay_hint then
    vim.notify('Inlay hints are not available in this Neovim version', vim.log.levels.WARN)
    return
  end

  local supports_inlay_hints = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      supports_inlay_hints = true
      break
    end
  end

  if not supports_inlay_hints then
    vim.notify('Inlay hints are not supported for this buffer', vim.log.levels.WARN)
    return
  end

  local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
  vim.notify((is_enabled and 'Disabled' or 'Enabled') .. ' inlay hints', vim.log.levels.INFO)
end

M.attach = function(args, opts)
  opts = opts or {}

  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  local bufnr = args.buf

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_buf_create_user_command(bufnr, 'LspCapabilities', function(_)
    print(vim.inspect(client.server_capabilities))
  end, { desc = 'Show lsp capabilities' })

  if opts.inlay_hints and opts.inlay_hints.enabled and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
    pcall(vim.lsp.codelens.enable, true, { bufnr = bufnr })
    nnoremap('<leader>cl', function()
      vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, { buffer = bufnr, desc = 'LSP: Toggle codelens' })
  end

  nvnoremap('<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'LSP: Code action' })
  nnoremap('<leader>ch', function()
    M.toggle_inlay_hints(bufnr)
  end, { buffer = bufnr, desc = 'LSP: Toggle inlay hints' })
  nnoremap('<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP: Rename' })
  nnoremap('gk', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' })
  nnoremap('gK', vim.lsp.buf.signature_help, { desc = 'LSP Signature Documentation' })
  nnoremap('gD', vim.lsp.buf.declaration, { desc = 'LSP: Go to declaration' })
  nnoremap('gI', vim.lsp.buf.implementation, { desc = 'LSP: Go to implementation' })
end

return M
