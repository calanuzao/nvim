-- unicode math simbols are used instead of LaTeX for better compatibility
local M = {}

function M.dsp_formulas()
  local formulas = {
    ["Basic"] = {
      ["Sampling"] = "fₛ = 1/Tₛ (sampling frequency = 1/sampling period)",
      ["Nyquist"] = "fₛ > 2 · fₘₐₓ (sampling frequency must exceed twice max signal frequency)",
      ["Phase"] = "φ = 2πf·t (phase in radians)",
    },
    ["Transforms"] = {
      ["DFT"] = "X[k] = ∑ₙ₌₀ᴺ⁻¹ x[n]·e⁻ʲ²ᵏⁿᵖⁱ/ᴺ",
      ["IDFT"] = "x[n] = (1/N)·∑ₖ₌₀ᴺ⁻¹ X[k]·eʲ²ᵏⁿᵖⁱ/ᴺ",
      ["STFT"] = "X(τ,ω) = ∑ₙ₌₋∞∞ x[n]·w[n-τ]·e⁻ʲωⁿ",
    },
    ["Filters"] = {
      ["LPF (RC)"] = "H(s) = 1/(1+sRC), cutoff = 1/(2πRC)",
      ["HPF (RC)"] = "H(s) = sRC/(1+sRC), cutoff = 1/(2πRC)",
      ["Butterworth"] = "|H(jω)|² = 1/(1+(ω/ωc)²ⁿ)",
      ["Biquad"] = "H(z) = (b₀ + b₁z⁻¹ + b₂z⁻²)/(1 + a₁z⁻¹ + a₂z⁻²)",
    },
    ["Oscillators"] = {
      ["Sine"] = "y(t) = A·sin(2πf·t + φ)",
      ["Complex"] = "e^{jωt} = cos(ωt) + j·sin(ωt)",
    },
    ["Windows"] = {
      ["Rectangular"] = "w[n] = 1, 0 ≤ n ≤ N-1",
      ["Hann"] = "w[n] = 0.5·(1 - cos(2πn/(N-1))), 0 ≤ n ≤ N-1",
      ["Hamming"] = "w[n] = 0.54 - 0.46·cos(2πn/(N-1)), 0 ≤ n ≤ N-1",
      ["Blackman"] = "w[n] = 0.42 - 0.5·cos(2πn/(N-1)) + 0.08·cos(4πn/(N-1))",
    },
    ["Analysis"] = {
      ["SNR"] = "SNR = 10·log₁₀(Pₛᵢₙₐₗ/Pₙₒᵢₛₑ) dB",
      ["THD"] = "THD = √(V₂² + V₃² + ... + Vₙ²)/V₁",
      ["RMSE"] = "RMSE = √((1/N)·∑(yᵢ - ŷᵢ)²)",
    },
    ["Units"] = {
      ["dB"] = "dB = 20·log₁₀(V₂/V₁) or 10·log₁₀(P₂/P₁)",
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
  
  local lines = {}
  
  for category, maps in pairs(formulas) do
    table.insert(lines, "# " .. category)
    table.insert(lines, "")
    
    for name, formula in pairs(maps) do
      table.insert(lines, string.format("%-15s %s", name, formula))
    end
    
    table.insert(lines, "")
    table.insert(lines, "----------------------------------------------------------")
    table.insert(lines, "")
  end
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  
  -- Highlight the headings and formulas
  local line_num = 0
  for _, line in ipairs(lines) do
    if line:match("^# ") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Title", line_num, 0, -1)
    elseif line:match("^%-%-%-%-") then
      vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_num, 0, -1)
    elseif line:match("^%s*[%w%s%(%)]+%s+") then
      -- Highlight formula names
      local name_end = line:find("%s%s")
      if name_end then
        vim.api.nvim_buf_add_highlight(buf, -1, "Identifier", line_num, 0, name_end)
        -- Highlight formula content
        vim.api.nvim_buf_add_highlight(buf, -1, "Special", line_num, name_end, -1)
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