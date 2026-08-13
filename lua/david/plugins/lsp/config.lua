-- local function setup_codelens_display()
--   local codelens = vim.lsp.codelens
--   if codelens._rounded_display then
--     return
--   end
--
--   codelens._rounded_display = true
--
--   local default_display = codelens.display
--
--   codelens.display = function(lenses, bufnr, client_id)
--     local decorated_lenses = {}
--
--     for index, lens in ipairs(lenses or {}) do
--       local title = lens.command and lens.command.title or 'Unresolved lens ...'
--
--       -- Copy the lens before decorating so refreshes do not keep nesting the
--       -- rounded separators into the cached title.
--       local decorated_lens = vim.tbl_extend('keep', {}, lens)
--       decorated_lens.command = vim.tbl_extend('keep', {}, lens.command or {})
--       decorated_lens.command.title = '|▶ ' .. title:upper():gsub('%s+', ' ') .. ' ◀|'
--       decorated_lenses[index] = decorated_lens
--     end
--
--     default_display(decorated_lenses, bufnr, client_id)
--   end
-- end

return function(_, opts)
  local servers = require('david.plugins.lsp.servers').servers
  local lsp_mappings = require('david.plugins.lsp.mappings')

  vim.api.nvim_create_user_command('ToggleInlayHints', function(command_opts)
    local bufnr = command_opts.args ~= '' and tonumber(command_opts.args) or vim.api.nvim_get_current_buf()

    if not bufnr then
      vim.notify('ToggleInlayHints expects a numeric buffer number', vim.log.levels.ERROR)
      return
    end

    lsp_mappings.toggle_inlay_hints(bufnr)
  end, {
    nargs = '?',
    desc = 'Toggle inlay hints for the current buffer or a given bufnr',
  })

  -- attach common lsp callbacks
  local groupId = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = groupId,
    callback = function(args)
      lsp_mappings.attach(args, opts)
    end,
  })

  -- update capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

  -- folding settings for nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  for name, value in pairs(servers) do
    -- add capabilities to the config obj
    local config = vim.tbl_deep_extend('force', value or {}, { capabilities = capabilities })
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

--[[
Examples for reference later

Ascii Title bookends

╭─〔 TITLE 〕─╮
┏━[ TITLE ]━┓
<═≡ TITLE ≡═>
✦─[ TITLE ]─✦
───❮ TITLE ❯───
╔═══⟦ TITLE ⟧═══╗
◈───[ TITLE ]───◈
┊─⊹ TITLE ⊹─┊
⟪━ TITLE ━⟫
✧══[ TITLE ]══✧
⌜── TITLE ──⌝
❰── TITLE ──❱
═─⟐ TITLE ⟐─═
✺══ TITLE ══✺
┈┈〔 TITLE 〕┈┈ 
╒══[ TITLE ]══╕
╓─── TITLE ───╖
◇━━[ TITLE ]━━◇
▣──〔 TITLE 〕──▣
❖═══ TITLE ═══❖
┌─⟦ TITLE ⟧─┐
┍━╍ TITLE ╍━┑
✥─[ TITLE ]─✥
☙══ TITLE ══☙
⟡─〔 TITLE 〕─⟡


Ascii Action bookends

[ RUN ]
< SAVE >
╭─ ACCEPT ─╮
┏━ APPLY ━┓
✦ EXECUTE ✦
▶ CONTINUE ◀
❮ CONFIRM ❯
═ ACT NOW ═
⟪ ENABLE ⟫
◈ PROCEED ◈
[ OPEN ]
< INSTALL >
]]
