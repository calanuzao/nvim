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
