-- space bar is leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load compatibility layer to fix deprecation warnings
require("calanuzao.compat").setup()

-- python path for neovim
vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/envs/neovim/bin/python3"

-- lazy.nvim setup
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

-- initialize lazy with plugins
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

-- Load Modules
require('calanuzao.globals')
require('calanuzao.remaps')
require('calanuzao.options')
require('calanuzao.dsp')

-- Add theme persistence
local theme_file = vim.fn.stdpath("data") .. "/last_theme"

-- Theme Switcher 
vim.api.nvim_create_user_command('Atheme', function(opts)
  local theme = opts.args
  
  -- Check if theme exists before trying to apply it
  local function theme_exists(name)
    local ok, _ = pcall(vim.cmd, "colorscheme " .. name)
    return ok
  end
  
  -- =============================================
  -- LIST OF SUPPORTED THEMES WITH SETUP FUNCTIONS
  -- =============================================
  local themes = {
    -- Iceberg Theme
    ["iceberg"] = function() 
      return theme_exists("iceberg") and vim.cmd("colorscheme iceberg") or false
    end,
    
    -- Edge Theme
    ["edge"] = function() 
      if theme_exists("edge") then
        vim.g.edge_style = 'default' -- default, aura, neon
        vim.o.background = "dark"
        vim.cmd("colorscheme edge") 
        return true
      end
      return false
    end,
    ["edge-light"] = function() 
      if theme_exists("edge") then
        vim.o.background = "light"
        vim.cmd("colorscheme edge") 
        return true
      end
      return false
    end,
    
    -- Melange Theme
    ["melange"] = function() 
      if theme_exists("melange") then
        vim.o.background = "dark"
        vim.cmd("colorscheme melange") 
        return true
      end
      return false
    end,
    ["melange-light"] = function() 
      if theme_exists("melange") then
        vim.o.background = "light"
        vim.cmd("colorscheme melange") 
        return true
      end
      return false
    end,
    
    -- OneDarkPro Theme
    ["onedarkpro"] = function() 
      if theme_exists("onedarkpro") then
        vim.cmd("colorscheme onedarkpro") 
        return true
      end
      return false
    end,
    
    -- Nord-Vim Theme (different from nord)
    ["nord-vim"] = function() 
      return theme_exists("nord-vim") and vim.cmd("colorscheme nord") or false
    end,
    
    -- Nordic Theme
    ["nordic"] = function() 
      return theme_exists("nordic") and vim.cmd("colorscheme nordic") or false
    end,
    
    -- Monochrome Theme
    ["monochrome"] = function() 
      return theme_exists("monochrome") and vim.cmd("colorscheme monochrome") or false
    end,
    
    -- Nofrils Theme
    ["nofrils"] = function() 
      return theme_exists("nofrils") and vim.cmd("colorscheme nofrils-dark") or false
    end,
    ["nofrils-light"] = function() 
      return theme_exists("nofrils") and vim.cmd("colorscheme nofrils-light") or false
    end,
    
    -- Doom One Theme
    ["doom-one"] = function() 
      return theme_exists("doom-one") and vim.cmd("colorscheme doom-one") or false
    end,
    
    -- Spacegray Theme
    ["spacegray"] = function() 
      return theme_exists("Spacegray") and vim.cmd("colorscheme Spacegray") or false
    end,
    
    -- Acme Theme
    ["acme"] = function() 
      return theme_exists("acme") and vim.cmd("colorscheme acme") or false
    end,
    
    -- Vacme Theme
    ["vacme"] = function() 
      return theme_exists("vacme") and vim.cmd("colorscheme vacme") or false
    end,
    
    -- Spaceduck Theme
    ["spaceduck"] = function() 
      return theme_exists("spaceduck") and vim.cmd("colorscheme spaceduck") or false
    end,
    
    -- Komau Theme
    ["komau"] = function() 
      return theme_exists("komau") and vim.cmd("colorscheme komau") or false
    end,
    
    -- Challenger Deep Theme
    ["challenger-deep"] = function() 
      return theme_exists("challenger_deep") and vim.cmd("colorscheme challenger_deep") or false
    end,
    -- Catppuccin Variants
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
    
    -- Tokyo Night Variants
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
    ["tokyo-night"] = function() 
      return theme_exists("tokyo-night") and vim.cmd("colorscheme tokyo-night") or false
    end,
    ["tokyo-night-storm"] = function() 
      return theme_exists("tokyo-night") and vim.cmd("colorscheme tokyo-night-storm") or false
    end,
    
    -- One Theme Variants
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
    
    -- Gruvbox Variants
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
    
    -- Cyberdream Variants
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
    
    -- Nightfox Family
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
    ["dawnfox"] = function() 
      return theme_exists("dawnfox") and vim.cmd("colorscheme dawnfox") or false
    end,
    ["dayfox"] = function() 
      return theme_exists("dayfox") and vim.cmd("colorscheme dayfox") or false
    end,
    
    -- Other Popular Themes
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
    ["nord-light"] = function() 
      if theme_exists("nord") then
        vim.o.background = "light"
        vim.cmd("colorscheme nord")
        return true  
      end
      return false
    end,
    ["monokai"] = function() 
      return theme_exists("monokai") and vim.cmd("colorscheme monokai") or false
    end,
    ["monokai-pro"] = function() 
      return theme_exists("monokai-pro") and vim.cmd("colorscheme monokai-pro") or false
    end,
    ["sonokai"] = function() 
      return theme_exists("sonokai") and vim.cmd("colorscheme sonokai") or false
    end,
    
    -- Solarized Themes
    ["solarized-dark"] = function() 
      return theme_exists("solarized") and vim.cmd("colorscheme solarized") or false
    end,
    ["solarized-light"] = function() 
      if theme_exists("solarized") then
        vim.o.background = "light"
        vim.cmd("colorscheme solarized") 
        return true
      end
      return false
    end,
    
    -- GitHub Themes
      ["github-dark"] = function() 
    if theme_exists("github_dark") then
      vim.cmd("colorscheme github_dark")
      return true
    elseif theme_exists("github-theme") then
      vim.g.github_dark_sidebar = true
      vim.cmd("colorscheme github_dark")
      return true
    end
    return false
  end,

  ["github-light"] = function() 
    if theme_exists("github_light") then
      vim.cmd("colorscheme github_light")
      return true
    elseif theme_exists("github-theme") then
      -- Try alternative name format
      vim.g.github_light_sidebar = true
      vim.cmd("colorscheme github_light")
      return true
    end
    return false
  end,

  ["github-dark-dimmed"] = function() 
    if theme_exists("github_dark_dimmed") then
      vim.cmd("colorscheme github_dark_dimmed")
      return true
    elseif theme_exists("github-theme") then
      vim.cmd("colorscheme github_dark_dimmed")
      return true
    end
    return false
  end,
    
    -- Ayu Themes
    ["ayu-dark"] = function() 
      if theme_exists("ayu") then
        vim.g.ayucolor = "dark"
        vim.cmd("colorscheme ayu") 
        return true
      end
      return false
    end,
    ["ayu-light"] = function() 
      if theme_exists("ayu") then
        vim.g.ayucolor = "light"
        vim.cmd("colorscheme ayu") 
        return true
      end
      return false
    end,
    ["ayu-mirage"] = function() 
      if theme_exists("ayu") then
        vim.g.ayucolor = "mirage"
        vim.cmd("colorscheme ayu") 
        return true
      end
      return false
    end,
    
    -- Material Theme
    ["material-theme"] = function() 
      return theme_exists("material") and vim.cmd("colorscheme material") or false
    end,
    
    -- Gruvbox Material Variants
    ["gruvbox-material"] = function() 
      if theme_exists("gruvbox-material") then
        vim.g.gruvbox_material_background = "medium"
        vim.o.background = "dark"
        vim.cmd("colorscheme gruvbox-material") 
        return true
      end
      return false
    end,
    ["gruvbox-material-hard"] = function() 
      if theme_exists("gruvbox-material") then
        vim.g.gruvbox_material_background = "hard"
        vim.o.background = "dark"
        vim.cmd("colorscheme gruvbox-material") 
        return true
      end
      return false
    end,
    
    -- *Fly Themes
    ["palenight"] = function() 
      return theme_exists("palenight") and vim.cmd("colorscheme palenight") or false
    end,
    ["moonfly"] = function() 
      return theme_exists("moonfly") and vim.cmd("colorscheme moonfly") or false
    end,
    ["nightfly"] = function() 
      return theme_exists("nightfly") and vim.cmd("colorscheme nightfly") or false
    end,
    
    -- Additional Dracula
    ["dracula-plus"] = function() 
      return theme_exists("dracula_pro") and vim.cmd("colorscheme dracula_pro") or false
    end,
    
    -- Synthwave
    ["synthwave84"] = function() 
      return theme_exists("synthwave84") and vim.cmd("colorscheme synthwave84") or false
    end,
    
    -- Kanagawa Variants
    ["kanagawa-dragon"] = function() 
      if theme_exists("kanagawa") then
        vim.g.kanagawa_variant = "dragon"
        vim.cmd("colorscheme kanagawa")
        return true
      end
      return false
    end,
    ["kanagawa-wave"] = function() 
      if theme_exists("kanagawa") then
        vim.g.kanagawa_variant = "wave"
        vim.cmd("colorscheme kanagawa")
        return true
      end
      return false
    end,
    
    -- Oxocarbon
    ["oxocarbon"] = function() 
      return theme_exists("oxocarbon") and vim.cmd("colorscheme oxocarbon") or false
    end,
    
    -- Tomorrow Night Variants
    ["tomorrow-night"] = function() 
      return theme_exists("tomorrow-night") and vim.cmd("colorscheme tomorrow-night") or false
    end,
    ["tomorrow-night-bright"] = function() 
      return theme_exists("tomorrow-night-bright") and vim.cmd("colorscheme tomorrow-night-bright") or false
    end,
    
    -- Zenburn
    ["zenburn"] = function() 
      return theme_exists("zenburn") and vim.cmd("colorscheme zenburn") or false
    end,
    
    ["acme"] = function() 
      return theme_exists("acme") and vim.cmd("colorscheme acme") or false
    end,
    ["afterglow"] = function() 
      return theme_exists("afterglow") and vim.cmd("colorscheme afterglow") or false
    end,
    ["alabaster"] = function() 
      return theme_exists("alabaster") and vim.cmd("colorscheme alabaster") or false
    end,
    ["alabaster-dark"] = function() 
      return theme_exists("alabaster-dark") and vim.cmd("colorscheme alabaster-dark") or false
    end,
    ["argonaut"] = function() 
      return theme_exists("argonaut") and vim.cmd("colorscheme argonaut") or false
    end,
    ["horizon-dark"] = function() 
      return theme_exists("horizon") and vim.cmd("colorscheme horizon") or false
    end,
    ["hyper"] = function() 
      return theme_exists("hyper") and vim.cmd("colorscheme hyper") or false
    end,
    ["moonlight"] = function() 
      return theme_exists("moonlight") and vim.cmd("colorscheme moonlight") or false
    end,
    ["vscode"] = function() 
      return theme_exists("vscode") and vim.cmd("colorscheme vscode") or false
    end,
    ["wombat"] = function() 
      return theme_exists("wombat") and vim.cmd("colorscheme wombat") or false
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
    return nil
end, {
  nargs = "?",
  complete = function(ArgLead, CmdLine, CursorPos)
    
    -- ====================================================
    -- AUTO-COMPLETION LIST FOR THEMES (KEEP IN SYNC ABOVE)
    -- ====================================================
    local themes = {
      "catppuccin", "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha",
      "tokyonight", "tokyonight-day", "tokyonight-storm", "tokyonight-night", "tokyonight-moon",
      "tokyo-night", "tokyo-night-storm",
      "one", "one-light", "gruvbox", "gruvbox-light", 
      "cyberdream", "cyberdream-light", 
      "rose-pine", "rose-pine-moon", "rose-pine-dawn",
      "nightfox", "duskfox", "nordfox", "terafox", "carbonfox", "dawnfox", "dayfox",
      "kanagawa", "kanagawa-dragon", "kanagawa-wave", 
      "onedark", "dracula", "dracula-plus", 
      "everforest", "everforest-light", 
      "nord", "nord-light", "nord-vim",
      "monokai", "monokai-pro", "sonokai",
      "solarized-dark", "solarized-light", 
      "github-dark", "github-light", "github-dark-dimmed",
      "ayu-dark", "ayu-light", "ayu-mirage",
      "material-theme", 
      "gruvbox-material", "gruvbox-material-hard",
      "palenight", "moonfly", "nightfly",
      "synthwave84", "oxocarbon", 
      "tomorrow-night", "tomorrow-night-bright",
      "zenburn", "spacegray",
      "acme", "afterglow", "alabaster", "alabaster-dark", "argonaut",
      "horizon-dark", "hyper", "moonlight", "vscode", "wombat",
      "iceberg", "edge", "edge-light", "melange", "melange-light",
      "onedarkpro", "nordic", "monochrome", "nofrils", "nofrils-light",
      "doom-one", "vacme", "spaceduck", "komau", "challenger-deep"
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
-- ctrl+n toggles the file explorer sidebar
-- ctrl+j and ctrl+k navigate between tbs
require'nvim-tree'.setup {
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
    
    -- override default Enter behavior to open files in new tabs
    vim.keymap.set('n', '<CR>', function()
      local node = api.tree.get_node_under_cursor()
      if node.type == 'file' then
        api.node.open.tab()
      else
        api.node.open.edit()
      end
    end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
    
    -- specific keybind for opening in same window
    vim.keymap.set('n', 'o', function()
      local node = api.tree.get_node_under_cursor()
      api.node.open.edit()
    end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
  end,
}

-- toggle keybind
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

-- loads the last used theme
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    load_last_theme()
  end
})

---------------------------------------------------------------
-- NEOVIDE CONFIGURATION
---------------------------------------------------------------

-- Font
vim.o.guifont = "FiraCode Nerd Font:h20"

-- Disable cursor animation/effects
vim.g.neovide_cursor_vfx_mode = ""
vim.g.neovide_cursor_animation_length = 0

-- Enable cursor animation effects
-- vim.g.neovide_cursor_animation_length = 0.02
-- vim.g.neovide_cursor_trail_length = 0.2
-- vim.g.neovide_cursor_vfx_mode = "sonicboom"

-- Set cursor to always be a beam in all modes
vim.o.guicursor = "n-v-c-i-ci-ve-r-cr-o-sm:ver25"

-- Transparency
vim.g.neovide_opacity = 0.9

-- Floating blur (macOS/Linux only)
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- Padding
vim.g.neovide_padding_top = 8
vim.g.neovide_padding_bottom = 8
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10

-- Performance Debugging
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
end, {})
