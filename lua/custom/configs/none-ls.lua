local none_ls = require("null-ls");
local augroup = vim.api.nvim_create_augroup("LspFormatting", {});

local opts = {
  sources = {
    none_ls.builtins.formatting.gofmt,
    none_ls.builtins.formatting.goimports,
    none_ls.builtins.formatting.golines,
  },
  on_attach = function(client, bufnr)
    -- check if document supports formatting first
    if client.supports_method("textDocument/formatting") then
      -- clear existing autocommand for LspFormatting
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr
      })
      -- apply auto group to saving/pre-writing and call lsp.buf.format
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({bufnr = bufnr})
        end
      })
    end
  end
}
return opts;
