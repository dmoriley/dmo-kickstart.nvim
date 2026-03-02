vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })

-- Change the colour of the spell check underline
local spell_color = '#0388fc'
for _, group in ipairs({ 'SpellBad', 'SpellLocal', 'SpellCap', 'SpellRare' }) do
  vim.api.nvim_set_hl(0, group, { sp = spell_color, undercurl = true })
end
