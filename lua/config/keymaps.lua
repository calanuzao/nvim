--[[
================================================================================
ORGANIZED KEYMAPS CONFIGURATION
================================================================================

This file organizes all keybindings by category for better maintainability.
All existing keybindings are preserved - this is just better organization.

Categories:
- Core Navigation
- File Operations
- Buffer Management
- Search and Replace
- Arduino Development
- Testing and Debugging
- Obsidian Notes
- Window Management
- Visual Mode
- Terminal
- Miscellaneous
================================================================================
--]]

local M = {}

--[[
================================================================================
CORE NAVIGATION AND EDITING
================================================================================
--]]

-- Exit insert mode without hitting Esc
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Select all
vim.keymap.set("n", "==", "gg<S-v>G", { desc = "Select all text" })

-- Keep window centered when scrolling
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Enhanced line movement
vim.keymap.set({"n", "o", "x"}, "<s-h>", "^", { desc = "Jump to beginning of line" })
vim.keymap.set({"n", "o", "x"}, "<s-l>", "g_", { desc = "Jump to end of line" })

-- Jump between markdown headers
vim.keymap.set("n", "gj", [[/^##\+ .*<CR>]], { buffer = true, silent = true, desc = "Next markdown header" })
vim.keymap.set("n", "gk", [[?^##\+ .*<CR>]], { buffer = true, silent = true, desc = "Previous markdown header" })

--[[
================================================================================
FILE OPERATIONS
================================================================================
--]]

-- Oil file manager
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Copy file paths
vim.keymap.set("n", "<leader>cf", "<cmd>let @+ = expand(\"%\")<CR>", { desc = "Copy file name" })
vim.keymap.set("n", "<leader>cp", "<cmd>let @+ = expand(\"%:p\")<CR>", { desc = "Copy file path" })

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

--[[
================================================================================
BUFFER MANAGEMENT
================================================================================
--]]

-- Close buffer
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Close buffer without closing split
vim.keymap.set("n", "<leader>w", "<cmd>bp|bd #<CR>", { desc = "Close buffer; retain split" })

-- Get out of Q
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

--[[
================================================================================
CLIPBOARD OPERATIONS
================================================================================
--]]

-- Paste without overwriting register in visual mode
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Copy text to system clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Delete text to black hole register
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete to black hole register" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete to black hole register" })

--[[
================================================================================
SEARCH AND REPLACE
================================================================================
--]]

-- Replace word under cursor across entire buffer
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" })

-- Search for highlighted text in buffer (visual mode)
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Search for highlighted text" })

--[[
================================================================================
QUICKFIX AND LOCATION LISTS
================================================================================
--]]

-- Navigate between quickfix items
vim.keymap.set("n", "<leader>h", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>;", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

-- Navigate between location list items
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

--[[
================================================================================
ARDUINO DEVELOPMENT
================================================================================
--]]

-- Arduino Verify and Upload
vim.keymap.set('n', '<leader>av', ':ArduinoVerify<CR>', { noremap = true, silent = true, desc = "Arduino verify" })
vim.keymap.set('n', '<leader>au', ':ArduinoUpload<CR>', { noremap = true, silent = true, desc = "Arduino upload" })

--[[
================================================================================
TESTING WITH NEOTEST
================================================================================
--]]

-- Run Tests
vim.keymap.set("n", "<leader>t", "<cmd>lua require('neotest').run.run()<CR>", { desc = "Run test under cursor" })
vim.keymap.set("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Run test file" })
vim.keymap.set("n", "<leader>td", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<CR>", { desc = "Run current test directory" })
vim.keymap.set("n", "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<CR>", { desc = "Toggle test output panel" })
vim.keymap.set("n", "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", { desc = "Run last test" })
vim.keymap.set("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = "Toggle test summary" })

--[[
================================================================================
JUCE/DSP AUDIO DEVELOPMENT
================================================================================
--]]

-- JUCE Development keybindings
vim.keymap.set("n", "<leader>jm", "<cmd>JuceDSP<CR>", { desc = "JUCE/DSP Development Menu" })
vim.keymap.set("n", "<leader>jn", "<cmd>JuceNew<CR>", { desc = "Create New JUCE Project" })
vim.keymap.set("n", "<leader>je", "<cmd>JuceExamples<CR>", { desc = "Show JUCE DSP Examples" })
vim.keymap.set("n", "<leader>jb", "<cmd>JuceBuild<CR>", { desc = "Build JUCE Project" })
vim.keymap.set("n", "<leader>jl", "<cmd>JuceLearn<CR>", { desc = "Show JUCE Learning Resources" })
vim.keymap.set("n", "<leader>ji", "<cmd>DSPSnippet<CR>", { desc = "Insert DSP Code Snippet" })
vim.keymap.set("n", "<leader>jr", "<cmd>JuceRef<CR>", { desc = "Show JUCE API Reference" })

-- DSP Formulas (existing functionality)
vim.keymap.set("n", "<leader>df", "<cmd>DSP<CR>", { desc = "Show DSP Formulas" })

-- Audio processing file type detection
vim.api.nvim_create_augroup("JuceDSPFiletype", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "JuceDSPFiletype",
  pattern = { "*.jucer", "*.jucerproj" },
  callback = function()
    vim.bo.filetype = "xml"
  end,
})

-- JUCE project file detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "JuceDSPFiletype",
  pattern = { "*AudioProcessor*.cpp", "*AudioProcessor*.h" },
  callback = function()
    -- Auto-setup JUCE environment for audio processor files
    vim.schedule(function()
      require("calanuzao.juce-dsp").setup_juce_environment()
    end)
  end,
})

--[[
================================================================================
OBSIDIAN NOTES MANAGEMENT
================================================================================
--]]

vim.keymap.set("n", "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Toggle checkbox" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert template" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian app" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show links" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create new note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch note" })

--[[
================================================================================
WINDOW AND SPLIT MANAGEMENT
================================================================================
--]]

-- Resize with arrows
vim.keymap.set("n", "<C-S-Down>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-S-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

--[[
================================================================================
VISUAL MODE OPERATIONS
================================================================================
--]]

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left (keep selection)" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right (keep selection)" })

-- Move block up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

--[[
================================================================================
TERMINAL MODE
================================================================================
--]]

-- Exit terminal mode shortcut
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--[[
================================================================================
MISCELLANEOUS
================================================================================
--]]

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Source current file" })

-- Dismiss Noice messages
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss notifications" })

-- Open Zoxide telescope extension
vim.keymap.set("n", "<leader>Z", "<cmd>Zi<CR>", { desc = "Open Zoxide directory jumper" })

-- Jump to plugin management file
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/plugins.lua<CR>", { desc = "Open plugins.lua" })

return M
