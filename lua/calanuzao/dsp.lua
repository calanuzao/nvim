-- Unicode representation is used for better compatibility
local M = {}

function M.dsp_formulas()
  local formulas = {
    ["Basic"] = {
      ["Sampling"] = "fs = 1/Ts (sampling frequency = 1/sampling period)",
      ["Nyquist"] = "fs > 2 * fmax (sampling frequency must exceed twice max signal frequency)",
      ["Phase"] = "φ = 2πf·t (phase in radians)",
    },
    ["Transforms"] = {
      ["DFT"] = "X[k] = Σ(n=0 to N-1) x[n]·e^(-j2πkn/N)",
      ["IDFT"] = "x[n] = (1/N)·Σ(k=0 to N-1) X[k]·e^(j2πkn/N)",
      ["STFT"] = "X(τ,ω) = Σ x[n]·w[n-τ]·e^(-jωn)",
    },
    ["Filters"] = {
      ["LPF (RC)"] = "H(s) = 1/(1+sRC), cutoff = 1/(2πRC)",
      ["HPF (RC)"] = "H(s) = sRC/(1+sRC), cutoff = 1/(2πRC)",
      ["Butterworth"] = "|H(jω)|² = 1/(1+(ω/ωc)^2n)",
      ["Biquad"] = "H(z) = (b0 + b1·z^-1 + b2·z^-2)/(1 + a1·z^-1 + a2·z^-2)",
    },
    ["Oscillators"] = {
      ["Sine"] = "y(t) = A·sin(2πf·t + φ)",
      ["Complex"] = "e^(jωt) = cos(ωt) + j·sin(ωt)",
    },
    ["Windows"] = {
      ["Rectangular"] = "w[n] = 1, 0 ≤ n ≤ N-1",
      ["Hann"] = "w[n] = 0.5·(1 - cos(2πn/(N-1))), 0 ≤ n ≤ N-1",
      ["Hamming"] = "w[n] = 0.54 - 0.46·cos(2πn/(N-1)), 0 ≤ n ≤ N-1",
      ["Blackman"] = "w[n] = 0.42 - 0.5·cos(2πn/(N-1)) + 0.08·cos(4πn/(N-1))",
    },
    ["Analysis"] = {
      ["SNR"] = "SNR = 10·log₁₀(Psignal/Pnoise) dB",
      ["THD"] = "THD = √(V2² + V3² + ... + Vn²)/V1",
      ["RMSE"] = "RMSE = √((1/N)·Σ(yi - ŷi)²)",
    },
    ["Units"] = {
      ["dB"] = "dB = 20·log₁₀(V2/V1) or 10·log₁₀(P2/P1)",
      ["dBFS"] = "dBFS = 20·log₁₀(|V|/Vfull_scale)",
      ["dBSPL"] = "dBSPL = 20·log₁₀(p/pref), pref = 20 μPa",
    }
  }
  
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " DSP Formulas Cheat Sheet ",
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
  table.insert(lines, center_text("DSP FORMULAS REFERENCE", width))
  table.insert(lines, "")
  table.insert(lines, center_text(string.rep("─", width - 20), width))
  table.insert(lines, "")
  
  for category, maps in pairs(formulas) do
    -- Center the category headers
    table.insert(lines, center_text("# " .. category, width))
    table.insert(lines, "")
    
    -- Create a table-like format for the formulas
    for name, formula in pairs(maps) do
      -- Don't center the actual formulas - keep them aligned for readability
      table.insert(lines, string.format("    %-15s %s", name, formula))
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
  
  -- Highlight the headings and formulas
  local line_num = 0
  for _, line in ipairs(lines) do
    if line:match("^%s*# ") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Title", line_num, 0, -1)
    elseif line:match("^%s*─") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_num, 0, -1)
    elseif line:match("Press q or") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_num, 0, -1)
    elseif line:match("^%s*DSP FORMULAS") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Special", line_num, 0, -1)
    elseif line:match("^%s+[%w%s%(%)]+%s+") then
      -- Find the position where the formula name ends and the formula begins
      local content_start = line:find("%S") or 0
      local content = line:sub(content_start)
      local name_end = content:find("%s%s")
      
      if name_end then
        -- Highlight formula name (add content_start to adjust for leading spaces)
        vim.api.nvim_buf_add_highlight(buf, -1, "Identifier", line_num, content_start, content_start + name_end)
        -- Highlight formula content
        vim.api.nvim_buf_add_highlight(buf, -1, "Special", line_num, content_start + name_end, -1)
      end
    end
    line_num = line_num + 1
  end
  
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
  
  -- Close with q or Escape
  map_key('q', '<cmd>close<CR>')
  map_key('<Esc>', '<cmd>close<CR>')
end

return M