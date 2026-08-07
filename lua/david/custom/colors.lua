local highlight_augroup = vim.api.nvim_create_augroup('user-custom-highlights', { clear = true })

local function apply_custom_highlights()
  vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })

  -- Change the colour of the spell check underline.
  local spell_color = '#0388fc'
  for _, group in ipairs({ 'SpellBad', 'SpellLocal', 'SpellCap', 'SpellRare' }) do
    vim.api.nvim_set_hl(0, group, { sp = spell_color, undercurl = true })
  end

  -- Make code lenses distinct from inlay hints.
  local code_lens_color = '#36FCFF'
  vim.api.nvim_set_hl(0, 'LspCodeLens', {
    fg = code_lens_color,
  })
  vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { fg = code_lens_color })

  -- Give the CodeCompanion chat buffer distinct backgrounds. The plugin only
  -- defines these as `default` links, so setting them here wins. Inherit the
  -- foreground/style from the group it would have linked to.
  for group, spec in pairs({
    CodeCompanionChatHeader = { link = '@markup.heading.2.markdown', bg = '#373B43' },
    CodeCompanionChatSeparator = { link = '@markup.heading.2.markdown', bg = '#373B43' },
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = spec.link, link = false })
    hl.bg = spec.bg
    vim.api.nvim_set_hl(0, group, hl)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = highlight_augroup,
  callback = apply_custom_highlights,
  desc = 'Reapply custom highlight overrides',
})

apply_custom_highlights()
