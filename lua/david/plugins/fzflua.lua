local mapper = require('david.core.utils').mapper_factory
local nnoremap = mapper('n')
local xnoremap = mapper('x')

return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local fzflua = require('fzf-lua')
    fzflua.setup({
      files = {
        formatter = 'path.filename_first',
      },
      oldfiles = {
        include_current_session = true,
      },
      keymaps = {
        show_details = false,
      },
      previewers = {
        builtin = {
          -- don't add syntax highlighting for files larger than below
          syntax_limit_b = 1024 * 200, -- 200KB
        },
      },
    })

    -- global
    nnoremap('<leader><space>', fzflua.global, { desc = 'FzfLua global' })

    -- find
    nnoremap('<leader>ff', fzflua.files, { desc = 'Find files' })
    nnoremap('<leader>fr', fzflua.oldfiles, { desc = 'Find recent files' })

    -- search
    nnoremap('<leader>,', fzflua.buffers, { desc = 'Search open buffers' })
    nnoremap('<leader>/', fzflua.lgrep_curbuf, { desc = 'Live grep current buffer' })
    nnoremap('<leader>sg', fzflua.live_grep_native, { desc = 'Live grep project' })
    nnoremap('<leader>sG', fzflua.grep, { desc = 'Grep project' })
    nnoremap('<leader>sl', fzflua.blines, { desc = 'Search current buffer lines' })
    nnoremap('<leader>sh', fzflua.helptags, { desc = 'Search Help' })
    nnoremap('<leader>sr', fzflua.resume, { desc = 'Search Resume' })
    nnoremap('<leader>sz', fzflua.builtin, { desc = 'Search FzfLua builtin' })
    nnoremap('<leader>sk', fzflua.keymaps, { desc = 'Search Keymaps' })
    nnoremap('<leader>sc', fzflua.commands, { desc = 'Search commands' })
    nnoremap('<leader>sm', fzflua.marks, { desc = 'Search marks' })
    nnoremap('<leader>sw', fzflua.grep_cword, { desc = 'Search word under cursor' })
    xnoremap('<leader>sv', fzflua.grep_visual, { desc = 'Search visual selection' })

    -- git
    nnoremap('<leader>fg', fzflua.git_files, { desc = 'Find git files' })
    nnoremap('<leader>gs', fzflua.git_status, { desc = 'Git status' })
    nnoremap('<leader>gl', fzflua.git_bcommits, { desc = 'Git log buffer' })
    nnoremap('<leader>gL', fzflua.git_commits, { desc = 'Git log workspace' })
    nnoremap('<leader>gB', fzflua.git_branches, { desc = 'Git branches' })

    -- lsp/dianostics
    nnoremap('<leader>sd', fzflua.diagnostics_document, { desc = 'Search Document Diagnostics' })
    nnoremap('<leader>sD', fzflua.diagnostics_workspace, { desc = 'Search Workspace Diagnostics' })
    nnoremap('<leader>ss', fzflua.lsp_document_symbols, { desc = 'Search document symbols' })
    nnoremap('<leader>sS', fzflua.lsp_workspace_symbols, { desc = 'Search workspace symbols' })
    nnoremap('gr', fzflua.lsp_references, { desc = 'Lsp references' })
    nnoremap('gd', fzflua.lsp_definitions, { desc = 'Lsp definitions' })
  end,
}
