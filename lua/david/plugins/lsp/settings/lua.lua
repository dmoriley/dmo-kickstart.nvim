return {
  Lua = {
    workspace = { checkThirdParty = 'Disable' },
    telemetry = { enable = false },
    diagnostics = {
      globals = { 'vim', 'require' }
      -- disable = { 'missing-fields' } ignore missing fields warnings
    },
    hint = { enable = true }
  },
}
