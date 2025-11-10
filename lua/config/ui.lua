--[[
================================================================================
UI CONFIGURATION MODULE
================================================================================

This module handles all UI-related configuration including:
- Neovide GUI settings
- File explorer (nvim-tree) configuration
- Tab navigation keybindings
- Visual enhancements and transparency
- Status line and highlights

================================================================================
--]]

local M = {}

--[[
================================================================================
NEOVIDE CONFIGURATION
================================================================================
--]]

function M.setup_neovide()
  if not vim.g.neovide then
    return -- Only configure if running in Neovide
  end

  -- Font settings
  vim.o.guifont = "FiraCode Nerd Font:h20"

  -- Cursor settings - disabled animation for performance
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_animation_length = 0
  
  -- Alternative: Enable cursor animation effects (commented out)
  -- vim.g.neovide_cursor_animation_length = 0.02
  -- vim.g.neovide_cursor_trail_length = 0.2
  -- vim.g.neovide_cursor_vfx_mode = "sonicboom"

  -- Set cursor to always be a beam in all modes
  vim.o.guicursor = "n-v-c-i-ci-ve-r-cr-o-sm:ver25"

  -- Transparency settings
  vim.g.neovide_opacity = 1 

  -- Floating blur (macOS/Linux only)
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  -- Window padding
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10

  -- Performance settings
  vim.g.neovide_profiler = false               -- Disable profiler by default 
  vim.g.neovide_profiler_size = 24             -- Font size for profiler
  vim.g.neovide_profiler_position = "topright" -- Position of the profiler
  vim.g.neovide_refresh_rate = 60              -- Limit refresh rate to save resources
  vim.g.neovide_no_idle = true                 -- Reduces CPU usage when idle
  vim.g.neovide_fullscreen = false             -- Toggle fullscreen mode

  -- Custom command to toggle the profiler
  vim.api.nvim_create_user_command('Specs', function()
    vim.g.neovide_profiler = not vim.g.neovide_profiler
    print("Neovide profiler " .. (vim.g.neovide_profiler and "enabled" or "disabled"))
  end, { desc = "Toggle Neovide performance profiler" })
end

--[[
================================================================================
FILE EXPLORER CONFIGURATION
================================================================================
--]]

function M.setup_file_explorer()
  -- Configure nvim-tree
  pcall(function()
    require('nvim-tree').setup({
      update_cwd = true,  
      update_focused_file = {
        enable = true,    
        update_cwd = true, 
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,  
          },
          quit_on_open = false,  
          resize_window = true,  
        },
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        
        -- Override default Enter behavior to open files in new tabs
        vim.keymap.set('n', '<CR>', function()
          local node = api.tree.get_node_under_cursor()
          if node.type == 'file' then
            api.node.open.tab()
          else
            api.node.open.edit()
          end
        end, { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "Open file/folder" })
        
        -- Specific keybind for opening in same window
        vim.keymap.set('n', 'o', function()
          local node = api.tree.get_node_under_cursor()
          api.node.open.edit()
        end, { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "Open in current window" })
      end,
    })
  end)

  -- File explorer toggle keybinding
  vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { 
    noremap = true, 
    silent = true,
    desc = "Toggle file explorer"
  })
end

--[[
================================================================================
TAB NAVIGATION
================================================================================
--]]

function M.setup_tab_navigation()
  -- Tab navigation using Ctrl+j and Ctrl+k
  vim.api.nvim_set_keymap('n', '<C-j>', ':tabnext<CR>', { 
    noremap = true, 
    silent = true,
    desc = "Next tab"
  })
  
  vim.api.nvim_set_keymap('n', '<C-k>', ':tabprevious<CR>', { 
    noremap = true, 
    silent = true,
    desc = "Previous tab"
  })
end

--[[
================================================================================
VISUAL ENHANCEMENTS
================================================================================
--]]

function M.setup_visual_enhancements()
  -- Configure illuminate highlighting (word under cursor)
  vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
  vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
  vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')

  -- Transparency settings for normal background
  vim.cmd([[
    highlight Normal guibg=none
    highlight NonText guibg=none
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none
  ]])
end

--[[
================================================================================
AUTOCOMMANDS FOR UI
================================================================================
--]]

function M.setup_autocommands()
  local ui_group = vim.api.nvim_create_augroup("ui_enhancements", { clear = true })

  -- Start terminal in insert mode
  vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Auto enter insert mode when opening a terminal",
    group = ui_group,
    pattern = "*",
    callback = function()
      -- Wait briefly just in case we immediately switch out of the buffer (e.g. Neotest)
      vim.defer_fn(function()
        if vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal' then
          vim.cmd([[startinsert]])
        end
      end, 100)
    end,
  })

  -- Highlight yanked text
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text briefly",
    group = ui_group,
    pattern = "*",
    callback = function() 
      vim.highlight.on_yank({ timeout = 200 }) 
    end
  })
end

--[[
================================================================================
ARDUINO DEVELOPMENT UI
================================================================================
--]]

function M.setup_arduino_ui()
  -- Arduino Configuration
  vim.cmd([[
    command! TestAsync execute 'AsyncRun echo "AsyncRun is working!"'

    command! ArduinoVerify execute 'AsyncRun -raw -post=checktime echo "Starting verify..." && arduino-cli compile --fqbn esp32:esp32:esp32s3 -v %:p:h'
    command! ArduinoUpload execute 'AsyncRun -raw -post=checktime echo "Starting upload..." && arduino-cli upload -p /dev/cu.usbmodem1101 --fqbn esp32:esp32:esp32s3 -v %:p:h'
    
    augroup AsyncRunQuickfix
      autocmd!
      autocmd User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
    augroup END
    
    let g:asyncrun_status = ''
    set statusline+=%{g:asyncrun_status}
  ]])
end

--[[
================================================================================
MAIN SETUP FUNCTION
================================================================================
--]]

function M.setup()
  M.setup_neovide()
  M.setup_file_explorer()
  M.setup_tab_navigation()
  M.setup_visual_enhancements()
  M.setup_autocommands()
  M.setup_arduino_ui()
end

return M
