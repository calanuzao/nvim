--[[
================================================================================
NEOVIM CONFIGURATION ENTRY POINT
================================================================================

This file initializes the core Neovim configuration in an organized manner.
All existing functionality is preserved - this is just better organization.

Configuration Structure:
- config/core.lua      - Basic Neovim settings and options
- config/keymaps.lua   - All keybindings organized by category  
- config/themes.lua    - Theme management and persistence
- config/ui.lua        - UI configuration (Neovide, file explorer, etc.)
- config/commands.lua  - Custom commands and autocommands
- calanuzao/           - Legacy modules (preserved for compatibility)
- plugins/             - Plugin configurations

Author: Your Neovim Configuration
Date: Reorganized for better maintainability
================================================================================
--]]

local M = {}

-- Load core configuration modules in order
function M.setup()
  -- Load compatibility layer first (preserves existing setup)
  require("calanuzao.compat").setup()
  
  -- Core settings and options
  require("config.core")
  
  -- Initialize lazy.nvim plugin manager
  require("config.lazy")
  
  -- Load keymaps after plugins are available
  require("config.keymaps")
  
  -- Theme management
  require("config.themes").setup()
  
  -- UI configuration
  require("config.ui").setup()
  
  -- Custom commands and autocommands
  require("config.commands").setup()
  
  -- Legacy modules (preserved for compatibility)
  require('calanuzao.globals')
  require('calanuzao.remaps')
  require('calanuzao.options')
  require('calanuzao.dsp')
  
  -- Initialize JUCE/DSP environment
  local ok, juce_dsp = pcall(require, 'calanuzao.juce-dsp')
  if ok then
    -- Setup JUCE environment for supported file types
    vim.api.nvim_create_augroup("JuceDSPInit", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = "JuceDSPInit",
      pattern = { "cpp", "c" },
      callback = function()
        -- Only setup for audio-related files
        local filename = vim.fn.expand("%:t"):lower()
        if filename:match("audio") or filename:match("dsp") or filename:match("juce") or filename:match("processor") then
          juce_dsp.setup_juce_environment()
        end
      end,
    })
  end
end

return M
