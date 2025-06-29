-- C++ specific configuration
-- This file is automatically loaded when editing C++ files (.cpp, .cc, .cxx, .c++, .hpp, .h)

-- LSP Configuration for C++
local lspconfig = require('lspconfig')

-- Setup clangd LSP server
lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    -- Disable clangd's signature help in favor of other plugins
    client.server_capabilities.signatureHelpProvider = false
    
    -- Buffer-local keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
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
  end,
})

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

-- Compiler settings
vim.opt_local.makeprg = "g++ -std=c++17 -Wall -Wextra -g -o %:r %"

-- Define some useful commands for C++ development
vim.api.nvim_buf_create_user_command(0, 'CppCompile', function()
  vim.cmd('make')
end, { desc = 'Compile current C++ file' })

vim.api.nvim_buf_create_user_command(0, 'CppRun', function()
  local filename = vim.fn.expand('%:r')
  vim.cmd('terminal ./' .. filename)
end, { desc = 'Run compiled C++ executable' })

vim.api.nvim_buf_create_user_command(0, 'CppCompileRun', function()
  vim.cmd('make')
  vim.defer_fn(function()
    local filename = vim.fn.expand('%:r')
    vim.cmd('terminal ./' .. filename)
  end, 1000)
end, { desc = 'Compile and run C++ file' })

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
