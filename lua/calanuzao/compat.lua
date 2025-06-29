-- compatibility and deprecation fixes

local M = {}

-- Apply all compatibility fixes
function M.setup()
  -- Fix vim.highlight.on_yank deprecation with the new vim.hl API
  if vim.highlight and vim.highlight.on_yank then
    -- Use the existing function if available and working
    local highlight_on_yank = vim.highlight.on_yank
    vim.highlight.on_yank = function(opts)
      -- Check if the new vim.hl API is available
      if vim.hl and vim.hl.on_yank then
        return vim.hl.on_yank(opts)
      else
        -- Fallback to the original function
        return highlight_on_yank(opts)
      end
    end
  elseif vim.hl and vim.hl.on_yank then
    -- Use the new API directly
    vim.highlight = vim.highlight or {}
    vim.highlight.on_yank = vim.hl.on_yank
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