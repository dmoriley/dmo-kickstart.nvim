return {
  'hrsh7th/nvim-cmp',
  version = false,
  event = 'InsertEnter',
  dependencies = {
    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
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
        -- jump forward placeholder in snippet
        ['<C-l>'] = cmp.mapping(function()
          --check if can jump forward first
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          end
        end, { 'i', 's' }),
        -- jump backwards placeholder in snippet
        ['<C-h>'] = cmp.mapping(function()
          --check if can jump backwards first
          if vim.snippet.active({ direction = -1 }) then
            vim.snippet.jump(-1)
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'snippets' }, -- nvim snippets
        { name = 'nvim_lsp' },
        { name = 'path' },
      }, {
        { name = 'buffer' },
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
