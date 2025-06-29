-- MATLAB specific configuration
-- This file is automatically loaded when editing MATLAB files (.m)

-- MATLAB-specific settings
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- Set commentstring for MATLAB
vim.opt_local.commentstring = "%% %s"

-- MATLAB syntax highlighting
vim.opt_local.syntax = "matlab"

-- MATLAB specific abbreviations and snippets
vim.cmd([[
  iabbrev <buffer> %% %%
  iabbrev <buffer> func function [] = ()
  iabbrev <buffer> ffor for i = 1:
  iabbrev <buffer> iif if 
  iabbrev <buffer> eelse else
  iabbrev <buffer> eend end
  iabbrev <buffer> wwhile while 
  iabbrev <buffer> tryc try
  iabbrev <buffer> catchc catch
  iabbrev <buffer> disp disp('')
  iabbrev <buffer> fprintf fprintf('');
  iabbrev <buffer> plot plot();
  iabbrev <buffer> figure figure;
  iabbrev <buffer> subplot subplot();
  iabbrev <buffer> xlabel xlabel('');
  iabbrev <buffer> ylabel ylabel('');
  iabbrev <buffer> title title('');
  iabbrev <buffer> legend legend('');
  iabbrev <buffer> grid grid on;
  iabbrev <buffer> hold hold on;
  iabbrev <buffer> zeros zeros();
  iabbrev <buffer> ones ones();
  iabbrev <buffer> rand rand();
  iabbrev <buffer> randn randn();
  iabbrev <buffer> linspace linspace();
  iabbrev <buffer> logspace logspace();
]])

-- Enhanced folding for MATLAB (based on %% sections)
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "getline(v:lnum)=~'^%%'?'>1':'='"
vim.opt_local.foldlevel = 0

-- MATLAB execution settings
vim.opt_local.makeprg = "matlab -batch \"run('%')\""

-- Define useful commands for MATLAB development
vim.api.nvim_buf_create_user_command(0, 'MatlabRun', function()
  local filename = vim.fn.expand('%:t:r')
  vim.cmd('!matlab -batch "' .. filename .. '"')
end, { desc = 'Run current MATLAB file' })

vim.api.nvim_buf_create_user_command(0, 'MatlabRunSection', function()
  -- Get current line and find the section
  local current_line = vim.fn.line('.')
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Find section boundaries
  local section_start = 1
  local section_end = #lines
  
  -- Find the start of current section (look backwards for %%)
  for i = current_line, 1, -1 do
    if lines[i] and string.match(lines[i], '^%%%%') then
      section_start = i
      break
    end
  end
  
  -- Find the end of current section (look forwards for %%)
  for i = current_line + 1, #lines do
    if lines[i] and string.match(lines[i], '^%%%%') then
      section_end = i - 1
      break
    end
  end
  
  -- Extract section code
  local section_lines = {}
  for i = section_start, section_end do
    if lines[i] and not string.match(lines[i], '^%%%%') then
      table.insert(section_lines, lines[i])
    end
  end
  
  -- Write to temporary file and execute
  local temp_file = os.tmpname() .. '.m'
  local file = io.open(temp_file, 'w')
  if file then
    for _, line in ipairs(section_lines) do
      file:write(line .. '\n')
    end
    file:close()
    
    vim.cmd('!matlab -batch "run(\'' .. temp_file .. '\')"')
    os.remove(temp_file)
  end
end, { desc = 'Run current MATLAB section' })

vim.api.nvim_buf_create_user_command(0, 'MatlabDebug', function()
  local filename = vim.fn.expand('%:t:r')
  vim.cmd('!matlab -batch "keyboard; ' .. filename .. '"')
end, { desc = 'Debug current MATLAB file' })

vim.api.nvim_buf_create_user_command(0, 'MatlabLint', function()
  vim.cmd('!matlab -batch "checkcode(\'' .. vim.fn.expand('%') .. '\')"')
end, { desc = 'Run MATLAB Code Analyzer' })

vim.api.nvim_buf_create_user_command(0, 'MatlabProfile', function()
  local filename = vim.fn.expand('%:t:r')
  vim.cmd('!matlab -batch "profile on; ' .. filename .. '; profile viewer"')
end, { desc = 'Profile current MATLAB file' })

vim.api.nvim_buf_create_user_command(0, 'MatlabHelp', function()
  local word = vim.fn.expand('<cword>')
  vim.cmd('!matlab -batch "help ' .. word .. '"')
end, { desc = 'Show MATLAB help for word under cursor' })

vim.api.nvim_buf_create_user_command(0, 'MatlabDoc', function()
  local word = vim.fn.expand('<cword>')
  vim.cmd('!matlab -batch "doc ' .. word .. '"')
end, { desc = 'Show MATLAB documentation for word under cursor' })

