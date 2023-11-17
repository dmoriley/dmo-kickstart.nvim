local M = {}

-- get language server settings
M.lua = require("david.plugins.lsp.settings.lua")
M.ts = require("david.plugins.lsp.settings.ts")
M.go = require("david.plugins.lsp.settings.go")
M.angular = require("david.plugins.lsp.settings.angular")

-- extend completion capabilities with cmp_nvim
M.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())


local keymap = vim.keymap.set;
local options = function(description)
  if description then
    return { noremap = true, silent = true, desc = "LSP: " .. description }
  end
  return { noremap = true, silent = true }
end

M.on_attach = function(client, bufnr)
  -- if client.name == 'tsserver' then
  --   client.server_capabilities.documentFormattingProvider = false
  -- end
  -- if client.name == 'lua_ls' then
  --   client.server_capabilities.documentFormattingProvider = false
  -- end


  keymap('n', '<leader>vrn', vim.lsp.buf.rename, options('[V]im [R]e[n]ame'))
  keymap('n', '<leader>vca', vim.lsp.buf.code_action, options('[V]im [C]ode [A]ction'))
  keymap('n', '<leader>vrr', vim.lsp.buf.references, options('[V]im refe[rr]ences in quickfix'))

  keymap('n', 'gr', require('telescope.builtin').lsp_references, options('[G]oto [R]eferences'))
  keymap('n', 'gd', require('telescope.builtin').lsp_definitions, options('[G]oto [D]efinition'))
  keymap('n', 'gtd', require('telescope.builtin').lsp_type_definitions, options('[G]oto [T]ype [D]efinition'))
  keymap('n', 'gI', require('telescope.builtin').lsp_implementations, options('[G]oto [I]mplementation'))
  keymap('n', 'gD', vim.lsp.buf.declaration, options('[G]oto [D]eclaration'))

  keymap('n', '<leader>k', vim.lsp.buf.hover, options('Hover Documentation'))
  keymap('n', '<leader>K', vim.lsp.buf.signature_help, options('Signature Documentation'))
  keymap('n', '<leader>sds', require('telescope.builtin').lsp_document_symbols, options('[S]earch [D]ocument [S]ymbols'))
  keymap('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, options('[S]earch [W]orkspace [S]ymbols'))
  keymap('n', '<leader>df', vim.lsp.buf.format, options('[D]ocument [F]ormat'));

  local trouble = require("trouble").toggle
  keymap('n', "<leader>tt", function() trouble() end, options("Toggle Trouble"))
  keymap('n', "<leader>tq", function() trouble("quickfix") end, options("Quickfix List"))
  keymap('n', "<leader>tr", function() trouble("lsp_references") end, options("References"))
  keymap('n', "<leader>tdd", function() trouble("document_diagnostics") end, options("[D]ocument [D]iagnostics"))
  keymap('n', "<leader>twd", function() trouble("workspace_diagnostics") end, options("Workspace Diagnostics"))

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- require("illuminate").on_attach(client)
end

return M;
