# Agent Guidelines for Neovim Configuration

This is a personal Neovim configuration written in Lua using lazy.nvim as the plugin manager.

## Project Structure

```
.
├── init.lua                    # Entry point: requires 'david' module
├── lua/david/
│   ├── init.lua               # Main setup: core, lazy, ui, custom
│   ├── lazy.lua               # lazy.nvim plugin manager setup
│   ├── custom/                # My custom neovim configuration code for self made features
│   ├── core/                  # Core configuration modules
│   │   ├── init.lua           # Loads all core modules
│   │   ├── settings.lua       # Vim settings and options
│   │   ├── keymaps.lua        # All keybindings
│   │   ├── autocommands.lua   # Autocommands
│   │   ├── commands.lua       # Custom commands
│   │   ├── utils.lua          # Utility functions
│   │   └── env.lua            # Environment variables
│   └── plugins/               # Plugin configurations (one file per plugin)
│       ├── init.lua           # Simple plugins without config
│       ├── lsp/               # LSP-related configurations
│       │   ├── init.lua       # LSP plugin setup
│       │   ├── config.lua     # LSP configuration
│       │   ├── mappings.lua   # LSP keymaps
│       │   └── servers/       # Per-language server configs
│       └── *.lua              # Individual plugin configs
├── after/                     # After directory for filetype configs
├── plugin/                    # Vim plugin directory
├── snippets/                  # Custom snippets
└── .stylua.toml               # Stylua formatter config
```

## Build/Lint/Format Commands

### Formatting Lua Files

```bash
# Format all Lua files with stylua
stylua .

# Check formatting without modifying files
stylua --check .

# Format a single file
stylua lua/david/plugins/example.lua
```

### Within Neovim

- `<leader>cf` - Format current file or visual selection (uses conform.nvim)
- `<leader>l` - Lint current document (uses nvim-lint)
- Format on save is enabled by default for supported filetypes

### CI/CD

- GitHub Actions runs `stylua --check .` on pull requests
- See `.github/workflows/stylua.yml` for CI configuration

## Code Style Guidelines

### Formatting (Stylua)

Configuration in `.stylua.toml`:

```toml
column_width = 160
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
call_parentheses = "Always"
```

**Key Rules:**
- **Indentation**: 2 spaces (never tabs)
- **Line width**: Maximum 160 characters
- **Quotes**: Prefer single quotes, use double only when necessary
- **Function calls**: Always use parentheses, even for zero arguments
- **Line endings**: Unix style (LF)

### Naming Conventions

- **Variables/Functions**: `snake_case` (e.g., `my_function`, `local_var`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `DELIMITERS`, `BOOLEANS`)
- **Module tables**: Capital `M` for module exports
- **Private functions**: Use `local function` prefix
- **File names**: `kebab-case.lua`

### Imports and Requires

```lua
-- Standard library requires at the top
local vim = vim

-- External plugin requires next
local conform = require('conform')
local lint = require('lint')

-- Local module requires last
local utils = require('david.core.utils')
```

**Important:**
- Group requires logically (stdlib → plugins → local modules)
- Use local variables for all requires
- Avoid circular dependencies

### Module Structure

```lua
-- Module definition
local M = {}

-- Private local functions
local function private_helper()
  -- implementation
end

-- Public functions
function M.public_function()
  -- implementation
end

-- Return module
return M
```

For plugin configurations using lazy.nvim:

```lua
return {
  'author/plugin-name',
  event = 'BufReadPre',        -- Lazy loading trigger
  dependencies = {},            -- Plugin dependencies
  keys = {},                    -- Keymap-based lazy loading
  ft = {},                      -- Filetype-based lazy loading
  opts = {},                    -- Options (auto-calls setup)
  config = function()          -- Manual setup function
    -- configuration
  end,
}
```

### Type Annotations

Use EmmyLua annotations for better LSP support:

```lua
---@class PluginLspOpts
---@field inlay_hints table

---@param mode string|table The mode(s) for the keymap
---@return fun(lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts)
function M.mapper_factory(mode)
  -- implementation
end
```

### Error Handling

```lua
-- Use pcall for operations that might fail
local has_parser, parser = pcall(vim.treesitter.get_parser)
if not has_parser then
  return vim.bo.filetype
end

-- Use vim.notify for user-facing messages
vim.notify(err, vim.log.levels.ERROR)
```

### Comments

```lua
-- Single line comments with space after --
-- Use full sentences with proper capitalization

--[[ Multi-line comments
     for longer explanations
     use this format ]]

--- EmmyLua doc comments for functions
---@param direction string
function M.navigate_pane_or_window(direction)
end
```

### Keymaps

```lua
-- Use the mapper_factory utility from utils.lua
local mapper = utils.mapper_factory
local nnoremap = mapper('n')
local xnoremap = mapper('x')

-- Always provide descriptions
nnoremap('<leader>ws', '<cmd>wall<cr>', { desc = 'Workspace Save' })

-- Use leader key for custom commands
-- Leader: <Space>
-- Local leader: ,
```

### Settings and Options

```lua
-- Use vim.o for global options
local set = vim.o
set.number = true

-- Use vim.opt for list-style options
local opt = vim.opt
opt.iskeyword:append({ '-' })

-- Use vim.wo for window-local options
vim.wo.signcolumn = 'yes'

-- Use vim.g for global variables
vim.g.mapleader = ' '
```

### Autocommands

```lua
-- Always create augroups for organization
local augroup = vim.api.nvim_create_augroup('MyGroup', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight text on yank',
})
```

### Performance Considerations

- Use `vim.defer_fn()` to defer heavy operations after startup
- Lazy load plugins with `event`, `ft`, `keys`, or `cmd` options
- Avoid blocking operations in the main thread
- Use `vim.schedule()` for async callbacks

## Testing Changes

### Manual Testing

1. Open Neovim: `nvim`
2. Check for errors: `:checkhealth`
3. Verify plugins loaded: `:Lazy`
4. Test specific functionality in relevant file types

### Lua File Testing

```vim
" Source current Lua file
:luafile %

" Execute Lua code
:lua require('david.core.utils').open_floating_window()
```

## Common Patterns

### Plugin Configuration Template

```lua
return {
  'author/plugin-name',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local plugin = require('plugin-name')
    
    plugin.setup({
      -- configuration options
    })
    
    -- Additional setup (keymaps, commands, etc.)
  end,
}
```

### Adding New Keymaps

1. Add to `lua/david/core/keymaps.lua`
2. Use the mapper utility for consistency
3. Always include descriptive `desc` option
4. Follow existing keymap organization patterns

### Adding New Plugins

1. Create new file in `lua/david/plugins/`
2. Return lazy.nvim plugin spec
3. Configure lazy loading appropriately
4. Document keymaps and features
