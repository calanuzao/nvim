--[[
================================================================================
CUSTOM COMMANDS MODULE
================================================================================

This module contains all custom commands and their implementations.
All existing commands are preserved with better organization.

Commands included:
- DSP - Digital Signal Processing formulas reference
- Maps - Keymappings cheat sheet
- Specs - Toggle Neovide profiler
- Arduino commands - ArduinoVerify, ArduinoUpload, TestAsync
================================================================================
--]]

local M = {}

--[[
================================================================================
DSP FORMULAS REFERENCE COMMAND
================================================================================
--]]

function M.setup_dsp_command()
  vim.api.nvim_create_user_command('DSP', function()
    require("calanuzao.dsp").dsp_formulas()
  end, { desc = "Show DSP Formulas Cheat Sheet" })
  
  -- Add JUCE/DSP development commands
  vim.api.nvim_create_user_command('JuceDSP', function()
    require("calanuzao.dsp").show_juce_menu()
  end, { desc = "JUCE/DSP Development Menu" })
  
  vim.api.nvim_create_user_command('JuceNew', function()
    require("calanuzao.juce-dsp").create_juce_project()
  end, { desc = "Create New JUCE Project" })
  
  vim.api.nvim_create_user_command('JuceExamples', function()
    require("calanuzao.juce-dsp").show_dsp_examples()
  end, { desc = "Show JUCE DSP Examples" })
  
  vim.api.nvim_create_user_command('JuceBuild', function()
    require("calanuzao.juce-dsp").build_juce_project()
  end, { desc = "Build JUCE Project" })
  
  vim.api.nvim_create_user_command('JuceLearn', function()
    require("calanuzao.juce-dsp").show_learning_resources()
  end, { desc = "Show JUCE Learning Resources" })
  
  vim.api.nvim_create_user_command('DSPSnippet', function()
    require("calanuzao.dsp").insert_dsp_snippet()
  end, { desc = "Insert DSP Code Snippet" })
  
  vim.api.nvim_create_user_command('JuceRef', function()
    require("calanuzao.dsp").show_juce_reference()
  end, { desc = "Show JUCE API Reference" })
end

--[[
================================================================================
KEYMAPPINGS CHEAT SHEET COMMAND
================================================================================
--]]

function M.setup_maps_command()
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
end

--[[
================================================================================
LATEX AUTO-COMPILATION AND COMMANDS
================================================================================
--]]

function M.setup_latex_autocompile()
  -- Create autogroup for LaTeX compilation
  vim.api.nvim_create_augroup("LatexAutocompile", { clear = true })

  -- Auto-compile on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "LatexAutocompile",
    pattern = "*.tex",
    callback = function()
      local file = vim.fn.expand("%:p")
      local dir = vim.fn.fnamemodify(file, ":h")
      local filename = vim.fn.fnamemodify(file, ":t")
      
      -- Use pdflatex with nonstopmode
      local cmd = { "pdflatex", "-interaction=nonstopmode", "-synctex=1", filename }
      
      vim.fn.jobstart(cmd, {
        cwd = dir,
        on_exit = function(_, exit_code, _)
          vim.schedule(function()
            if exit_code == 0 then
              vim.notify("LaTeX: Compilation succeeded!", vim.log.levels.INFO)
            else
              vim.notify("LaTeX: Compilation failed!", vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end,
  })
end

function M.setup_latex_commands()
  -- View PDF with zathura (opens in separate window, auto-refreshes)
  vim.api.nvim_create_user_command('LatexView', function()
    local pdf_file = vim.fn.expand('%:p:r') .. '.pdf'
    
    -- Check if PDF exists
    if vim.fn.filereadable(pdf_file) == 0 then
      vim.notify("PDF not found. Compile first with :LatexCompile or save the file.", vim.log.levels.WARN)
      return
    end
    
    -- Check if zathura is already running for this PDF
    local check_cmd = string.format("pgrep -f 'zathura.*%s'", vim.fn.fnamemodify(pdf_file, ":t"))
    local handle = io.popen(check_cmd)
    local result = handle:read("*a")
    handle:close()
    
    if result and result ~= "" then
      vim.notify("PDF viewer already open. It will auto-refresh on save.", vim.log.levels.INFO)
    else
      -- Open zathura in background (it auto-refreshes when PDF changes)
      vim.fn.jobstart({"zathura", pdf_file}, {detach = true})
      vim.notify("PDF viewer opened. It will auto-refresh on save.", vim.log.levels.INFO)
    end
  end, { desc = "View LaTeX PDF with zathura (auto-refresh on save)" })
  
  -- Compile LaTeX document
  vim.api.nvim_create_user_command('LatexCompile', function()
    vim.cmd('VimtexCompile')
  end, { desc = "Compile LaTeX document" })
  
  -- Stop LaTeX compilation
  vim.api.nvim_create_user_command('LatexStop', function()
    vim.cmd('VimtexStop')
  end, { desc = "Stop LaTeX compilation" })
  
  -- Clean auxiliary files
  vim.api.nvim_create_user_command('LatexClean', function()
    vim.cmd('VimtexClean')
  end, { desc = "Clean LaTeX auxiliary files" })
  
  -- Show compilation errors
  vim.api.nvim_create_user_command('LatexErrors', function()
    vim.cmd('VimtexErrors')
  end, { desc = "Show LaTeX compilation errors" })
  
  -- Show table of contents
  vim.api.nvim_create_user_command('LatexToc', function()
    vim.cmd('VimtexToc')
  end, { desc = "Show LaTeX table of contents" })
  
  -- Show compiler output
  vim.api.nvim_create_user_command('LatexLog', function()
    vim.cmd('VimtexCompileOutput')
  end, { desc = "Show LaTeX compiler output" })
  
  -- Word count
  vim.api.nvim_create_user_command('LatexWordCount', function()
    vim.cmd('VimtexCountWords')
  end, { desc = "Count words in LaTeX document" })
end

--[[
================================================================================
MAIN SETUP FUNCTION
================================================================================
--]]

function M.setup()
  M.setup_dsp_command()
  M.setup_maps_command()
  M.setup_latex_autocompile()
  M.setup_latex_commands()
end

return M
