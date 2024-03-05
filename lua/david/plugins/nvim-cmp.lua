return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'BufReadPre',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        local luasnip = require('luasnip')

        luasnip.filetype_extend('typescript', { 'javascript' })
        luasnip.filetype_extend('typescriptreact', { 'javascript' })
      end,
    },
    'saadparwaiz1/cmp_luasnip',
    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    require('luasnip/loaders/from_vscode').lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-y>'] = cmp.mapping.confirm({
          select = true,
          -- behavior = cmp.ConfirmBehavior.Replace,
        }),
        -- manually trigger auto completion window
        ['<C-Space>'] = cmp.mapping.complete({}),
        -- ['<CR>'] = cmp.mapping.confirm {
        --     behavior = cmp.ConfirmBehavior.Replace,
        --     select = true,
        -- },
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      }),
      sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
      },
    })
  end,
}
