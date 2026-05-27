-- Go-specific LSP configuration.
--
-- This file is intentionally focused on the parts of `gopls` that shape the
-- day-to-day editing experience: diagnostics, inlay hints, code lenses, and a
-- small semantic token compatibility shim for older `gopls` behavior.
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

      -- Ask `gopls` to serve semantic tokens. The `on_attach` block below fills
      -- in the advertised capability when older versions omit it.
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
    -- Some `gopls` versions accept semantic token requests but do not advertise
    -- the provider during initialization. Reuse the client's declared legend so
    -- Neovim can enable semantic highlighting consistently.
    if client.server_capabilities.semanticTokensProvider then
      return
    end

    local text_document = client.config.capabilities.textDocument
    local semantic = text_document and text_document.semanticTokens
    if not semantic then
      return
    end

    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
      range = true,
    }
  end,
}
