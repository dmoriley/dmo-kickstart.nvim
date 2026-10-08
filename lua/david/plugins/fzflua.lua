local mapper = require('david.core.utils').mapper_factory
local nnoremap = mapper('n')
local xnoremap = mapper('x')

return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  config = function()
    local fzflua = require('fzf-lua')

    fzflua.register_ui_select()
    fzflua.setup({
      defaults = {
        formatter = 'path.filename_first',
      },
      commands = {
        actions = {
          -- Override the default `ex_run` behavior, which feeds `:` and leaves the
          -- selected command in the cmdline, so selecting a command executes it immediately.
          ['enter'] = fzflua.actions.ex_run_cr,
        },
      },
      oldfiles = {
        include_current_session = true,
      },
      keymaps = {
        show_details = false,
      },
      helptags = {
        actions = {
          ['enter'] = fzflua.actions.help_vert,
        },
      },
      -- previewers config inside picker
      previewers = {
        builtin = {
          -- don't add syntax highlighting for files larger than below
          syntax_limit_b = 1024 * 200, -- 200KB
        },
      },
    })

    -- highlights
    vim.api.nvim_set_hl(0, 'FzfLuaBorder', { fg = '#FFCC00' })

    -- global
    -- nnoremap('<leader><space>', fzflua.global, { desc = 'FzfLua global' })

    -- find
    nnoremap('<leader>ff', fzflua.files, { desc = 'Find files' })
    nnoremap('<leader>fr', function()
      fzflua.oldfiles({
        cwd_only = true,
        winopts = {
          title = ' Recent files ',
        },
      })
    end, { desc = 'Find recent files' })
    nnoremap('<S-Tab>', function()
      fzflua.oldfiles({
        cwd_only = true,
        winopts = {
          title = ' Quick Recent ',
        },
        fzf_opts = {
          ['--no-input'] = true,
          ['--no-multi'] = true,
        },
        keymap = {
          fzf = {
            ['q'] = 'abort',
            ['tab'] = 'down',
          },
        },
        actions = {
          ['a'] = fzflua.actions.file_edit,
          ['enter'] = fzflua.actions.file_edit,
        },
      })
    end, { desc = 'Quick Recent' })

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
    nnoremap('<leader>gf', fzflua.git_bcommits, { desc = 'Git file log' })
    nnoremap('<leader>gF', fzflua.git_commits, { desc = 'Git workspace log' })
    -- `git log -L` tracks a line range through history; -s drops the patch so each commit is one fzf line.
    local function git_line_history(first, last)
      fzflua.git_bcommits({
        cmd = string.format(
          [[git log -L%d,%d:{file} -s --color --pretty=format:"%%C(yellow)%%h%%Creset %%Cgreen(%%><(12)%%cr%%><|(12))%%Creset %%s %%C(blue)<%%an>%%Creset"]],
          first,
          last
        ),
        prompt = string.format('Line history %d-%d> ', first, last),
      })
    end
    nnoremap('<leader>gl', function()
      local line = vim.fn.line('.')
      git_line_history(line, line)
    end, { desc = 'Git log current line' })
    xnoremap('<leader>gl', function()
      local first, last = vim.fn.line('v'), vim.fn.line('.')
      if first > last then
        first, last = last, first
      end
      vim.cmd('normal! \27')
      git_line_history(first, last)
    end, { desc = 'Git log selected lines' })
    nnoremap('<leader>gB', fzflua.git_branches, { desc = 'Git branches' })

    -- lsp/dianostics
    nnoremap('<leader>sd', fzflua.diagnostics_document, { desc = 'Search Document Diagnostics' })
    nnoremap('<leader>sD', fzflua.diagnostics_workspace, { desc = 'Search Workspace Diagnostics' })
    nnoremap('<leader>ss', fzflua.lsp_document_symbols, { desc = 'Search document symbols' })
    nnoremap('<leader>sS', fzflua.lsp_workspace_symbols, { desc = 'Search workspace symbols' })
    -- Multiple clients (e.g. vtsls + angularls) can return the same locations, and
    -- fzf-lua only dedupes within a single client's response, so filter across clients.
    local function dedupe_locations()
      local seen = {}
      return function(item)
        local key = string.format('%s:%d:%d', item.filename, item.lnum, item.col)
        if seen[key] then
          return false
        end
        seen[key] = true
        return true
      end
    end
    nnoremap('gr', function()
      fzflua.lsp_references({ regex_filter = dedupe_locations() })
    end, { desc = 'Lsp references' })
    nnoremap('gd', function()
      fzflua.lsp_definitions({ regex_filter = dedupe_locations() })
    end, { desc = 'Lsp definitions' })
  end,
}
