local M = {}

-- TODO: Experiment with persisting these values between sessions somhow
---Keep track of the active extension and folders for `live_grep`
local filters = {
  ---@type nil|table
  accepted_extensions = nil,
  ---@type nil|table
  ignore_extensions = nil
}

M.live_grep_filters = {}

local function parse_grep_filters(tbl)
  local args = {}

  -- combine the accepted and ignore extensions to be applied to every grep session
  if tbl.accepted_extensions and #tbl.accepted_extensions > 0 then
    args = { unpack(tbl.accepted_extensions) }
  end

  if tbl.ignore_extensions and #tbl.ignore_extensions > 0 then
    for _, value in ipairs(tbl.ignore_extensions) do
      table.insert(args, value)
    end
  end

  return args
end

M.filter_included_extensions = function()
  local defaultText = ''

  if filters.accepted_extensions and #filters.accepted_extensions > 0 then
    -- create a string of the the already applied extensions to display in prompt
    for _, extension in ipairs(filters.accepted_extensions) do
      -- check if the extension is not equal to -g
      if extension ~= '-g' then
        -- concat to defaultText
        -- substring after the first character of extension (lua is 1 based, not 0)
        -- add a comma at the end
        defaultText = defaultText .. string.sub(extension, 2) .. ','
      end
    end
  end

  -- solution using synchronous fn.input
  local success, input = pcall(vim.fn.input, { prompt = 'Include extensions: ', default = defaultText })

  if not success then
    return false
  end

  -- expect input to be comma separated list of extensions
  -- Ex: ".html,.spec.ts,.test.ts"

  -- if the user clear the input of already existing filters
  if input == nil or input == '' and filters.accepted_extensions and #filters.accepted_extensions > 0 then
    -- clear them, close the buffer and restart the grep session with the newly cleared filters
    filters.accepted_extensions = nil
    M.live_grep_filters = parse_grep_filters(filters)
    return true
  elseif input == nil or input == '' then
    return false
  end

  local parsedExtensions = {}
  -- string split and loop by matching a capture group and looping
  -- over the results of that capture group only, ignoring other characters
  -- so in this case ignoring the separator char because its not apart of the
  -- capture group pattern
  -- [] capture group
  -- %. escaped out the period characters (% is escape in the context)
  -- %w+ get one or more alphanumeric characters (% not an escape in this context)
  -- + get one or more
  for extension in string.gmatch(input, '[%.%w+]+') do
    table.insert(parsedExtensions, extension)
  end

  local additionalArgs = {}
  -- loop over the parsed extensions
  for _, extension in ipairs(parsedExtensions) do
    -- append the -g for a new glob pattern per parsed extensions
    -- you can have more than one glob pattern for rg and you needs
    -- multiple -g to stack different patterns
    table.insert(additionalArgs, '-g')
    -- '!' is the not operator so rg excludes the glob pattern from the search results
    -- '*' is just filling out the file path of the supplied extensions so *.test,
    -- meaning anything with a .test extension is ignore
    table.insert(additionalArgs, '*' .. extension)
  end

  filters.accepted_extensions = additionalArgs
  M.live_grep_filters = parse_grep_filters(filters)
  return true
end

M.filter_ignored_extensions = function(callback)
  local defaultText = ''

  -- check if ignore extension is not null and that its length is greater than 0
  if filters.ignore_extensions and #filters.ignore_extensions > 0 then
    -- create a string of the the already applied extensions to display in prompt
    for _, extension in ipairs(filters.ignore_extensions) do
      -- check if the extension is not equal to -g
      if extension ~= '-g' then
        -- concat to defaultText
        -- substring after the first two characters of extension (lua is 1 based, not 0)
        -- add a comma at the end
        defaultText = defaultText .. string.sub(extension, 3) .. ','
      end
    end
  end

  -- solution using async ui.input
  vim.ui.input({ prompt = 'Ignored extensions', default = defaultText }, function(input)
    -- expect input to be comma separated list of extensions
    -- Ex: ".html,.spec.ts,.test.ts"
    --
    -- if the user clear the input of already existing filters
    if input == nil or input == '' and filters.ignore_extensions and #filters.ignore_extensions > 0 then
      -- clear them, close the buffer and restart the grep session with the newly cleared filters
      filters.ignore_extensions = nil
      M.live_grep_filters = parse_grep_filters(filters)
      callback()
      return
    -- user didnt type anything and just closed it
    elseif input == nil or input == '' then
      return
    end

    local parsedExtensions = {}
    -- string split and loop by matching a capture group and looping
    -- over the results of that capture group only, ignoring other characters
    -- so in this case ignoring the separator char because its not apart of the
    -- capture group pattern
    -- [] capture group
    -- %. escaped out the period characters (% is escape in the context)
    -- %w+ get one or more alphanumeric characters (% not an escape in this context)
    -- + get one or more
    for extension in string.gmatch(input, '[%.%w+]+') do
      table.insert(parsedExtensions, extension)
    end

    local additionalArgs = {}
    -- loop over the parsed extensions
    for _, extension in ipairs(parsedExtensions) do
      -- append the -g for a new glob pattern per parsed extensions
      -- you can have more than one glob pattern for rg and you needs
      -- multiple -g to stack different patterns
      table.insert(additionalArgs, '-g')
      -- '!' is the not operator so rg excludes the glob pattern from the search results
      -- '*' is just filling out the file path of the supplied extensions so *.test,
      -- meaning anything with a .test extension is ignore
      table.insert(additionalArgs, '!*' .. extension)
    end

    -- filters.ignore_extension = '!*' .. input
    filters.ignore_extensions = additionalArgs
    M.live_grep_filters = parse_grep_filters(filters)
    callback()
  end)
end

return M
