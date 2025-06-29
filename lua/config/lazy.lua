--[[
================================================================================
LAZY.NVIM PLUGIN MANAGER SETUP
================================================================================

This file initializes the lazy.nvim plugin manager.
Preserved from original configuration.
================================================================================
--]]

-- Setup lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy with plugins
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})
