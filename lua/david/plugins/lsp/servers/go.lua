-- Go-specific LSP configuration.
--
-- This file is intentionally focused on the parts of `gopls` that shape the
-- day-to-day editing experience: diagnostics, inlay hints, code lenses, and
-- semantic highlighting.
return {
  settings = {
    gopls = {
      -- Keep formatting in conform.nvim so `gopls` does not compete with
      -- `goimports` and `gofumpt` on save.
      gofumpt = false,

      -- Suggest completions from packages that have not been imported yet.
      completeUnimported = true,

      -- Fill function and method completions with placeholder arguments so they
      -- are easier to tab through and edit.
      usePlaceholders = true,

      -- Enable the full Staticcheck analyzer suite inside `gopls` diagnostics.
      staticcheck = true,

      -- Skip directories that are irrelevant to Go analysis or are expensive to
      -- scan in mixed-language repos.
      directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-**/node_modules' },

      -- Ask `gopls` to serve semantic tokens when the server version supports
      -- them fully. Neovim needs the server's own legend to decode tokens, so
      -- we intentionally do not synthesize this capability on the client side.
      semanticTokens = true,

      analyses = {
        -- Warn about values that may be nil when dereferenced.
        -- fieldalignment = true,
        nilness = true,

        -- Warn when parameters are accepted but never used.
        unusedparams = true,

        -- Warn when writes can never be observed.
        unusedwrite = true,

        -- Prefer `any` where it improves clarity over `interface{}`.
        useany = true,
      },

      hints = {
        -- Show the inferred type for `:=` assignments.
        assignVariableTypes = true,

        -- Show field names inside composite literals.
        compositeLiteralFields = true,

        -- Show the concrete type used in composite literals.
        compositeLiteralTypes = true,

        -- Inline constant values at their use sites.
        constantValues = true,

        -- Show inferred type parameters for generic function calls.
        functionTypeParameters = true,

        -- Show parameter names at call sites.
        parameterNames = true,

        -- Show the inferred type of range variables.
        rangeVariableTypes = true,
      },

      codelenses = {
        -- Keep compiler optimization details off by default; they are useful but
        -- noisy outside of focused performance work.
        gc_details = false,

        -- Offer `go generate` lenses when generators are present.
        generate = true,

        -- Offer a regenerate cgo lens for cgo-enabled packages.
        regenerate_cgo = true,

        -- Offer module vulnerability scans from the editor.
        run_govulncheck = true,

        -- Offer test-running lenses above test functions and packages.
        test = true,

        -- Offer `go mod tidy` when module metadata drifts.
        tidy = true,

        -- Offer dependency upgrade lenses in `go.mod` files.
        upgrade_dependency = true,

        -- Offer `go mod vendor` for projects that vendor dependencies.
        vendor = true,
      },
    },
  },
  on_attach = function(client, _)
    -- A malformed semantic token provider can crash Neovim's decoder while you
    -- type, so disable it unless the server advertises a usable legend.
    local semantic_provider = client.server_capabilities.semanticTokensProvider
    if not semantic_provider then
      return
    end

    local legend = semantic_provider.legend
    if legend and vim.islist(legend.tokenTypes) and vim.islist(legend.tokenModifiers) then
      return
    end

    client.server_capabilities.semanticTokensProvider = nil
  end,
}
