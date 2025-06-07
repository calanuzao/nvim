-- Arduino Verify and Upload
vim.keymap.set('n', '<leader>av', ':ArduinoVerify<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>au', ':ArduinoUpload<CR>', { noremap = true, silent = true })

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Jump between markdown headers
vim.keymap.set("n", "gj", [[/^##\+ .*<CR>]], { buffer = true, silent = true })
vim.keymap.set("n", "gk", [[?^##\+ .*<CR>]], { buffer = true, silent = true })

-- Exit insert mode without hitting Esc
vim.keymap.set("i", "jj", "<Esc>", { desc = "Esc" })

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$")

-- Select all
vim.keymap.set("n", "==", "gg<S-v>G")

-- Keep window centered when going up/down
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')

-- Copy text to " register
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank into \" register" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank into \" register" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank into \" register" })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete into \" register" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete into \" register" })

-- Get out Q
vim.keymap.set("n", "Q", "<nop>")

-- close buffer
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close Buffer" })

-- Close buffer without closing split
vim.keymap.set("n", "<leader>w", "<cmd>bp|bd #<CR>", { desc = "Close Buffer; Retain Split" })

-- Navigate between quickfix items
vim.keymap.set("n", "<leader>h", "<cmd>cnext<CR>zz", { desc = "Forward qfixlist" })
vim.keymap.set("n", "<leader>;", "<cmd>cprev<CR>zz", { desc = "Backward qfixlist" })

-- Navigate between location list items
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Forward location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Backward location list" })

-- Replace word under cursor across entire buffer
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" })

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Jump to plugin management file
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/plugins.lua<CR>", { desc = "Jump to configuration file" })

-- Run Tests
vim.keymap.set("n", "<leader>t", "<cmd>lua require('neotest').run.run()<CR>", { desc = "Run Test" })
vim.keymap.set("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
  { desc = "Run Test File" })
vim.keymap.set("n", "<leader>td", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<CR>",
  { desc = "Run Current Test Directory" })
vim.keymap.set("n", "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<CR>",
  { desc = "Toggle Test Output Panel" })
vim.keymap.set("n", "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", { desc = "Run Last Test" })
vim.keymap.set("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = "Toggle Test Summary" })

-- Debug Tests
vim.keymap.set("n", "<leader>dt", "<cmd>DapContinue<CR>", { desc = "Start Debugging" })
vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Start Debugging" })
vim.keymap.set("n", "<leader>dso", "<cmd>DapStepOver<CR>", { desc = "Step Over" })
vim.keymap.set("n", "<leader>dsi", "<cmd>DapStepInto<CR>", { desc = "Step Into" })
vim.keymap.set("n", "<leader>dsu", "<cmd>DapStepOut<CR>", { desc = "Step Out" })
vim.keymap.set("n", "<leader>dst", "<cmd>DapStepTerminate<CR>", { desc = "Stop Debugger" })
vim.keymap.set("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Toggle Breakpoint Condition" })
vim.keymap.set("n", "<leader>E", "<cmd>lua require'dap'.set_exception_breakpoints()<CR>",
  { desc = "Toggle Exception Breakpoint" })
vim.keymap.set("n", "<leader>dr",
  "<cmd>lua require'dapui'.float_element('repl', { width = 100, height = 40, enter = true })<CR>",
  { desc = "Show DAP REPL" })
vim.keymap.set("n", "<leader>ds",
  "<cmd>lua require'dapui'.float_element('scopes', { width = 150, height = 50, enter = true })<CR>",
  { desc = "Show DAP Scopes" })
vim.keymap.set("n", "<leader>df",
  "<cmd>lua require'dapui'.float_element('stacks', { width = 150, height = 50, enter = true })<CR>",
  { desc = "Show DAP Stacks" })
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dapui'.float_element('breakpoints', { enter = true })<CR>",
  { desc = "Show DAP breakpoints" })
vim.keymap.set("n", "<leader>do", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debug Last Test" })

-- Copy file paths
vim.keymap.set("n", "<leader>cf", "<cmd>let @+ = expand(\"%\")<CR>", { desc = "Copy File Name" })
vim.keymap.set("n", "<leader>cp", "<cmd>let @+ = expand(\"%:p\")<CR>", { desc = "Copy File Path" })

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Source current file" })

-- Dismiss Noice Message
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", {desc = "Dismiss Noice Message"})

-- Open Zoxide telescope extension
vim.keymap.set("n", "<leader>Z", "<cmd>Zi<CR>", { desc = "Open Zoxide" })

-- Resize with arrows
vim.keymap.set("n", "<C-S-Down>", ":resize +2<CR>", { desc = "Resize Horizontal Split Down" })
vim.keymap.set("n", "<C-S-Up>", ":resize -2<CR>", { desc = "Resize Horizontal Split Up" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize Vertical Split Down" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize Vertical Split Up" })

-- Obsidian
vim.keymap.set("n", "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Obsidian Check Checkbox" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show ObsidianBacklinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show ObsidianLinks" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick Switch" })

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({"n", "o", "x"}, "<s-h>", "^", { desc = "Jump to beginning of line" })
vim.keymap.set({"n", "o", "x"}, "<s-l>", "g_", { desc = "Jump to end of line" })

-- Move block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Search for highlighted text in buffer
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Search for highlighted text" })

-- Exit terminal mode shortcut
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>")

-- Autocommands
vim.api.nvim_create_augroup("custom_buffer", { clear = true })

-- start terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Auto enter insert mode when opening a terminal",
  group = "custom_buffer",
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

-- highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = "custom_buffer",
  pattern  = "*",
  callback = function() vim.highlight.on_yank { timeout = 200 } end
})

