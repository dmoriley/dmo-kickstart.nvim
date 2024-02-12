-- @see https://github.com/JoosepAlviste/dotfiles/blob/master/config/nvim/lua/j/telescope_custom_pickers.lua
--
local Path = require 'plenary.path'
local action_set = require 'telescope.actions.set'
local action_state = require 'telescope.actions.state'
local transform_mod = require('telescope.actions.mt').transform_mod
local actions = require 'telescope.actions'
local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local os_sep = Path.path.sep
local pickers = require 'telescope.pickers'
local scan = require 'plenary.scandir'

local M = {}

---Keep track of the active extension and folders for `live_grep`
local live_grep_filters = {
  ---@type nil|string
  extension = nil,
  ---@type nil|string[]
  directories = nil,
  ---@type nil|string
  ignore_extension = nil
}

---Run `live_grep` with the active filters (extension and folders)
---@param current_input ?string
local function run_live_grep(current_input)
  require('david.plugins.telescope.pretty_pickers').pretty_grep_picker {
    picker = 'live_grep',
    options = {
      additional_args = live_grep_filters.extension and function()
        -- this is like passing args to rip grep on the command line
        -- this would be like saying "rp -g *.ext SEARCH_TEXT"
        return { '-g', '*' .. live_grep_filters.extension }
      end,
      search_dirs = live_grep_filters.directories,
      -- TODO: refactor to use additional args with -g flag
      -- allow for multiple -g flags for extensions or ignore_extension
      glob_pattern = live_grep_filters.ignore_extension,
      default_text = current_input,
    },
  }
end

M.actions = transform_mod {
  ---Ask for a file extension and open a new `live_grep` filtering by it
  set_extension = function(prompt_bufnr)
    local current_input = action_state.get_current_line()

    vim.ui.input({ prompt = 'Include extensions' }, function(input)
      if input == nil or input == '' then
        live_grep_filters.extension = ''
        return
      end

      live_grep_filters.extension = input

      actions.close(prompt_bufnr)
      run_live_grep(current_input)
    end)
  end,

  set_ignore_extension = function (prompt_bufnr)
    local current_input = action_state.get_current_line()
    vim.ui.input({ prompt = 'Exclude Extensions' }, function(input)
      if input == nil or input == '' then
        live_grep_filters.ignore_extensions = ''
        return
      end

      -- TODO: allow for multiple comma separated extensions to ignore_extension
      -- and maybe somehow persist them between sessions? 

      live_grep_filters.ignore_extension = '!*' .. input

      actions.close(prompt_bufnr)
      run_live_grep(current_input)
    end)

  end,
  ---Ask the user for a folder and open a new `live_grep` filtering by it
  set_folders = function(prompt_bufnr)
    local current_input = action_state.get_current_line()

    local data = {}
    scan.scan_dir(vim.loop.cwd(), {
      hidden = true,
      only_dirs = true,
      respect_gitignore = true,
      on_insert = function(entry)
        table.insert(data, entry .. os_sep)
      end,
    })
    table.insert(data, 1, '.' .. os_sep)

    actions.close(prompt_bufnr)
    pickers
      .new({}, {
        prompt_title = 'Folders for Live Grep',
        finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file {} },
        previewer = conf.file_previewer {},
        sorter = conf.file_sorter {},
        attach_mappings = function(prompt_bufnr)
          action_set.select:replace(function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            local dirs = {}
            local selections = current_picker:get_multi_selection()
            if vim.tbl_isempty(selections) then
              table.insert(dirs, action_state.get_selected_entry().value)
            else
              for _, selection in ipairs(selections) do
                table.insert(dirs, selection.value)
              end
            end
            live_grep_filters.directories = dirs

            actions.close(prompt_bufnr)
            run_live_grep(current_input)
          end)
          return true
        end,
      })
      :find()
  end,
}

---Small wrapper over `live_grep` to first reset our active filters
M.live_grep = function()
  live_grep_filters.extension = nil
  live_grep_filters.directories = nil

  run_live_grep()
end

return M
