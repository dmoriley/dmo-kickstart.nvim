return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = 'Disable' },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim', 'require' },
        disable = { 'missing-fields' },
      },
      hint = { enable = true }
    },
  }
}
