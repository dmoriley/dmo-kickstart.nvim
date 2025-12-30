local function setup()
  local cwd = vim.fn.getcwd()
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
      vim.notify('Error opening file: ' .. err, vim.log.levels.ERROR)
    end
  end

  local function openFileWithNewExtension(new_extention)
    -- Get the directory of the currently opened buffer
    -- local current_buffer = vim.api.nvim_buf_get_name(0)
    local current_buffer_full_path = vim.fn.expand('%:p')
    local current_dir_path = vim.fn.fnamemodify(current_buffer_full_path, ':h')
    local fileName_withExtension = vim.fn.fnamemodify(current_buffer_full_path, ':t')
    -- match any character up to the first period
    local fileName_noExtention = string.match(fileName_withExtension, '([^%.]+)')

    -- :r modifier only removes the first extension
    -- local fileName_noExtention = vim.fn.fnamemodify(fileName_withExtension, ':r')
    -- another patter that could be used, it returns a tuple of two for each capture group
    -- local fileName_noExtention, _ = string.match(fileName_withExtension, "(%w+)(.*)")

    local file_to_check = fileName_noExtention .. new_extention
    local file_path = current_dir_path .. '/' .. file_to_check

    if fileName_withExtension == file_to_check then
      vim.notify('Already on file ' .. file_to_check, vim.log.levels.INFO)
      return
    end

    if fileExists(file_path) then
      openFileInNewBuffer(file_path)
    else
      vim.notify('File ' .. file_to_check .. ' doesnt exists in the current directory', vim.log.levels.WARN)
    end
  end

  local function setupLitKeymaps()
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
  end

  local function setupAngularKeymaps()
    vim.keymap.set('n', '<leader>la', function()
      openFileWithNewExtension('.component.ts')
    end, { desc = 'Open component.ts file for current component' })

    vim.keymap.set('n', '<leader>ls', function()
      openFileWithNewExtension('.component.html')
    end, { desc = 'Open .html file for the current component' })

    vim.keymap.set('n', '<leader>ld', function()
      openFileWithNewExtension('.component.scss')
    end, { desc = 'Open .scss file for the current component' })

    vim.keymap.set('n', '<leader>lf', function()
      openFileWithNewExtension('.component.spec.ts')
    end, { desc = 'Open .spec.ts for the current component' })
  end

  -- create commands that can be called at will to switch keymaps later
  vim.api.nvim_create_user_command(
    'LitFileKeymaps',
    setupLitKeymaps,
    { nargs = 0, desc = 'Keymaps for switching between component files in lit web component projects' }
  )
  vim.api.nvim_create_user_command(
    'AngularFileKeymaps',
    setupAngularKeymaps,
    { nargs = 0, desc = 'Keymaps for switching between component files in Angular projects' }
  )

  if fileExists(cwd .. '/angular.json') then
    setupAngularKeymaps()
  elseif fileExists(cwd .. '/custom-elements.json') or fileExists(cwd .. '/plopfile.js') then
    setupLitKeymaps()
  end
end

-- lazy load on dir changed event
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = setup,
  once = true,
})
