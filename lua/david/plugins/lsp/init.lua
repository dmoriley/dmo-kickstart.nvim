local env = require('david.core.env')

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
      {
        'yioneko/nvim-vtsls',
        ft = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        enabled = not env.NVIM_USER_USE_TS_LS,
      },
      'RRethy/vim-illuminate', -- highlighting and cursor over after delay
    },
    event = 'BufReadPre',
    opts = {
      inlay_hints = {
        enable = true,
      },
      -- document_highlight = {
      --   enable = true,
      -- },
    },
    -- opts = function()
    --   ---@class PluginLspOpts
    --   local ret = {
    --     inlay_hints = {
    --       enabled = true,
    --     },
    --   }
    --   return ret
    -- end,
    config = require('david.plugins.lsp.config'),
  },
  {
    'dmmulroy/tsc.nvim',
    cmd = { 'TSC' },
    config = true,
  },
}
