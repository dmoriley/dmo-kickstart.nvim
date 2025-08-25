return {
  'hrsh7th/nvim-cmp',
  version = false,
  event = 'InsertEnter',
  dependencies = {
    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      sources = cmp.config.sources({
        -- { name = 'snippets' }, -- nvim snippets
        { name = 'luasnip' }, -- nvim snippets
        { name = 'lazydev', group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
        { name = 'nvim_lsp' },
        { name = 'path' },
      }, {
        { name = 'buffer' },
      }),
      mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand({})
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),

        ['<C-n>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-p>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        -- manually trigger auto completion window
        ['<C-Space>'] = cmp.mapping.complete({}),
      }),
      performance = {
        debounce = 0, --default is 60
        throttle = 0, --default is 30
      },

      --[[ matching = {
        -- turn off fuzzy matching to increase performance
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = true,
        disallow_prefix_unmatching = true,
      }, ]]
    })
  end,
}
