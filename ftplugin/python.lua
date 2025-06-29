-- Python specific configuration
-- This file is automatically loaded when editing Python files (.py)

-- LSP Configuration for Python
local lspconfig = require('lspconfig')

-- Setup Pyright (Microsoft's Python Language Server)
lspconfig.pyright.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
  on_attach = function(client, bufnr)
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
    
    -- Python specific keymaps
    vim.keymap.set('n', '<leader>pi', '<cmd>PyrightOrganizeImports<cr>', { desc = 'Organize Imports' })
    vim.keymap.set('n', '<leader>pr', '<cmd>PyrightSetPythonPath<cr>', { desc = 'Set Python Path' })
  end,
})

-- Also setup Ruff LSP for ultra-fast linting and formatting
lspconfig.ruff_lsp.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  },
  on_attach = function(client, bufnr)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,
})

-- Python specific settings
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
vim.opt_local.textwidth = 88  -- Black formatter default
vim.opt_local.colorcolumn = "89"

-- Set commentstring for Python
vim.opt_local.commentstring = "# %s"

-- Set up auto-formatting on save (using Ruff)
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Python specific abbreviations and snippets
vim.cmd([[
  iabbrev <buffer> #! #!/usr/bin/env python3
  iabbrev <buffer> pdb import pdb; pdb.set_trace()
  iabbrev <buffer> ipdb import ipdb; ipdb.set_trace()
  iabbrev <buffer> pp import pprint; pprint.pprint
  iabbrev <buffer> dt from datetime import datetime
  iabbrev <buffer> np import numpy as np
  iabbrev <buffer> pd import pandas as pd
  iabbrev <buffer> plt import matplotlib.pyplot as plt
  iabbrev <buffer> tf import tensorflow as tf
  iabbrev <buffer> torch import torch
]])

-- Enhanced folding for Python
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldlevel = 1

-- Python execution settings
vim.opt_local.makeprg = "python3 %"

-- Define useful commands for Python development
vim.api.nvim_buf_create_user_command(0, 'PyRun', function()
  vim.cmd('!python3 %')
end, { desc = 'Run current Python file' })

vim.api.nvim_buf_create_user_command(0, 'PyRunAsync', function()
  vim.cmd('terminal python3 %')
end, { desc = 'Run Python file in terminal' })

vim.api.nvim_buf_create_user_command(0, 'PyTest', function()
  vim.cmd('!python3 -m pytest %')
end, { desc = 'Run pytest on current file' })

vim.api.nvim_buf_create_user_command(0, 'PyTestAll', function()
  vim.cmd('!python3 -m pytest')
end, { desc = 'Run all tests with pytest' })

vim.api.nvim_buf_create_user_command(0, 'PyFormat', function()
  vim.cmd('!black %')
end, { desc = 'Format with Black' })

vim.api.nvim_buf_create_user_command(0, 'PyLint', function()
  vim.cmd('!pylint %')
end, { desc = 'Run pylint on current file' })

vim.api.nvim_buf_create_user_command(0, 'PyProfile', function()
  vim.cmd('!python3 -m cProfile -s cumulative %')
end, { desc = 'Profile current Python file' })

vim.api.nvim_buf_create_user_command(0, 'PyVenv', function()
  local venv_path = vim.fn.input('Virtual environment path: ', vim.fn.getcwd() .. '/venv', 'dir')
  if venv_path ~= '' then
    vim.cmd('!source ' .. venv_path .. '/bin/activate')
    print('Virtual environment activated: ' .. venv_path)
  end
end, { desc = 'Activate virtual environment' })

-- Jupyter notebook support (if you use notebooks)
vim.api.nvim_buf_create_user_command(0, 'PyJupyter', function()
  vim.cmd('!jupyter notebook')
end, { desc = 'Start Jupyter notebook' })

-- Debug adapter configuration (if you have nvim-dap installed)
local dap_ok, dap = pcall(require, 'dap')
if dap_ok then
  dap.adapters.python = {
    type = 'executable',
    command = 'python3',
    args = { '-m', 'debugpy.adapter' },
  }
  
  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        return '/usr/bin/python3'
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = "Launch file with arguments",
      program = "${file}",
      args = function()
        local args_string = vim.fn.input('Arguments: ')
        return vim.split(args_string, " +")
      end,
      pythonPath = function()
        return '/usr/bin/python3'
      end,
    },
    {
      type = 'python',
      request = 'attach',
      name = 'Attach remote',
      connect = function()
        local host = vim.fn.input('Host [127.0.0.1]: ')
        host = host ~= '' and host or '127.0.0.1'
        local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
        return { host = host, port = port }
      end,
    },
  }
end

-- Python-specific keybindings for common operations
vim.keymap.set('n', '<leader>pd', 'oimport pdb; pdb.set_trace()<Esc>', { desc = 'Insert pdb breakpoint', buffer = 0 })
vim.keymap.set('n', '<leader>pp', 'oimport pprint; pprint.pprint()<Esc>F)i', { desc = 'Insert pprint', buffer = 0 })

-- Virtual environment detection
local function detect_venv()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    print("Python virtual environment detected: " .. venv_path)
  end
end

-- Run venv detection when the file loads
detect_venv()

print("Python ftplugin loaded - Pyright LSP, Ruff formatting, debugging, and Python-specific commands available")
