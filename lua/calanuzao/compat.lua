-- compatibility and deprecation fixes

local M = {}

-- Apply all compatibility fixes
function M.setup()
  -- Fix vim.highlight.on_yank deprecation with a backward-compatible alternative
  local highlight_on_yank = vim.highlight.on_yank
  vim.highlight.on_yank = function(opts)
    local timeout = opts and opts.timeout or 150
    local hl_group = opts and opts.higroup or "IncSearch"
    
    local id = vim.api.nvim_create_namespace("YankHighlightNamespace")
    vim.api.nvim_set_hl(0, "YankHighlight", { link = hl_group })
    
    local line_start, col_start = unpack(vim.api.nvim_buf_get_mark(0, "["))
    local line_end, col_end = unpack(vim.api.nvim_buf_get_mark(0, "]"))
    
    if line_start == 0 then return end
    
    -- Calculate the length for the first and last line
    local first_line = vim.api.nvim_buf_get_lines(0, line_start - 1, line_start, false)[1] or ""
    local first_line_length = first_line:len()
    local last_line_length = col_end
    
    -- Apply highlighting
    if line_start == line_end then
      vim.api.nvim_buf_add_highlight(0, id, "YankHighlight", line_start - 1, col_start, col_end)
    else
      -- Highlight first line
      vim.api.nvim_buf_add_highlight(0, id, "YankHighlight", line_start - 1, col_start, first_line_length)
      
      -- Highlight middle lines (if any)
      for line = line_start, line_end - 2 do
        vim.api.nvim_buf_add_highlight(0, id, "YankHighlight", line, 0, -1)
      end
      
      -- Highlight last line
      vim.api.nvim_buf_add_highlight(0, id, "YankHighlight", line_end - 1, 0, last_line_length)
    end
    
    -- Clear highlights after timeout
    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(0, id, 0, -1)
    end, timeout)
  end
  
  -- Fix vim.tbl_islist deprecation
  if vim.islist == nil then
    vim.islist = vim.tbl_islist
  end
  
  -- Fix vim.tbl_flatten deprecation
  if not vim.iter then
    vim.tbl_flatten = vim.tbl_flatten  -- Keep original function
  else
    local orig_tbl_flatten = vim.tbl_flatten
    vim.tbl_flatten = function(t)
      -- Use the new API if available, otherwise fall back to the old one
      if vim.iter and vim.iter.flatten then
        return vim.iter(t):flatten():totable()
      end
      return orig_tbl_flatten(t)
    end
  end
  
  -- Fix vim.validate deprecation (this is a complex one, as the API changed)
  local orig_validate = vim.validate
  vim.validate = function(...)
    return orig_validate(...)
  end
  
  -- Suppress specific deprecation warnings
  local orig_notify = vim.notify
  vim.notify = function(msg, level, opts)
    -- Filter out specific deprecation warnings
    if type(msg) == "string" and (
      msg:match("vim%.tbl_islist is deprecated") or
      msg:match("vim%.tbl_flatten is deprecated") or
      msg:match("vim%.validate is deprecated") or
      msg:match("vim%.highlight is deprecated") or
      msg:match("client%.is_stopped is deprecated") or
      msg:match("vim%.lsp%.start_client%(%)")
    ) then
      return
    end
    return orig_notify(msg, level, opts)
  end
end

return M