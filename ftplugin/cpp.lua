-- C++ specific configuration
-- This file is automatically loaded when editing C++ files (.cpp, .cc, .cxx, .c++, .hpp, .h)

-- Buffer-local keymaps for C++ (LSP should be configured globally)
local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

-- C++ specific keymaps
vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
vim.keymap.set('n', '<leader>cs', '<cmd>ClangdSymbolInfo<cr>', opts)
vim.keymap.set('n', '<leader>ct', '<cmd>ClangdTypeHierarchy<cr>', opts)

-- C++ specific settings
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.cindent = true
vim.opt_local.cinoptions = "g0,N-s,i0,j1,J1,ws,Ws"

-- Enable better syntax highlighting for C++
vim.opt_local.syntax = "cpp"

-- Set up auto-formatting on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- C++ specific abbreviations and snippets
vim.cmd([[
  iabbrev <buffer> #i #include
  iabbrev <buffer> #d #define
  iabbrev <buffer> cout std::cout
  iabbrev <buffer> cin std::cin
  iabbrev <buffer> endl std::endl
  iabbrev <buffer> vec std::vector
  iabbrev <buffer> str std::string
]])

-- Set commentstring for C++
vim.opt_local.commentstring = "// %s"

-- Enhanced folding for C++
vim.opt_local.foldmethod = "syntax"
vim.opt_local.foldlevel = 1

-- Compiler settings - ensure C++ specific settings
vim.opt_local.makeprg = "g++ -std=c++17 -Wall -Wextra -g -o %:r %"

-- Force set the makeprg for this buffer specifically
vim.api.nvim_create_autocmd("BufEnter", {
  buffer = 0,
  callback = function()
    vim.bo.makeprg = "g++ -std=c++17 -Wall -Wextra -g -o %:r %"
  end,
})

-- Define some useful commands for C++ development
vim.api.nvim_buf_create_user_command(0, 'CppCompile', function()
  print("makeprg = " .. vim.o.makeprg)
  vim.cmd('botright split')  -- Split at bottom like Ctrl+\
  vim.cmd('terminal make')
end, { desc = 'Compile current C++ file in bottom split' })

vim.api.nvim_buf_create_user_command(0, 'CppRun', function()
  local filename = vim.fn.expand('%:r')
  vim.cmd('botright split')  -- Split at bottom like Ctrl+\
  vim.cmd('terminal ./' .. filename)
end, { desc = 'Run compiled C++ executable in bottom split' })

vim.api.nvim_buf_create_user_command(0, 'CppCompileRun', function()
  local current_file = vim.fn.expand('%')
  local output_name = vim.fn.expand('%:r')
  local compile_cmd = string.format('g++ -std=c++17 -Wall -Wextra -g -o %s %s', output_name, current_file)
  
  print("Compiling with: " .. compile_cmd)
  
  -- Create bottom split like Ctrl+\ and run compilation in terminal
  vim.cmd('botright split')
  vim.cmd('terminal ' .. compile_cmd .. ' && echo "Compilation successful, running..." && ./' .. output_name)
end, { desc = 'Compile and run C++ file in bottom split' })

-- Additional C++ commands with different split options
vim.api.nvim_buf_create_user_command(0, 'CppCompileRunSmall', function()
  local current_file = vim.fn.expand('%')
  local output_name = vim.fn.expand('%:r')
  local compile_cmd = string.format('g++ -std=c++17 -Wall -Wextra -g -o %s %s', output_name, current_file)
  
  print("Compiling with: " .. compile_cmd)
  
  -- Create small bottom split (like a mini-terminal)
  vim.cmd('botright split')
  vim.cmd('resize 8')  -- Small height
  vim.cmd('terminal ' .. compile_cmd .. ' && echo "Compilation successful, running..." && ./' .. output_name)
end, { desc = 'Compile and run C++ file in small bottom split' })

vim.api.nvim_buf_create_user_command(0, 'CppCompileRunTab', function()
  local current_file = vim.fn.expand('%')
  local output_name = vim.fn.expand('%:r')
  local compile_cmd = string.format('g++ -std=c++17 -Wall -Wextra -g -o %s %s', output_name, current_file)
  
  print("Compiling with: " .. compile_cmd)
  
  -- Create new tab and run compilation in terminal
  vim.cmd('tabnew')
  vim.cmd('terminal ' .. compile_cmd .. ' && echo "Compilation successful, running..." && ./' .. output_name)
end, { desc = 'Compile and run C++ file in new tab' })

