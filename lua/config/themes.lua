--[[
================================================================================
THEME MANAGEMENT SYSTEM
================================================================================

This module handles all theme-related functionality including:
- Theme switching with the :Atheme command
- Theme persistence across sessions
- Support for 60+ themes with variants
- Automatic theme loading on startup
- Theme picker integration with themery.nvim

All existing theme functionality is preserved.
================================================================================
--]]

local M = {}

-- Theme persistence file path
local theme_file = vim.fn.stdpath("data") .. "/last_theme"

--[[
================================================================================
THEME DEFINITIONS
================================================================================

Each theme is defined with a setup function that handles any special
configuration required before applying the colorscheme.
--]]

local function theme_exists(name)
  local ok, _ = pcall(vim.cmd, "colorscheme " .. name)
  return ok
end

local themes = {
  --[[
  ================================================================================
  CATPPUCCIN THEME FAMILY
  ================================================================================
  --]]
  ["catppuccin"] = function() 
    if theme_exists("catppuccin") then
      vim.g.catppuccin_flavour = "mocha"
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

  --[[
  ================================================================================
  TOKYO NIGHT THEME FAMILY
  ================================================================================
  --]]
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

  --[[
  ================================================================================
  ROSE PINE THEME FAMILY
  ================================================================================
  --]]
  ["rose-pine"] = function() 
    if theme_exists("rose-pine") then
      pcall(require, "rose-pine")
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        styles = { transparency = false }
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
        styles = { transparency = false }
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
        styles = { transparency = false }
      })
      vim.cmd("colorscheme rose-pine") 
      return true
    end
    return false
  end,

  --[[
  ================================================================================
  GRUVBOX THEME FAMILY
  ================================================================================
  --]]
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
  ["gruvbox-material-light"] = function() 
    if theme_exists("gruvbox-material") then
      vim.g.gruvbox_material_background = "medium"
      vim.o.background = "light"
      vim.cmd("colorscheme gruvbox-material") 
      return true
    end
    return false
  end,

  --[[
  ================================================================================
  NIGHTFOX THEME FAMILY
  ================================================================================
  --]]
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

  --[[
  ================================================================================
  ONE THEME FAMILY
  ================================================================================
  --]]
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
  ["onedark"] = function() 
    return theme_exists("onedark") and vim.cmd("colorscheme onedark") or false
  end,
  ["onedarkpro"] = function() 
    return theme_exists("onedarkpro") and vim.cmd("colorscheme onedarkpro") or false
  end,

  --[[
  ================================================================================
  NORD THEME FAMILY
  ================================================================================
  --]]
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
  ["nord-vim"] = function() 
    return theme_exists("nord-vim") and vim.cmd("colorscheme nord") or false
  end,
  ["nordic"] = function() 
    return theme_exists("nordic") and vim.cmd("colorscheme nordic") or false
  end,

  --[[
  ================================================================================
  CYBERDREAM THEME FAMILY
  ================================================================================
  --]]
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

  --[[
  ================================================================================
  EDGE/MELANGE THEME FAMILY
  ================================================================================
  --]]
  ["edge"] = function() 
    if theme_exists("edge") then
      vim.g.edge_style = 'default'
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

  --[[
  ================================================================================
  EVERFOREST THEME FAMILY
  ================================================================================
  --]]
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
  ["everforest-medium"] = function() 
    if theme_exists("everforest") then
      vim.g.everforest_background = 'medium'
      vim.o.background = "dark"
      vim.cmd("colorscheme everforest") 
      return true
    end
    return false
  end,
  ["everforest-soft"] = function() 
    if theme_exists("everforest") then
      vim.g.everforest_background = 'soft'
      vim.o.background = "dark"
      vim.cmd("colorscheme everforest") 
      return true
    end
    return false
  end,

  --[[
  ================================================================================
  KANAGAWA THEME FAMILY
  ================================================================================
  --]]
  ["kanagawa"] = function() 
    return theme_exists("kanagawa") and vim.cmd("colorscheme kanagawa") or false
  end,
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
  ["kanagawa-lotus"] = function() 
    if theme_exists("kanagawa") then
      vim.g.kanagawa_variant = "lotus"
      vim.cmd("colorscheme kanagawa")
      return true
    end
    return false
  end,

  --[[
  ================================================================================
  DRACULA THEME FAMILY
  ================================================================================
  --]]
  ["dracula"] = function() 
    return theme_exists("dracula") and vim.cmd("colorscheme dracula") or false
  end,
  ["dracula-plus"] = function() 
    return theme_exists("dracula_pro") and vim.cmd("colorscheme dracula_pro") or false
  end,
  ["dracula-soft"] = function() 
    return theme_exists("dracula-soft") and vim.cmd("colorscheme dracula-soft") or false
  end,

  --[[
  ================================================================================
  AYU THEME FAMILY
  ================================================================================
  --]]
  ["ayu"] = function() 
    if theme_exists("ayu") then
      vim.g.ayucolor = "dark"
      vim.cmd("colorscheme ayu") 
      return true
    end
    return false
  end,
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

  --[[
  ================================================================================
  SOLARIZED THEME FAMILY
  ================================================================================
  --]]
  ["solarized"] = function() 
    if theme_exists("solarized") then
      vim.o.background = "dark"
      vim.cmd("colorscheme solarized")
      return true
    end
    return false
  end,
  ["solarized-dark"] = function() 
    if theme_exists("solarized") then
      vim.o.background = "dark"
      vim.cmd("colorscheme solarized")
      return true
    end
    return false
  end,
  ["solarized-light"] = function() 
    if theme_exists("solarized") then
      vim.o.background = "light"
      vim.cmd("colorscheme solarized") 
      return true
    end
    return false
  end,
  ["solarized8"] = function() 
    return theme_exists("solarized8") and vim.cmd("colorscheme solarized8") or false
  end,

  --[[
  ================================================================================
  GITHUB THEME FAMILY
  ================================================================================
  --]]
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

  --[[
  ================================================================================
  MATERIAL THEME FAMILY
  ================================================================================
  --]]
  ["material"] = function() 
    return theme_exists("material") and vim.cmd("colorscheme material") or false
  end,
  ["material-theme"] = function() 
    return theme_exists("material") and vim.cmd("colorscheme material") or false
  end,
  ["material-darker"] = function() 
    if theme_exists("material") then
      vim.g.material_style = "darker"
      vim.cmd("colorscheme material") 
      return true
    end
    return false
  end,
  ["material-lighter"] = function() 
    if theme_exists("material") then
      vim.g.material_style = "lighter"
      vim.cmd("colorscheme material") 
      return true
    end
    return false
  end,
  ["material-oceanic"] = function() 
    if theme_exists("material") then
      vim.g.material_style = "oceanic"
      vim.cmd("colorscheme material") 
      return true
    end
    return false
  end,
  ["material-palenight"] = function() 
    if theme_exists("material") then
      vim.g.material_style = "palenight"
      vim.cmd("colorscheme material") 
      return true
    end
    return false
  end,
  ["material-deep-ocean"] = function() 
    if theme_exists("material") then
      vim.g.material_style = "deep ocean"
      vim.cmd("colorscheme material") 
      return true
    end
    return false
  end,

  --[[
  ================================================================================
  MONOKAI THEME FAMILY
  ================================================================================
  --]]
  ["monokai"] = function() 
    return theme_exists("monokai") and vim.cmd("colorscheme monokai") or false
  end,
  ["monokai-pro"] = function() 
    return theme_exists("monokai-pro") and vim.cmd("colorscheme monokai-pro") or false
  end,
  ["monokai-tasty"] = function() 
    return theme_exists("monokai-tasty") and vim.cmd("colorscheme monokai-tasty") or false
  end,

  --[[
  ================================================================================
  SONOKAI THEME FAMILY
  ================================================================================
  --]]
  ["sonokai"] = function() 
    return theme_exists("sonokai") and vim.cmd("colorscheme sonokai") or false
  end,
  ["sonokai-default"] = function() 
    if theme_exists("sonokai") then
      vim.g.sonokai_style = "default"
      vim.cmd("colorscheme sonokai") 
      return true
    end
    return false
  end,
  ["sonokai-atlantis"] = function() 
    if theme_exists("sonokai") then
      vim.g.sonokai_style = "atlantis"
      vim.cmd("colorscheme sonokai") 
      return true
    end
    return false
  end,
  ["sonokai-andromeda"] = function() 
    if theme_exists("sonokai") then
      vim.g.sonokai_style = "andromeda"
      vim.cmd("colorscheme sonokai") 
      return true
    end
    return false
  end,
  ["sonokai-shusia"] = function() 
    if theme_exists("sonokai") then
      vim.g.sonokai_style = "shusia"
      vim.cmd("colorscheme sonokai") 
      return true
    end
    return false
  end,
  ["sonokai-maia"] = function() 
    if theme_exists("sonokai") then
      vim.g.sonokai_style = "maia"
      vim.cmd("colorscheme sonokai") 
      return true
    end
    return false
  end,
  ["sonokai-espresso"] = function() 
    if theme_exists("sonokai") then
      vim.g.sonokai_style = "espresso"
      vim.cmd("colorscheme sonokai") 
      return true
    end
    return false
  end,

  --[[
  ================================================================================
  SPECIALIZED & UNIQUE THEMES
  ================================================================================
  --]]
  ["iceberg"] = function() 
    return theme_exists("iceberg") and vim.cmd("colorscheme iceberg") or false
  end,
  ["monochrome"] = function() 
    return theme_exists("monochrome") and vim.cmd("colorscheme monochrome") or false
  end,
  ["nofrils"] = function() 
    return theme_exists("nofrils") and vim.cmd("colorscheme nofrils-dark") or false
  end,
  ["nofrils-light"] = function() 
    return theme_exists("nofrils") and vim.cmd("colorscheme nofrils-light") or false
  end,
  ["doom-one"] = function() 
    return theme_exists("doom-one") and vim.cmd("colorscheme doom-one") or false
  end,
  ["spacegray"] = function() 
    return theme_exists("Spacegray") and vim.cmd("colorscheme Spacegray") or false
  end,
  ["acme"] = function() 
    return theme_exists("acme") and vim.cmd("colorscheme acme") or false
  end,
  ["vacme"] = function() 
    return theme_exists("vacme") and vim.cmd("colorscheme vacme") or false
  end,
  ["spaceduck"] = function() 
    return theme_exists("spaceduck") and vim.cmd("colorscheme spaceduck") or false
  end,
  ["komau"] = function() 
    return theme_exists("komau") and vim.cmd("colorscheme komau") or false
  end,
  ["challenger-deep"] = function() 
    return theme_exists("challenger_deep") and vim.cmd("colorscheme challenger_deep") or false
  end,
  ["oxocarbon"] = function() 
    return theme_exists("oxocarbon") and vim.cmd("colorscheme oxocarbon") or false
  end,
  ["palenight"] = function() 
    return theme_exists("palenight") and vim.cmd("colorscheme palenight") or false
  end,
  ["moonfly"] = function() 
    return theme_exists("moonfly") and vim.cmd("colorscheme moonfly") or false
  end,
  ["nightfly"] = function() 
    return theme_exists("nightfly") and vim.cmd("colorscheme nightfly") or false
  end,
  ["synthwave84"] = function() 
    return theme_exists("synthwave84") and vim.cmd("colorscheme synthwave84") or false
  end,
  ["zenburn"] = function() 
    return theme_exists("zenburn") and vim.cmd("colorscheme zenburn") or false
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
  ["horizon"] = function() 
    return theme_exists("horizon") and vim.cmd("colorscheme horizon") or false
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

  --[[
  ================================================================================
  CLASSIC & VINTAGE THEMES
  ================================================================================
  --]]
  ["tomorrow"] = function() 
    return theme_exists("tomorrow") and vim.cmd("colorscheme tomorrow") or false
  end,
  ["tomorrow-night"] = function() 
    return theme_exists("tomorrow-night") and vim.cmd("colorscheme tomorrow-night") or false
  end,
  ["tomorrow-night-bright"] = function() 
    return theme_exists("tomorrow-night-bright") and vim.cmd("colorscheme tomorrow-night-bright") or false
  end,
  ["tomorrow-night-blue"] = function() 
    return theme_exists("tomorrow-night-blue") and vim.cmd("colorscheme tomorrow-night-blue") or false
  end,
  ["tomorrow-night-eighties"] = function() 
    return theme_exists("tomorrow-night-eighties") and vim.cmd("colorscheme tomorrow-night-eighties") or false
  end,
  ["base16-default-dark"] = function() 
    return theme_exists("base16-default-dark") and vim.cmd("colorscheme base16-default-dark") or false
  end,
  ["base16-default-light"] = function() 
    return theme_exists("base16-default-light") and vim.cmd("colorscheme base16-default-light") or false
  end,

  --[[
  ================================================================================
  EXPERIMENTAL & MODERN THEMES
  ================================================================================
  --]]
  ["fluoromachine"] = function() 
    return theme_exists("fluoromachine") and vim.cmd("colorscheme fluoromachine") or false
  end,
  ["nebulous"] = function() 
    return theme_exists("nebulous") and vim.cmd("colorscheme nebulous") or false
  end,
  ["bamboo"] = function() 
    return theme_exists("bamboo") and vim.cmd("colorscheme bamboo") or false
  end,
  ["neon"] = function() 
    return theme_exists("neon") and vim.cmd("colorscheme neon") or false
  end,
  ["darkplus"] = function() 
    return theme_exists("darkplus") and vim.cmd("colorscheme darkplus") or false
  end,
  ["lightplus"] = function() 
    return theme_exists("lightplus") and vim.cmd("colorscheme lightplus") or false
  end,
  ["substrata"] = function() 
    return theme_exists("substrata") and vim.cmd("colorscheme substrata") or false
  end,
  ["falcon"] = function() 
    return theme_exists("falcon") and vim.cmd("colorscheme falcon") or false
  end,
  ["codedark"] = function() 
    return theme_exists("codedark") and vim.cmd("colorscheme codedark") or false
  end,
  ["github-nvim-theme"] = function() 
    return theme_exists("github-nvim-theme") and vim.cmd("colorscheme github-nvim-theme") or false
  end,
}

