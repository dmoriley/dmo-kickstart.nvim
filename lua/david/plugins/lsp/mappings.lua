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

-- When several clients answer the same request (e.g. vtsls + angularls), prefer these.
-- angularls goes first since it also understands template usages.
local client_priority = { 'angularls' }

---@param clients vim.lsp.Client[]
local function sort_by_priority(clients)
  local function rank(client)
    for i, name in ipairs(client_priority) do
      if client.name == name then
        return i
      end
    end
    return #client_priority + 1
  end
  table.sort(clients, function(a, b)
    return rank(a) < rank(b)
  end)
  return clients
end

--- vim.lsp.buf.rename prompts and renames once per client, so with vtsls + angularls
--- attached you get asked twice. Pick the first client (by priority) that can rename
--- the symbol under the cursor and only rename with that one.
function M.rename()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = sort_by_priority(vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/rename' }))

  for _, client in ipairs(clients) do
    if not client:supports_method('textDocument/prepareRename') then
      return vim.lsp.buf.rename(nil, { name = client.name })
    end
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    local res = client:request_sync('textDocument/prepareRename', params, 1000, bufnr)
    if res and not res.err and res.result then
      return vim.lsp.buf.rename(nil, { name = client.name })
    end
  end

  -- nothing claimed the symbol; let the default report why
  vim.lsp.buf.rename()
end

--- vim.lsp.buf.hover stacks every client's response in one float. Show only the
--- response from the highest priority client that has something to say.
function M.hover()
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local clients = sort_by_priority(vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/hover' }))
  if #clients == 0 then
    return vim.notify('No information available', vim.log.levels.INFO)
  end

  vim.lsp.buf_request_all(bufnr, 'textDocument/hover', function(client)
    return vim.lsp.util.make_position_params(win, client.offset_encoding)
  end, function(results)
    if vim.api.nvim_get_current_win() ~= win or vim.api.nvim_get_current_buf() ~= bufnr then
      return -- cursor moved on while waiting
    end
    for _, client in ipairs(clients) do
      local resp = results[client.id]
      local result = resp and not resp.err and resp.result
      if result and result.contents then
        local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        if not vim.tbl_isempty(vim.tbl_filter(function(l)
          return l:match('%S')
        end, lines)) then
          vim.lsp.util.open_floating_preview(lines, 'markdown', { focus_id = 'textDocument/hover' })
          return
        end
      end
    end
    vim.notify('No information available', vim.log.levels.INFO)
  end)
end

--- Both clients can offer the same action (e.g. the same import fix); keep the first of each.
function M.code_action()
  local seen = {}
  vim.lsp.buf.code_action({
    filter = function(action)
      local key = (action.kind or '') .. '|' .. action.title
      if seen[key] then
        return false
      end
      seen[key] = true
      return true
    end,
  })
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

  nvnoremap('<leader>ca', M.code_action, { buffer = bufnr, desc = 'LSP: Code action' })
  nnoremap('<leader>ch', function()
    M.toggle_inlay_hints(bufnr)
  end, { buffer = bufnr, desc = 'LSP: Toggle inlay hints' })
  nnoremap('<leader>cr', M.rename, { buffer = bufnr, desc = 'LSP: Rename' })
  nnoremap('gk', M.hover, { desc = 'LSP: Hover Documentation' })
  nnoremap('gK', vim.lsp.buf.signature_help, { desc = 'LSP Signature Documentation' })
  nnoremap('gD', vim.lsp.buf.declaration, { desc = 'LSP: Go to declaration' })
  nnoremap('gI', vim.lsp.buf.implementation, { desc = 'LSP: Go to implementation' })
end

return M
