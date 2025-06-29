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

-- JUCE/DSP Integration
function M.show_juce_menu()
  local juce_dsp = require('calanuzao.juce-dsp')
  
  local options = {
    "Create New JUCE Project",
    "Show DSP Examples", 
    "Build Current Project",
    "Learning Resources",
    "DSP Formulas (existing)",
    "Setup JUCE Environment"
  }
  
  vim.ui.select(options, {
    prompt = "JUCE/DSP Development:",
  }, function(choice)
    if not choice then return end
    
    if choice == "Create New JUCE Project" then
      juce_dsp.create_juce_project()
    elseif choice == "Show DSP Examples" then
      juce_dsp.show_dsp_examples()
    elseif choice == "Build Current Project" then
      juce_dsp.build_juce_project()
    elseif choice == "Learning Resources" then
      juce_dsp.show_learning_resources()
    elseif choice == "DSP Formulas (existing)" then
      M.dsp_formulas()
    elseif choice == "Setup JUCE Environment" then
      juce_dsp.setup_juce_environment()
    end
  end)
end

-- Audio DSP code snippets for quick insertion
function M.insert_dsp_snippet()
  local snippets = {
    ["JUCE Audio Processor Template"] = [[
class MyAudioProcessor : public juce::AudioProcessor
{
public:
    MyAudioProcessor() = default;
    
    void prepareToPlay(double sampleRate, int samplesPerBlock) override
    {
        spec.maximumBlockSize = samplesPerBlock;
        spec.sampleRate = sampleRate;
        spec.numChannels = getTotalNumOutputChannels();
        
        -- Initialize DSP objects here
    }
    
    void processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer&) override
    {
        juce::ScopedNoDenormals noDenormals;
        
        -- Your processing code here
    }
    
private:
    juce::dsp::ProcessSpec spec;
};]],

    ["Low-pass Filter"] = [[
juce::dsp::IIR::Filter<float> lowPassFilter;

// In prepareToPlay:
lowPassFilter.prepare(spec);
*lowPassFilter.coefficients = *juce::dsp::IIR::Coefficients<float>::makeLowPass(sampleRate, cutoffFreq);

// In processBlock:
lowPassFilter.process(juce::dsp::ProcessContextReplacing<float>(buffer));]],

    ["Oscillator"] = [[
juce::dsp::Oscillator<float> oscillator;

// In prepareToPlay:
oscillator.prepare(spec);
oscillator.initialise([](float x) { return std::sin(x); }); // Sine wave
oscillator.setFrequency(440.0f);

// In processBlock:
oscillator.process(juce::dsp::ProcessContextReplacing<float>(buffer));]],

    ["Gain Control"] = [[
juce::dsp::Gain<float> gain;

// In prepareToPlay:
gain.prepare(spec);
gain.setGainDecibels(0.0f);

// In processBlock:
gain.process(juce::dsp::ProcessContextReplacing<float>(buffer));]],

    ["Reverb Effect"] = [[
juce::dsp::Reverb reverb;

// In prepareToPlay:
reverb.prepare(spec);
juce::dsp::Reverb::Parameters params;
params.roomSize = 0.5f;
params.damping = 0.5f;
params.wetLevel = 0.3f;
params.dryLevel = 0.7f;
reverb.setParameters(params);

// In processBlock:
reverb.process(juce::dsp::ProcessContextReplacing<float>(buffer));]]
  }
  
  vim.ui.select(vim.tbl_keys(snippets), {
    prompt = "Select DSP snippet to insert:",
  }, function(choice)
    if not choice then return end
    
    local snippet = snippets[choice]
    local lines = vim.split(snippet, "\n")
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    print("Inserted: " .. choice)
  end)
end

-- Quick reference for JUCE classes and functions
function M.show_juce_reference()
  local reference = {
    ["Core Classes"] = {
      "AudioProcessor - Base class for audio processing",
      "AudioBuffer<float> - Container for audio samples", 
      "dsp::ProcessSpec - Setup specifications for DSP",
      "dsp::ProcessContext - Processing context wrapper",
      "dsp::AudioBlock - Non-owning audio data wrapper"
    },
    ["DSP Filters"] = {
      "dsp::IIR::Filter<float> - IIR filter implementation",
      "dsp::FIR::Filter<float> - FIR filter implementation", 
      "dsp::Coefficients - Filter coefficient management",
      "makeLowPass() - Low-pass filter coefficients",
      "makeHighPass() - High-pass filter coefficients",
      "makeBandPass() - Band-pass filter coefficients"
    },
    ["DSP Generators"] = {
      "dsp::Oscillator<float> - Wavetable oscillator",
      "dsp::WaveShaper<float> - Waveshaping processor",
      "dsp::NoiseGate<float> - Noise gate implementation"
    },
    ["DSP Effects"] = {
      "dsp::Reverb - Reverb effect processor",
      "dsp::Chorus<float> - Chorus effect",
      "dsp::Phaser<float> - Phaser effect", 
      "dsp::Compressor<float> - Dynamic range compressor",
      "dsp::Limiter<float> - Peak limiter",
      "dsp::Gain<float> - Gain control"
    },
    ["Utility Classes"] = {
      "dsp::DelayLine<float> - Delay line implementation",
      "dsp::DryWetMixer<float> - Dry/wet signal mixing",
      "dsp::Oversampling<float> - Oversampling processor",
      "dsp::FFT - Fast Fourier Transform"
    }
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
    title = " JUCE DSP Reference ",
    title_pos = "center",
  })
  
  local lines = {"", "JUCE DSP Quick Reference", "=" .. string.rep("=", 25), ""}
  
  for category, items in pairs(reference) do
    table.insert(lines, "# " .. category)
    table.insert(lines, "")
    for _, item in ipairs(items) do
      table.insert(lines, "  • " .. item)
    end
    table.insert(lines, "")
  end
  
  table.insert(lines, "Press q or <Esc> to close")
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  
  -- Key mappings
  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set('n', 'q', '<cmd>close<CR>', opts)
  vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', opts)
end

return M