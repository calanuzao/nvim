--[[
================================================================================
JUCE/DSP AUDIO DEVELOPMENT PLUGIN
================================================================================
This plugin provides tools and utilities for JUCE/Audio DSP development:
- JUCE project templates
- Audio DSP code snippets
- Build system integration
- Learning resources and examples
- Real-time audio debugging tools
================================================================================
--]]

return {
  -- Enhanced C++ support for JUCE development
  {
    "p00f/clangd_extensions.nvim",
    ft = { "cpp", "c" },
    config = function()
      require("clangd_extensions").setup({
        server = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--compile-commands-dir=build", -- For JUCE projects
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        extensions = {
          autoSetHints = true,
          inlay_hints = {
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
        },
      })
    end,
  },

  -- CMake support for JUCE projects
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cpp", "c", "cmake" },
    config = function()
      require("cmake-tools").setup({
        cmake_command = "cmake",
        cmake_build_directory = "build",
        cmake_build_directory_prefix = "cmake_build_", -- when cmake_build_directory is set to "", this option will be activated
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_options = {},
        cmake_console_size = 10, -- cmake output window height
        cmake_show_console = "always", -- "always", "only_on_error"
        cmake_dap_configuration = { name = "cpp", type = "codelldb", request = "launch" },
        cmake_executor = {
          name = "terminal",
          default_opts = {
            terminal = {
              split_direction = "horizontal",
              split_size = 11,
            },
          },
        },
        cmake_runner = {
          name = "terminal",
          default_opts = {
            terminal = {
              split_direction = "horizontal", 
              split_size = 11,
            },
          },
        },
      })
    end,
  },

  -- Project templates and file generation
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["i"] = {},
              ["n"] = {},
            },
          },
        },
      })
      require("telescope").load_extension("file_browser")
    end,
  },

  -- Enhanced syntax highlighting for audio DSP
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "cpp", "c", "cmake", "json", "yaml" })
      end
    end,
  },

  -- Code snippets for JUCE/DSP
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- JUCE DSP Snippets
      ls.add_snippets("cpp", {
        s("juce_processor", {
          t({
            "#include <JuceHeader.h>",
            "",
            "class " .. "AudioProcessor : public juce::AudioProcessor",
            "{",
            "public:",
            "    AudioProcessor() = default;",
            "    ~AudioProcessor() override = default;",
            "",
            "    void prepareToPlay(double sampleRate, int samplesPerBlock) override",
            "    {",
            "        spec.maximumBlockSize = samplesPerBlock;",
            "        spec.sampleRate = sampleRate;",
            "        spec.numChannels = getTotalNumOutputChannels();",
            "",
          }),
          i(1, "        // Initialize your DSP objects here"),
          t({
            "",
            "    }",
            "",
            "    void processBlock(juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages) override",
            "    {",
            "        juce::ScopedNoDenormals noDenormals;",
            "        auto totalNumInputChannels = getTotalNumInputChannels();",
            "        auto totalNumOutputChannels = getTotalNumOutputChannels();",
            "",
            "        for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)",
            "            buffer.clear(i, 0, buffer.getNumSamples());",
            "",
          }),
          i(2, "        // Your audio processing code here"),
          t({
            "",
            "    }",
            "",
            "    void releaseResources() override {}",
            "",
            "    const juce::String getName() const override { return JucePlugin_Name; }",
            "    bool acceptsMidi() const override { return false; }",
            "    bool producesMidi() const override { return false; }",
            "    bool isMidiEffect() const override { return false; }",
            "    double getTailLengthSeconds() const override { return 0.0; }",
            "",
            "private:",
            "    juce::dsp::ProcessSpec spec;",
          }),
          i(3, "    // Your DSP objects here"),
          t({
            "",
            "    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(AudioProcessor)",
            "};",
          }),
        }),

        s("juce_filter", {
          t("juce::dsp::IIR::Filter<float> "),
          i(1, "filter"),
          t({
            ";",
            "",
            "// In prepareToPlay:",
          }),
          i(2, "filter"),
          t(".prepare(spec);"),
          t({
            "",
            "*",
          }),
          i(2),
          t(".coefficients = juce::dsp::IIR::Coefficients<float>::make"),
          i(3, "LowPass"),
          t("("),
          i(4, "sampleRate, cutoffFrequency"),
          t(");"),
          t({
            "",
            "",
            "// In processBlock:",
          }),
          i(2),
          t(".process(juce::dsp::ProcessContextReplacing<float>(buffer));"),
        }),

        s("juce_oscillator", {
          t("juce::dsp::Oscillator<float> "),
          i(1, "oscillator"),
          t({
            ";",
            "",
            "// In prepareToPlay:",
          }),
          i(1),
          t(".prepare(spec);"),
          t({
            "",
          }),
          i(1),
          t(".initialise([](float x) { return std::sin(x); }); // Sine wave"),
          t({
            "",
          }),
          i(1),
          t(".setFrequency("),
          i(2, "440.0f"),
          t({
            ");",
            "",
            "// In processBlock:",
          }),
          i(1),
          t(".process(juce::dsp::ProcessContextReplacing<float>(buffer));"),
        }),

        s("juce_gain", {
          t("juce::dsp::Gain<float> "),
          i(1, "gain"),
          t({
            ";",
            "",
            "// In prepareToPlay:",
          }),
          i(1),
          t(".prepare(spec);"),
          t({
            "",
          }),
          i(1),
          t(".setGainDecibels("),
          i(2, "0.0f"),
          t({
            ");",
            "",
            "// In processBlock:",
          }),
          i(1),
          t(".process(juce::dsp::ProcessContextReplacing<float>(buffer));"),
        }),
      })
    end,
  },
}
