-- Function to check if a file exists
local function fileExists(file)
  local f = io.open(file, 'r')
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

-- Function to open a file in a new buffer with error handling
local function openFileInNewBuffer(file_path)
  local success, err = pcall(function()
    vim.api.nvim_command('edit ' .. file_path)
  end)

  if not success then
    print('Error opening file: ' .. err)
  end
end

local function openFileWithNewExtension(new_extention)
  -- Get the directory of the currently opened buffer
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_buffer, ':p:h')
  local fileName_withExtension = vim.fn.fnamemodify(current_buffer, ':t')
  -- match any character up to the first period
  local fileName_noExtention = string.match(fileName_withExtension, '([^%.]+)')
  -- another patter that could be used, it returns a tuple of two for each capture group
  -- local fileName_noExtention, _ = string.match(fileName_withExtension, "(%w+)(.*)")

  local file_to_check = fileName_noExtention .. new_extention
  local file_path = current_dir .. '/' .. file_to_check

  if fileName_withExtension == file_to_check then
    print('Already on file ' .. file_to_check)
    return
  end

  if fileExists(file_path) then
    openFileInNewBuffer(file_path)
  else
    print('File ' .. file_to_check .. ' doesnt exists in the current directory')
  end
end

vim.keymap.set('n', '<leader>la', function()
  openFileWithNewExtension('.ts')
end, { desc = 'Open .ts version of current file' })

vim.keymap.set('n', '<leader>ls', function()
  openFileWithNewExtension('.stories.ts')
end, { desc = 'Open .stories.ts version of current file' })

vim.keymap.set('n', '<leader>ld', function()
  openFileWithNewExtension('.styles.ts')
end, { desc = 'Open .styles.ts version of current file' })

vim.keymap.set('n', '<leader>lf', function()
  openFileWithNewExtension('.test.ts')
end, { desc = 'Open .test.ts version of current file' })
