return {
  Lua = {
    workspace = { checkThirdParty = 'Disable' },
    telemetry = { enable = false },
    diagnostics = {
      globals = { 'vim', 'require' }
    },
    hint = { enable = true }
  },
}