-- Quick compilation with output in small split (closes automatically on success)
vim.api.nvim_buf_create_user_command(0, 'CppQuickCompile', function()
  local current_file = vim.fn.expand('%')
  local output_name = vim.fn.expand('%:r')
  local compile_cmd = string.format('g++ -std=c++17 -Wall -Wextra -g -o %s %s 2>&1', output_name, current_file)
  
  -- First try compilation silently
  local result = vim.fn.system(compile_cmd)
  
  if vim.v.shell_error == 0 then
    print("✅ Compilation successful!")
    -- Optionally run the program
    local choice = vim.fn.input("Run the program? (y/n): ")
    if choice:lower() == 'y' then
      vim.cmd('split')
      vim.cmd('resize 12')
      vim.cmd('terminal ./' .. output_name)
    end
  else
    print("❌ Compilation failed!")
    -- Show errors in split
    vim.cmd('split')
    vim.cmd('resize 10')
    local temp_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, temp_buf)
    
    -- Set buffer content to compilation errors
    local error_lines = vim.split(result, '\n')
    vim.api.nvim_buf_set_lines(temp_buf, 0, -1, false, error_lines)
    vim.bo[temp_buf].filetype = 'cpp'
    vim.bo[temp_buf].buftype = 'nofile'
    
    -- Set buffer name
    vim.api.nvim_buf_set_name(temp_buf, 'Compilation Errors')
  end
end, { desc = 'Quick compile with smart error display' })

-- Debug command to check current settings
vim.api.nvim_buf_create_user_command(0, 'CppDebug', function()
  print("Current file: " .. vim.fn.expand('%'))
  print("File type: " .. vim.bo.filetype)
  print("makeprg: " .. vim.o.makeprg)
  print("Buffer makeprg: " .. (vim.bo.makeprg or "not set"))
  
  -- Check environment variables that might affect compilation
  local cflags = vim.fn.getenv('CFLAGS') or 'not set'
  local cxxflags = vim.fn.getenv('CXXFLAGS') or 'not set'
  local cc = vim.fn.getenv('CC') or 'not set'
  local cxx = vim.fn.getenv('CXX') or 'not set'
  
  print("CFLAGS: " .. cflags)
  print("CXXFLAGS: " .. cxxflags)
  print("CC: " .. cc)
  print("CXX: " .. cxx)
  
  -- Check which g++ is being used
  local gpp_path = vim.fn.system('which g++'):gsub('\n', '')
  print("g++ path: " .. gpp_path)
  
  -- Check g++ version
  local gpp_version = vim.fn.system('g++ --version | head -1'):gsub('\n', '')
  print("g++ version: " .. gpp_version)
end, { desc = 'Debug C++ settings' })

-- Debug adapter configuration (if you have nvim-dap installed)
local dap_ok, dap = pcall(require, 'dap')
if dap_ok then
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.exepath('OpenDebugAD7') or 'OpenDebugAD7',  -- Adjust path as needed
  }
  
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
    },
    {
      name = 'Attach to gdbserver :1234',
      type = 'cppdbg',
      request = 'launch',
      MIMode = 'gdb',
      miDebuggerServerAddress = 'localhost:1234',
      miDebuggerPath = '/usr/bin/gdb',
      cwd = '${workspaceFolder}',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
    },
  }
  
  -- Also set up for C files
  dap.configurations.c = dap.configurations.cpp
end

print("C++ ftplugin loaded - clangd LSP, formatting, and debugging configured")

-- Test command to capture exact compilation output
vim.api.nvim_buf_create_user_command(0, 'CppTest', function()
  local current_file = vim.fn.expand('%')
  local output_name = vim.fn.expand('%:r')
  local compile_cmd = string.format('g++ -std=c++17 -Wall -Wextra -g -o %s %s 2>&1', output_name, current_file)
  
  print("Testing compilation with: " .. compile_cmd)
  local result = vim.fn.system(compile_cmd)
  
  if vim.v.shell_error == 0 then
    print("SUCCESS: Compilation completed without errors")
    print("Output: " .. result)
  else
    print("ERROR: Compilation failed")
    print("Error output: " .. result)
    print("Error code: " .. vim.v.shell_error)
  end
end, { desc = 'Test C++ compilation and show exact errors' })
