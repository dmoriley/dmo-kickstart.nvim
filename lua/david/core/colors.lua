vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })

-- Change the colour of the spell check underline
local spellCheckColour = '#0388fc'
vim.api.nvim_set_hl(0, 'SpellBad', { sp = spellCheckColour, undercurl = true })
vim.api.nvim_set_hl(0, 'SpellLocal', { sp = spellCheckColour, undercurl = true })
vim.api.nvim_set_hl(0, 'SpellCap', { sp = spellCheckColour, undercurl = true })
vim.api.nvim_set_hl(0, 'SpellRare', { sp = spellCheckColour, undercurl = true })