--[[
================================================================================
THEME SWITCHING COMMAND
================================================================================
--]]

function M.switch_theme(theme)
  if theme == "" or theme == nil then
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
end

--[[
================================================================================  
THEME PERSISTENCE
================================================================================
--]]

function M.load_last_theme()
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

--[[
================================================================================
SETUP FUNCTIONS
================================================================================
--]]

function M.setup()
  -- Create the Atheme command
  vim.api.nvim_create_user_command('Atheme', function(opts)
    M.switch_theme(opts.args)
  end, {
    nargs = "?",
    complete = function(ArgLead, CmdLine, CursorPos)
      -- Generate theme names dynamically from the themes table
      local theme_names = vim.tbl_keys(themes)
      table.sort(theme_names)

      local matches = {}
      for _, theme in ipairs(theme_names) do
        if theme:lower():find(ArgLead:lower()) == 1 then
          table.insert(matches, theme)
        end
      end
      return matches
    end,
  })

  -- Setup themery.nvim for theme picker
  pcall(function()
    require("themery").setup({
      themes = {"catppuccin","one","gruvbox","tokyonight","cyberdream", "rose-pine", "rose-pine-moon", "rose-pine-dawn"}, 
      livePreview = true, 
    })
  end)

  -- Load last theme on startup
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      M.load_last_theme()
    end
  })
end

return M
