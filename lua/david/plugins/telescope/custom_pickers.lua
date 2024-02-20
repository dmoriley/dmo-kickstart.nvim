-- files copied from this repo
-- @see https://github.com/JoosepAlviste/dotfiles/blob/master/config/nvim/lua/j/telescope_custom_pickers.lua

-- See the telescope developlers md on how to create your own telescope extension
-- @see https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md
local action_state = require 'telescope.actions.state'
local transform_mod = require('telescope.actions.mt').transform_mod
local actions = require 'telescope.actions'
local utils = require('david.plugins.telescope.utils')

-- imports for filter by folder
--[[ local action_set = require 'telescope.actions.set'
local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local os_sep = Path.path.sep
local pickers = require 'telescope.pickers'
local scan = require 'plenary.scandir' ]]

local M = {}

---@param current_input ?string
local function custom_live_grep(current_input)
  require('david.plugins.telescope.pretty_pickers').pretty_grep_picker {
    picker = 'live_grep',
    options = {
      -- this is like passing args to rip grep on the command line
      -- this would be like saying "rp -g *.ext SEARCH_TEXT"
      additional_args = function()
        return utils.live_grep_filters
      end,
      default_text = current_input,
    },
  }
end

M.actions = transform_mod {
  ---Ask for a file extension and open a new `live_grep` filtering by it
  set_extension = function(prompt_bufnr)
    local ok = utils.filter_included_extensions()

    if ok then
      local current_input = action_state.get_current_line()
      actions.close(prompt_bufnr)
      custom_live_grep(current_input)
    end
  end,

  set_ignore_extension = function(prompt_bufnr)
    utils.filter_ignored_extensions(function()
      local current_input = action_state.get_current_line()
      actions.close(prompt_bufnr)
      custom_live_grep(current_input)
    end)
  end,

  ---Ask the user for a folder and open a new `live_grep` filtering by it
  -- set_folders = function(prompt_bufnr)
  --   local current_input = action_state.get_current_line()
  --
  --   local data = {}
  --   scan.scan_dir(vim.loop.cwd(), {
  --     hidden = true,
  --     only_dirs = true,
  --     respect_gitignore = true,
  --     on_insert = function(entry)
  --       table.insert(data, entry .. os_sep)
  --     end,
  --   })
  --   table.insert(data, 1, '.' .. os_sep)
  --
  --   actions.close(prompt_bufnr)
  --   pickers
  --     .new({}, {
  --       prompt_title = 'Folders for Live Grep',
  --       finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file {} },
  --       previewer = conf.file_previewer {},
  --       sorter = conf.file_sorter {},
  --       attach_mappings = function(prompt_bufnr)
  --         action_set.select:replace(function()
  --           local current_picker = action_state.get_current_picker(prompt_bufnr)
  --
  --           local dirs = {}
  --           local selections = current_picker:get_multi_selection()
  --           if vim.tbl_isempty(selections) then
  --             table.insert(dirs, action_state.get_selected_entry().value)
  --           else
  --             for _, selection in ipairs(selections) do
  --               table.insert(dirs, selection.value)
  --             end
  --           end
  --           live_grep_filters.directories = dirs
  --
  --           actions.close(prompt_bufnr)
  --           run_live_grep(current_input)
  --         end)
  --         return true
  --       end,
  --     })
  --     :find()
  -- end,
}

M.custom_live_grep = custom_live_grep

return M