-- Function to create MATLAB function template
vim.api.nvim_buf_create_user_command(0, 'MatlabFunction', function()
  local func_name = vim.fn.input('Function name: ')
  if func_name ~= '' then
    local lines = {
      'function [output] = ' .. func_name .. '(input)',
      '%' .. func_name:upper() .. ' - Brief description',
      '%',
      '% Syntax:',
      '%   [output] = ' .. func_name .. '(input)',
      '%',
      '% Inputs:',
      '%   input - Description',
      '%',
      '% Outputs:',
      '%   output - Description',
      '%',
      '% Author: ' .. (os.getenv('USER') or 'Unknown'),
      '% Date: ' .. os.date('%Y-%m-%d'),
      '',
      '% Add your code here',
      '',
      'end'
    }
    
    vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
  end
end, { desc = 'Insert MATLAB function template' })

-- MATLAB-specific keybindings
vim.keymap.set('n', '<leader>mr', ':MatlabRun<CR>', { desc = 'Run MATLAB file', buffer = 0 })
vim.keymap.set('n', '<leader>ms', ':MatlabRunSection<CR>', { desc = 'Run MATLAB section', buffer = 0 })
vim.keymap.set('n', '<leader>md', ':MatlabDebug<CR>', { desc = 'Debug MATLAB file', buffer = 0 })
vim.keymap.set('n', '<leader>ml', ':MatlabLint<CR>', { desc = 'Lint MATLAB file', buffer = 0 })
vim.keymap.set('n', '<leader>mp', ':MatlabProfile<CR>', { desc = 'Profile MATLAB file', buffer = 0 })
vim.keymap.set('n', '<leader>mh', ':MatlabHelp<CR>', { desc = 'MATLAB help', buffer = 0 })
vim.keymap.set('n', '<leader>mD', ':MatlabDoc<CR>', { desc = 'MATLAB documentation', buffer = 0 })
vim.keymap.set('n', '<leader>mf', ':MatlabFunction<CR>', { desc = 'Insert function template', buffer = 0 })

-- Quick section navigation (jump between %% sections)
vim.keymap.set('n', ']]', function()
  vim.fn.search('^%%', 'W')
end, { desc = 'Next MATLAB section', buffer = 0 })

vim.keymap.set('n', '[[', function()
  vim.fn.search('^%%', 'bW')
end, { desc = 'Previous MATLAB section', buffer = 0 })

-- Quick breakpoint insertion for debugging
vim.keymap.set('n', '<leader>mb', 'okeyboard<Esc>', { desc = 'Insert MATLAB breakpoint', buffer = 0 })

-- Quick disp() insertion for debugging
vim.keymap.set('n', '<leader>mp', 'odisp(\'\')<Esc>F\'i', { desc = 'Insert disp statement', buffer = 0 })

-- Auto-completion for common MATLAB patterns
vim.keymap.set('i', 'for<Tab>', 'for i = 1:<C-o>A<CR><CR>end<Up><Up><End>', { desc = 'For loop template', buffer = 0 })
vim.keymap.set('i', 'if<Tab>', 'if <CR><CR>end<Up><Up><End>', { desc = 'If statement template', buffer = 0 })
vim.keymap.set('i', 'while<Tab>', 'while <CR><CR>end<Up><Up><End>', { desc = 'While loop template', buffer = 0 })
vim.keymap.set('i', 'try<Tab>', 'try<CR><CR>catch<CR><CR>end<Up><Up><Up><Up><End>', { desc = 'Try-catch template', buffer = 0 })

-- MATLAB plot helpers
vim.keymap.set('n', '<leader>mP', function()
  local var = vim.fn.input('Variable to plot: ')
  if var ~= '' then
    vim.api.nvim_put({'figure; plot(' .. var .. '); grid on;'}, 'l', true, true)
  end
end, { desc = 'Quick plot command', buffer = 0 })

-- Function to toggle between script and function mode
vim.api.nvim_buf_create_user_command(0, 'MatlabToggleFunction', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local first_line = lines[1] or ''
  
  if string.match(first_line, '^function') then
    -- Convert function to script (remove function declaration and end)
    local new_lines = {}
    for i = 2, #lines - 1 do  -- Skip first (function) and last (end) lines
      table.insert(new_lines, lines[i])
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
    print('Converted to script')
  else
    -- Convert script to function
    local filename = vim.fn.expand('%:t:r')
    local func_line = 'function ' .. filename .. '()'
    local new_lines = {func_line}
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, 'end')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
    print('Converted to function')
  end
end, { desc = 'Toggle between script and function' })

-- Check if MATLAB is available
local function check_matlab()
  local handle = io.popen('which matlab 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()
    if result and result ~= '' then
      return true
    end
  end
  return false
end

-- Warn if MATLAB is not found
if not check_matlab() then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.notify("MATLAB not found in PATH. Some features may not work.", vim.log.levels.WARN)
    end,
    once = true,
  })
end

print("MATLAB ftplugin loaded - MATLAB-specific commands, section navigation, and templates available")
