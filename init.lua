--[[
NEOVIM CONFIGURATION - ORGANIZED & CONCISE
All functionality preserved, better structured.
Commands: :Maps | :DSP | :Atheme
--]]

-- Set leader keys BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config").setup()

