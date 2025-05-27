vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/envs/neovim/bin/python3"
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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

require('calanuzao.globals')
require('calanuzao.remaps')
require('calanuzao.options')

-- Add theme persistence
local theme_file = vim.fn.stdpath("data") .. "/last_theme"

-- Theme Switcher 
-- Update your Atheme command with this function

vim.api.nvim_create_user_command('Atheme', function(opts)
  local theme = opts.args
  
  -- Check if theme exists before trying to apply it
  local function theme_exists(name)
    local ok, _ = pcall(vim.cmd, "colorscheme " .. name)
    return ok
  end
  
  -- List of supported themes with their setup functions
  local themes = {
    -- Base Themes
    ["catppuccin"] = function() 
      if theme_exists("catppuccin") then
        vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
        vim.cmd("colorscheme catppuccin") 
        return true
      end
      return false
    end,
    ["catppuccin-latte"] = function() 
      if theme_exists("catppuccin") then
        vim.g.catppuccin_flavour = "latte"
        vim.cmd("colorscheme catppuccin")
        return true  
      end
      return false
    end,
    ["catppuccin-frappe"] = function() 
      if theme_exists("catppuccin") then
        vim.g.catppuccin_flavour = "frappe"
        vim.cmd("colorscheme catppuccin")
        return true  
      end
      return false
    end,
    ["catppuccin-macchiato"] = function() 
      if theme_exists("catppuccin") then
        vim.g.catppuccin_flavour = "macchiato"
        vim.cmd("colorscheme catppuccin")
        return true  
      end
      return false
    end,
    ["catppuccin-mocha"] = function() 
      if theme_exists("catppuccin") then
        vim.g.catppuccin_flavour = "mocha" 
        vim.cmd("colorscheme catppuccin") 
        return true 
      end
      return false
    end,
    ["tokyonight"] = function() 
      if theme_exists("tokyonight") then
        vim.g.tokyonight_style = "night"
        vim.cmd("colorscheme tokyonight") 
        return true
      end
      return false
    end,
    ["tokyonight-day"] = function() 
      if theme_exists("tokyonight") then
        vim.g.tokyonight_style = "day"
        vim.cmd("colorscheme tokyonight")
        return true  
      end
      return false
    end,
    ["tokyonight-storm"] = function() 
      if theme_exists("tokyonight") then
        vim.g.tokyonight_style = "storm"
        vim.cmd("colorscheme tokyonight")
        return true  
      end
      return false
    end,
    ["tokyonight-night"] = function() 
      if theme_exists("tokyonight") then
        vim.g.tokyonight_style = "night"
        vim.cmd("colorscheme tokyonight")
        return true  
      end
      return false
    end,
    ["tokyonight-moon"] = function() 
      if theme_exists("tokyonight") then
        vim.g.tokyonight_style = "moon"
        vim.cmd("colorscheme tokyonight")
        return true  
      end
      return false
    end,
    ["one"] = function() 
      if theme_exists("one") then
        vim.o.background = "dark"
        vim.cmd("colorscheme one") 
        return true 
      end
      return false
    end,
    ["one-light"] = function() 
      if theme_exists("one") then
        vim.o.background = "light"
        vim.cmd("colorscheme one")
        return true  
      end
      return false
    end,
    ["gruvbox"] = function() 
      if theme_exists("gruvbox") then
        vim.o.background = "dark"
        vim.cmd("colorscheme gruvbox") 
        return true 
      end
      return false
    end,
    ["gruvbox-light"] = function() 
      if theme_exists("gruvbox") then
        vim.o.background = "light"
        vim.cmd("colorscheme gruvbox")
        return true  
      end
      return false
    end,
    ["cyberdream"] = function() 
      if theme_exists("cyberdream") then
        pcall(require, "cyberdream")
        require("cyberdream").load("dark")
        vim.cmd("colorscheme cyberdream")
        return true
      end
      return false
    end,
    ["cyberdream-light"] = function()
      if theme_exists("cyberdream") then
        pcall(require, "cyberdream")
        require("cyberdream").load("light")
        vim.cmd("colorscheme cyberdream")
        return true
      end
      return false
    end,
    -- Rose Pine Variants
    ["rose-pine"] = function() 
      if theme_exists("rose-pine") then
        pcall(require, "rose-pine")
        require("rose-pine").setup({
          variant = "main",
          dark_variant = "main",
          styles = {
            transparency = false,
          },
        })
        vim.cmd("colorscheme rose-pine") 
        return true
      end
      return false
    end,
    ["rose-pine-moon"] = function() 
      if theme_exists("rose-pine") then
        pcall(require, "rose-pine")
        require("rose-pine").setup({
          variant = "moon",
          dark_variant = "moon",
          styles = {
            transparency = false,
          },
        })
        vim.cmd("colorscheme rose-pine") 
        return true
      end
      return false
    end,
    ["rose-pine-dawn"] = function() 
      if theme_exists("rose-pine") then
        pcall(require, "rose-pine")
        require("rose-pine").setup({
          variant = "dawn",
          dark_variant = "dawn",
          styles = {
            transparency = false,
          },
        })
        vim.cmd("colorscheme rose-pine") 
        return true
      end
      return false
    end,
    -- Other popular NvChad themes
    ["nightfox"] = function() 
      return theme_exists("nightfox") and vim.cmd("colorscheme nightfox") or false
    end,
    ["duskfox"] = function() 
      return theme_exists("duskfox") and vim.cmd("colorscheme duskfox") or false
    end,
    ["nordfox"] = function() 
      return theme_exists("nordfox") and vim.cmd("colorscheme nordfox") or false
    end,
    ["terafox"] = function() 
      return theme_exists("terafox") and vim.cmd("colorscheme terafox") or false
    end,
    ["carbonfox"] = function() 
      return theme_exists("carbonfox") and vim.cmd("colorscheme carbonfox") or false
    end,
    ["kanagawa"] = function() 
      return theme_exists("kanagawa") and vim.cmd("colorscheme kanagawa") or false
    end,
    ["onedark"] = function() 
      return theme_exists("onedark") and vim.cmd("colorscheme onedark") or false
    end,
    ["dracula"] = function() 
      return theme_exists("dracula") and vim.cmd("colorscheme dracula") or false
    end,
    ["everforest"] = function() 
      if theme_exists("everforest") then
        vim.g.everforest_background = 'hard'
        vim.o.background = "dark"
        vim.cmd("colorscheme everforest") 
        return true
      end
      return false
    end,
    ["everforest-light"] = function() 
      if theme_exists("everforest") then
        vim.g.everforest_background = 'hard'
        vim.o.background = "light"
        vim.cmd("colorscheme everforest")
        return true  
      end
      return false
    end,
    ["nord"] = function() 
      return theme_exists("nord") and vim.cmd("colorscheme nord") or false
    end,
    ["monokai"] = function() 
      return theme_exists("monokai") and vim.cmd("colorscheme monokai") or false
    end,
    ["sonokai"] = function() 
      return theme_exists("sonokai") and vim.cmd("colorscheme sonokai") or false
    end,
  }
  
  -- Switch theme if supported
  if theme == "" then
    -- List available themes if no argument provided
    local theme_list = table.concat(vim.tbl_keys(themes), ", ")
    print("Available themes: " .. theme_list)
    return
  end
  
  if themes[theme] then
    local success = themes[theme]()
    
    if success then
      -- Save the theme choice to file for persistence
      local file = io.open(theme_file, "w")
      if file then
        file:write(theme)
        file:close()
      end
      
      print("Theme switched to " .. theme)
    else
      print("Theme '" .. theme .. "' is defined but the colorscheme is not installed. Please install the theme plugin.")
    end
  else
    print("Theme '" .. theme .. "' not found. Type :Atheme with no arguments to see all themes.")
  end
end, {
  nargs = "?",
  complete = function(ArgLead, CmdLine, CursorPos)
    local themes = {
      "catppuccin", "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha",
      "tokyonight", "tokyonight-day", "tokyonight-storm", "tokyonight-night", "tokyonight-moon",
      "one", "one-light", "gruvbox", "gruvbox-light", 
      "cyberdream", "cyberdream-light", 
      "rose-pine", "rose-pine-moon", "rose-pine-dawn",
      "nightfox", "duskfox", "nordfox", "terafox", "carbonfox",
      "kanagawa", "onedark", "dracula", 
      "everforest", "everforest-light", "nord", "monokai", "sonokai"
    }
    
    local matches = {}
    for _, theme in ipairs(themes) do
      if theme:lower():find(ArgLead:lower()) == 1 then
        table.insert(matches, theme)
      end
    end
    return matches
  end,
})

