-- C/C++ header file specific configuration
-- This file is automatically loaded when editing header files (.h, .hpp, .hxx)

-- Load the main C++ configuration
vim.cmd('runtime ftplugin/cpp.lua')

-- Header-specific settings
vim.opt_local.commentstring = "// %s"

-- Header guard snippet (you can customize this)
vim.api.nvim_buf_create_user_command(0, 'HeaderGuard', function()
  local filename = vim.fn.expand('%:t:r'):upper()
  local guard_name = filename .. '_H'
  
  -- Replace any non-alphanumeric characters with underscores
  guard_name = guard_name:gsub('[^%w_]', '_')
  
  local lines = {
    '#ifndef ' .. guard_name,
    '#define ' .. guard_name,
    '',
    '// Your code here',
    '',
    '#endif // ' .. guard_name
  }
  
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  vim.api.nvim_win_set_cursor(0, {4, 0})
end, { desc = 'Insert header guard' })

-- Class template snippet
vim.api.nvim_buf_create_user_command(0, 'ClassTemplate', function()
  local filename = vim.fn.expand('%:t:r')
  local class_name = filename:gsub('^%l', string.upper) -- Capitalize first letter
  
  local lines = {
    'class ' .. class_name .. ' {',
    'public:',
    '    ' .. class_name .. '();',
    '    ~' .. class_name .. '();',
    '',
    'private:',
    '    // Private members',
    '};'
  }
  
  vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
end, { desc = 'Insert class template' })

print("C++ header ftplugin loaded - header guards and class templates available")
