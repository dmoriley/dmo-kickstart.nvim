return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        dependencies = {
          'williamboman/mason-lspconfig.nvim',
        },
        build = ':MasonUpdate',
        config = function()
          require('mason').setup({
            ui = {
              border = 'rounded',
              icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗',
              },
            },
          })

          local servers = require('david.plugins.lsp.servers')
          local serverToPackageNameMap = require('mason-lspconfig.mappings.server').lspconfig_to_package
          local packagesToInstall = vim.tbl_extend('force', servers.formatters, {})

          for lspName, _ in pairs(servers.servers) do
            table.insert(packagesToInstall, serverToPackageNameMap[lspName])
          end

          vim.api.nvim_create_user_command('MasonInstallAll', function()
            vim.cmd('MasonInstall ' .. table.concat(packagesToInstall, ' '))
          end, {})
        end,
      },
      'RRethy/vim-illuminate', -- highlighting and cursor over after delay
    },
    event = 'BufReadPre',
    -- opts = {
    --   inlay_hints = {
    --     enable = true,
    --   },
    --   document_highlight = {
    --     enable = true,
    --   },
    -- },
    config = require('david.plugins.lsp.config'),
  },
  -- not apart of lsp config, but tsc is a part of language server stuff, so putting in the same file
  {
    'dmmulroy/tsc.nvim',
    cmd = { 'TSC' },
    config = true,
  },
}
