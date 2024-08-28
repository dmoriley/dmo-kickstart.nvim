-- Allow vscode style snippets to be used with native neovim snippets vim.snippet
return {
  'garymjr/nvim-snippets',
  opts = {
    create_cmp_source = true, -- create a source called 'snippets' for nvim cmp
    friendly_snippets = true,
    extended_filetypes = {
      typescript = { 'javascript' },
      typescriptreact = { 'javascript' },
      javascriptreact = { 'javascript' },
    },
  },
  dependencies = { 'rafamadriz/friendly-snippets' },
}
