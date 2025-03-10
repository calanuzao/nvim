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

-- Theme Picker (themery.nvim)
require("themery").setup({
  themes = {"catppuccin","one","gruvbox","tokyonight","cyberdream", "rose-pine-main", "rose-pine-moon", "rose-pine-dawn"}, 
  livePreview = true, 
})

-- THEMES
-- ROSE-PINE THEME
require("rose-pine").setup({
  variant = "dawn", -- auto, main, moon, or dawn
  dark_variant = "dawn", -- main, moon, or dawn
  dim_inactive_windows = false,
  extend_background_behind_borders = true,

  enable = {
      terminal = true,
      legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
      migrations = true, -- Handle deprecated options automatically
  },

  styles = {
      bold = true,
      italic = true,
      transparency = false,
  },

  groups = {
      border = "muted",
      link = "iris",
      panel = "surface",

      error = "love",
      hint = "iris",
      info = "foam",
      note = "pine",
      todo = "rose",
      warn = "gold",

      git_add = "foam",
      git_change = "rose",
      git_delete = "love",
      git_dirty = "rose",
      git_ignore = "muted",
      git_merge = "iris",
      git_rename = "pine",
      git_stage = "iris",
      git_text = "rose",
      git_untracked = "subtle",

      h1 = "iris",
      h2 = "foam",
      h3 = "rose",
      h4 = "gold",
      h5 = "pine",
      h6 = "foam",
  },

  palette = {
      -- Override the builtin palette per variant
      -- moon = {
      --     base = '#18191a',
      --     overlay = '#363738',
      -- },
  },

-- NOTE: Highlight groups are extended (merged) by default. Disable this
-- per group via `inherit = false`
  highlight_groups = {
      -- Comment = { fg = "foam" },
      -- StatusLine = { fg = "love", bg = "love", blend = 15 },
      -- VertSplit = { fg = "muted", bg = "muted" },
      -- Visual = { fg = "base", bg = "text", inherit = false },
  },

  before_highlight = function(group, highlight, palette)
      -- Disable all undercurls
      -- if highlight.undercurl then
      --     highlight.undercurl = false
      -- end
      --
      -- Change palette colour
      -- if highlight.fg == palette.pine then
      --     highlight.fg = palette.foam
      -- end
  end,
})

vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")

-- LIGHT THEME
-- require("cyberdream").load("light") -- Select This to fit Vscode Setup
-- vim.cmd("colorscheme cyberdream")   -- Select This to fit Vscode Setup

-- OTHER THEMES
-- vim.o.background = "light" (I don't remember what this does)
-- vim.cmd("colorscheme one")
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd "colorscheme lavender"
-- vim.cmd("colorscheme catppuccin")
-- vim.cmd.colorscheme("darcula-dark")

vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')

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

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
