--[[
================================================================================
LATEX KEYMAPS AND CONFIGURATION
================================================================================
LaTeX-specific keybindings and helper functions (Neil Mehra inspired)
--]]

-- Set up LaTeX-specific keybindings when opening a .tex file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    local opts = { buffer = true, silent = true }
    
    -- VimTeX keybindings (local leader = ,)
    -- ,ll - Start/stop compilation
    -- ,lv - View PDF
    -- ,lc - Clean auxiliary files
    -- ,le - Show errors
    -- ,lt - Table of contents
    
    -- Quick PDF view
    vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", 
      vim.tbl_extend("force", opts, { desc = "View LaTeX PDF" }))
    
    -- Clean auxiliary files
    vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>", 
      vim.tbl_extend("force", opts, { desc = "Clean LaTeX auxiliary files" }))
    
    -- Show compilation errors
    vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<CR>", 
      vim.tbl_extend("force", opts, { desc = "Show LaTeX errors" }))
    
    -- Compile current file manually
    vim.keymap.set("n", "<leader>lm", function()
      local file = vim.fn.expand("%:p")
      local dir = vim.fn.fnamemodify(file, ":h")
      local filename = vim.fn.fnamemodify(file, ":t")
      local cmd = { "pdflatex", "-interaction=nonstopmode", "-synctex=1", filename }
      
      vim.notify("Compiling " .. filename .. "...", vim.log.levels.INFO)
      
      vim.fn.jobstart(cmd, {
        cwd = dir,
        on_exit = function(_, exit_code, _)
          vim.schedule(function()
            if exit_code == 0 then
              vim.notify("LaTeX: Compilation succeeded!", vim.log.levels.INFO)
              -- Try to open PDF after successful compilation
              local pdf = vim.fn.fnamemodify(file, ":r") .. ".pdf"
              if vim.fn.filereadable(pdf) == 1 then
                vim.fn.system(string.format('open -a Skim "%s"', pdf))
              end
            else
              vim.notify("LaTeX: Compilation failed! Check errors.", vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end, vim.tbl_extend("force", opts, { desc = "Manually compile LaTeX" }))
    
    -- Toggle auto-compile on save
    vim.keymap.set("n", "<leader>la", function()
      local group = vim.api.nvim_get_autocmds({
        group = "LatexAutocompile",
        event = "BufWritePost",
        buffer = 0,
      })
      
      if #group > 0 then
        vim.api.nvim_clear_autocmds({
          group = "LatexAutocompile",
          buffer = 0,
        })
        vim.notify("LaTeX: Auto-compile disabled for this buffer", vim.log.levels.INFO)
      else
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = "LatexAutocompile",
          buffer = 0,
          callback = function()
            local file = vim.fn.expand("%:p")
            local dir = vim.fn.fnamemodify(file, ":h")
            local filename = vim.fn.fnamemodify(file, ":t")
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
        vim.notify("LaTeX: Auto-compile enabled for this buffer", vim.log.levels.INFO)
      end
    end, vim.tbl_extend("force", opts, { desc = "Toggle auto-compile on save" }))
    
    -- Set some LaTeX-specific options
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 0  -- Don't conceal LaTeX syntax
  end,
})
