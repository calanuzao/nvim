-- C specific configuration
-- This file is automatically loaded when editing C files (.c)

-- Buffer-local keymaps for C (LSP should be configured globally)
local opts = { noremap = true, silent = true, buffer = 0 }

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
