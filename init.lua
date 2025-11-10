--[[
NEOVIM CONFIGURATION by Chris Lanuza
All functionality preserved, better structured.
Commands: :Maps | :DSP | :Atheme
--]]

-- Set leader keys BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ghostty Tab Info
if vim.fn.getenv("TERM_PROGRAM") == "ghostty" then
  vim.opt.title = true
  vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')}"
end

require("config").setup()
