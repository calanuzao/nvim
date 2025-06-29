--[[
================================================================================
CORE NEOVIM CONFIGURATION
================================================================================

This file contains the essential Neovim settings and options.
All settings from the original configuration are preserved.

Note: Leader keys are set in init.lua before lazy.nvim loads.
================================================================================
--]]

-- Python path for Neovim (preserved from original)
vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/envs/neovim/bin/python3"

--[[
================================================================================
EDITOR SETTINGS
================================================================================
--]]

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation settings (2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Smart indentation and case handling
vim.opt.smartindent = true
vim.opt.smartcase = true

-- Line wrapping
vim.opt.wrap = false

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
vim.opt.guicursor = ""

-- Scrolling and navigation
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Performance settings
vim.opt.updatetime = 50

--[[
================================================================================
TERMINAL AND ENVIRONMENT FIXES
================================================================================
--]]

-- Fix for macOS terminal info issue
if vim.fn.has('mac') == 1 then
  vim.env.TERM = vim.env.TERM or 'xterm-256color'
end

-- Concealment level (for markdown, etc.)
vim.opt.conceallevel = 2

--[[
================================================================================
LSP ERROR HANDLING
================================================================================
--]]

-- Handle LSP folding range errors for problematic buffers
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Handle LSP folding range errors",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    
    -- Disable folding range for buffers that might cause URI errors
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_buf_get_option(args.buf, 'buftype')
    
    -- Skip folding for special buffer types or unnamed buffers
    if buftype ~= "" or bufname == "" or bufname:match("^%w+://") then
      if client.server_capabilities.foldingRangeProvider then
        client.server_capabilities.foldingRangeProvider = false
      end
    end
  end,
})

-- Suppress specific LSP error messages
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Filter out the specific folding range URI error
  if type(msg) == "string" and msg:match("unresolvable URI") then
    return
  end
  
  -- Filter out other common LSP noise
  if type(msg) == "string" and (
    msg:match("textDocument/foldingRange request") or
    msg:match("UnhandledPromiseRejection")
  ) then
    return
  end
  
  original_notify(msg, level, opts)
end
