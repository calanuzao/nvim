-- C specific configuration
-- This file is automatically loaded when editing C files (.c)

-- LSP Configuration for C
local lspconfig = require('lspconfig')

-- Setup clangd LSP server for C
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
    
    -- C specific keymaps
    vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
  end,
})

-- C specific settings
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.cindent = true

-- Set commentstring for C
vim.opt_local.commentstring = "/* %s */"

-- Set up auto-formatting on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- C specific abbreviations
vim.cmd([[
  iabbrev <buffer> #i #include
  iabbrev <buffer> #d #define
  iabbrev <buffer> printf printf
]])

-- Compiler settings for C
vim.opt_local.makeprg = "gcc -std=c11 -Wall -Wextra -g -o %:r %"

-- Define some useful commands for C development
vim.api.nvim_buf_create_user_command(0, 'CCompile', function()
  vim.cmd('make')
end, { desc = 'Compile current C file' })

vim.api.nvim_buf_create_user_command(0, 'CRun', function()
  local filename = vim.fn.expand('%:r')
  vim.cmd('terminal ./' .. filename)
end, { desc = 'Run compiled C executable' })

print("C ftplugin loaded - clangd LSP and C-specific settings configured")