-- Load last selected theme function
local function load_last_theme()
  local file = io.open(theme_file, "r")
  if file then
    local last_theme = file:read("*all")
    file:close()
    
    -- Get the Atheme command and execute it
    local cmd = vim.api.nvim_get_commands({})["Atheme"]
    if cmd then
      vim.api.nvim_command("Atheme " .. last_theme)
    else
      -- Fallback if command isn't available yet
      vim.cmd("colorscheme rose-pine-dawn")
    end
  else
    -- Default theme if no saved theme found
    vim.cmd("colorscheme rose-pine-dawn")
  end
end

-- Theme Picker (themery.nvim)
require("themery").setup({
  themes = {"catppuccin","one","gruvbox","tokyonight","cyberdream", "rose-pine", "rose-pine-moon", "rose-pine-dawn"}, 
  livePreview = true, 
})

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

-- File Explorer
require'nvim-tree'.setup {
  update_cwd = true,  -- Keep the tree's root updated with the current working directory
  update_focused_file = {
    enable = true,    -- Enable this to let the tree update when switching between files
    update_cwd = true, -- Update the cwd when the file is updated
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,  -- Disable window picker for cleaner behavior
      },
      quit_on_open = false,  -- Keep the tree open when opening files
      resize_window = true,  -- Resize the tree when opening a file
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
    end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
    
    -- Optional: Add a specific keybind for opening in same window
    vim.keymap.set('n', 'o', function()
      local node = api.tree.get_node_under_cursor()
      api.node.open.edit()
    end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
  end,
}

-- Keep your existing toggle keybind
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Optional: Add helpful tab navigation keymaps
-- Tab navigation using Ctrl+j and Ctrl+k
vim.api.nvim_set_keymap('n', '<C-j>', ':tabnext<CR>', { noremap = true, silent = true })     -- Next tab
vim.api.nvim_set_keymap('n', '<C-k>', ':tabprevious<CR>', { noremap = true, silent = true }) -- Previous tab

vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

-- Call this function at the end of initialization to load the last used theme
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    load_last_theme()
  end
})