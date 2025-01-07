return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = 'Disable' },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim', 'require' },
        disable = { 'missing-fields' },
      },
      -- inlay hints
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = 'Disable',
        semicolon = 'Disable',
        arrayIndex = 'Disable',
      },
      -- codeLens = {
      --   enable = true,
      -- },
    },
  },
  -- filetypes = {},
  -- on_attach = function ()
  -- end
}