---------------------------------------------------------------
-- REMAPPS COMMANDS
---------------------------------------------------------------
-- DSP formulas reference command (esc -> :dsp)
vim.api.nvim_create_user_command('DSP', function()
  require("calanuzao.dsp").dsp_formulas()
end, { desc = "Show DSP Formulas Cheat Sheet" })

-- Maps reference command (esc -> :maps)
vim.api.nvim_create_user_command('Maps', function()
  local mappings = {
    ["File Operations"] = {
      ["-"] = "Open parent directory (Oil)",
      ["<leader>cf"] = "Copy file name",
      ["<leader>cp"] = "Copy file path",
      ["<leader>x"] = "Make file executable",
    },
    ["Buffers"] = {
      ["<leader>q"] = "Close buffer",
      ["<leader>w"] = "Close buffer, keep split",
    },
    ["Search/Replace"] = {
      ["<leader>s"] = "Replace word under cursor",
      ["//"] = "Search for visual selection",
      ["n/N"] = "Next/prev search result (centered)",
    },
    ["Navigation"] = {
      ["<leader>h"] = "Next quickfix item",
      ["<leader>;"] = "Previous quickfix item",
      ["<leader>k"] = "Next location list item",
      ["<leader>j"] = "Previous location list item",
      ["<C-d>/<C-u>"] = "Scroll down/up (centered)",
      ["<s-h>/<s-l>"] = "Jump to start/end of line",
      ["gj/gk"] = "Next/prev markdown header",
    },
    ["Arduino"] = {
      ["<leader>av"] = "Verify Arduino code",
      ["<leader>au"] = "Upload Arduino code",
    },
    ["Testing"] = {
      ["<leader>t"] = "Run test under cursor",
      ["<leader>tf"] = "Run test file",
      ["<leader>td"] = "Run test directory",
      ["<leader>tp"] = "Toggle test output panel",
      ["<leader>tl"] = "Run last test",
      ["<leader>ts"] = "Toggle test summary",
    },
    ["Debugging"] = {
      ["<leader>dt/dc"] = "Start debugging",
      ["<leader>dso"] = "Step over",
      ["<leader>dsi"] = "Step into",
      ["<leader>dsu"] = "Step out",
      ["<leader>dst"] = "Stop debugging",
      ["<leader>b"] = "Toggle breakpoint",
      ["<leader>B"] = "Conditional breakpoint",
      ["<leader>E"] = "Toggle exception breakpoint",
      ["<leader>dr"] = "Show REPL",
      ["<leader>ds"] = "Show scopes",
      ["<leader>df"] = "Show stacks",
      ["<leader>db"] = "Show breakpoints",
      ["<leader>do"] = "Toggle DAP UI",
      ["<leader>dl"] = "Debug last test",
    },
    ["Clipboard"] = {
      ["<leader>y"] = "Yank to system clipboard",
      ["<leader>Y"] = "Yank line to system clipboard",
      ["<leader>d"] = "Delete without copying",
      ["p"] = "Paste without overwriting (visual)",
      ["=="] = "Select all",
    },
    ["Obsidian"] = {
      ["<leader>oc"] = "Toggle checkbox",
      ["<leader>ot"] = "Insert template",
      ["<leader>oo"] = "Open in Obsidian",
      ["<leader>ob"] = "Show backlinks",
      ["<leader>ol"] = "Show links",
      ["<leader>on"] = "New note",
      ["<leader>os"] = "Search notes",
      ["<leader>oq"] = "Quick switch note",
    },
    ["Window/Layout"] = {
      ["<C-S-Down>"] = "Increase window height",
      ["<C-S-Up>"] = "Decrease window height",
      ["<C-Left>"] = "Decrease window width",
      ["<C-Right>"] = "Increase window width",
    },
    ["Terminal"] = {
      ["<C-t>"] = "Exit terminal mode",
    },
    ["Visual Mode"] = {
      ["</>>"] = "Indent left/right (keep selection)",
      ["J/K"] = "Move selection down/up",
    },
    ["Misc"] = {
      ["<leader>Z"] = "Zoxide directory jump",
      ["<leader>nd"] = "Dismiss notifications",
      ["<leader><leader>"] = "Source current file",
      ["<leader>vpp"] = "Open plugins.lua",
      ["jj"] = "Exit insert mode",
    },
  }
  
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Keymappings Cheat Sheet ",
    title_pos = "center",
  })
  
  -- Function to center text in available width
  local function center_text(text, available_width)
    local text_length = vim.fn.strdisplaywidth(text)
    local padding = math.max(0, math.floor((available_width - text_length) / 2))
    return string.rep(" ", padding) .. text
  end
  
  local lines = {}
  
  -- Add centered title
  table.insert(lines, "")
  table.insert(lines, center_text("KEYMAPPINGS CHEAT SHEET", width))
  table.insert(lines, "")
  table.insert(lines, center_text(string.rep("─", width - 20), width))
  table.insert(lines, "")
  
  for category, maps in pairs(mappings) do
    -- Center the category headers
    table.insert(lines, center_text("# " .. category, width))
    table.insert(lines, "")
    
    -- Create a table-like format for the mappings
    for key, desc in pairs(maps) do
      -- Don't center the actual mappings - keep them aligned for readability
      table.insert(lines, string.format("    %-20s %s", key, desc))
    end
    
    table.insert(lines, "")
    table.insert(lines, center_text(string.rep("─", width - 20), width))
    table.insert(lines, "")
  end
  
  -- Add centered footer
  table.insert(lines, center_text("Press q or <Esc> to close", width))
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  
  -- Make window scrollable with standard keys
  local function map_key(key, action)
    vim.api.nvim_buf_set_keymap(buf, 'n', key, action, {nowait = true, noremap = true, silent = true})
  end
  
  map_key('j', 'gj')
  map_key('k', 'gk')
  map_key('<Down>', 'gj')
  map_key('<Up>', 'gk')
  map_key('<C-d>', '<C-d>zz')
  map_key('<C-u>', '<C-u>zz')
  map_key('<C-f>', '<C-f>zz')
  map_key('<C-b>', '<C-b>zz')
  map_key('G', 'Gzz')
  map_key('gg', 'ggzz')
  
  -- Highlight the headings
  local line_num = 0
  for _, line in ipairs(lines) do
    if line:match("^%s*# ") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Title", line_num, 0, -1)
    elseif line:match("^%s*─") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_num, 0, -1)
    elseif line:match("Press q or") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_num, 0, -1)
    elseif line:match("^%s*KEYMAPPINGS") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Special", line_num, 0, -1)
    end
    line_num = line_num + 1
  end
  
  -- Close with q or Escape
  map_key('q', '<cmd>close<CR>')
  map_key('<Esc>', '<cmd>close<CR>')
end, { desc = "Show keymaps cheat sheet" })