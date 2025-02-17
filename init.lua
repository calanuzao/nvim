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

-- Lavender Theme Configuration
--vim.g.lavender = {
--  transparent = {
--    background = false,
--    float      = false,
--    popup      = false,
--    sidebar    = false,
--  },
--  contrast = true,

--  italic = {
--    comments  = true,
--    functions = true,
--    keywords  = false,
--    variables = false,
 -- },

 -- signs = false,

 -- overrides = {
 --   theme = {
  --    NormalFoo = { fg = "fg", bg = "decepticon_dark", bold = true },
  --    NormalBar = { fg = "#7B68EE", bg = "#110022", ctermfg = 99, ctermbg = 54 },
  --    NormalBaz = { fg = "decepticon_blue", ctermfg = "decepticon_purple" },
  --    Normal = { fg = "#E6E6FA", bg = "#110022", ctermfg = 189, ctermbg = 54 },
  --  },
  --  colors = {
  --    hex = {
  --      decepticon_dark = "#1E0030",    -- Deep base purple
  --      decepticon_blue = "#4D6CFA",    -- Electric blue (top of logo)
  --      decepticon_purple = "#9B30FF",  -- Bright purple (bottom of logo)
  --      neon_accent = "#7B68EE",        -- Metallic highlight
  --    },
  --    cterm = {
  --      decepticon_blue = 69,     -- Bright blue
  --      decepticon_purple = 99,   -- Deep purple
  --    },
  --  },
  --},
--}

-- Themes
vim.o.background = "light" 
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