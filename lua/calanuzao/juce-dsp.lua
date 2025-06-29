--[[
================================================================================
JUCE/DSP AUDIO DEVELOPMENT MODULE
================================================================================
This module provides JUCE/Audio DSP development tools and learning resources.
It extends the existing DSP module with practical JUCE development capabilities.
================================================================================
--]]

local M = {}

-- JUCE Project Templates
M.juce_templates = {
  ["Audio Plugin"] = {
    description = "Basic JUCE Audio Plugin template",
    files = {
      ["CMakeLists.txt"] = function(name)
        return string.format([[
cmake_minimum_required(VERSION 3.15)
project(%s VERSION 0.0.1)

# Add JUCE
add_subdirectory(JUCE)

# Create plugin target
juce_add_plugin(%s
    COMPANY_NAME "YourCompany"
    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS FALSE
    COPY_PLUGIN_AFTER_BUILD TRUE
    PLUGIN_MANUFACTURER_CODE Juce
    PLUGIN_CODE %s
    FORMATS AU VST3 Standalone
    PRODUCT_NAME "%s")

# Add source files
target_sources(%s
    PRIVATE
        Source/PluginProcessor.cpp
        Source/PluginEditor.cpp)

# Link libraries
target_link_libraries(%s
    PRIVATE
        juce::juce_audio_utils
        juce::juce_dsp
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
]], name, name, name:sub(1,4):upper(), name, name, name)
      end,
      
      ["Source/PluginProcessor.h"] = function(name)
        return string.format([[
#pragma once

#include <JuceHeader.h>

class %sAudioProcessor : public juce::AudioProcessor
{
public:
    %sAudioProcessor();
    ~%sAudioProcessor() override;

    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

   #ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
   #endif

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

private:
    // DSP Objects
    juce::dsp::ProcessSpec spec;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (%sAudioProcessor)
};
]], name, name, name, name)
      end,
      
      ["Source/PluginProcessor.cpp"] = function(name)
        return string.format([[
#include "PluginProcessor.h"
#include "PluginEditor.h"

%sAudioProcessor::%sAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
                       )
#endif
{
}

%sAudioProcessor::~%sAudioProcessor()
{
}

const juce::String %sAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool %sAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool %sAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool %sAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double %sAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int %sAudioProcessor::getNumPrograms()
{
    return 1;
}

int %sAudioProcessor::getCurrentProgram()
{
    return 0;
}

void %sAudioProcessor::setCurrentProgram (int index)
{
}

const juce::String %sAudioProcessor::getProgramName (int index)
{
    return {};
}

void %sAudioProcessor::changeProgramName (int index, const juce::String& newName)
{
}

void %sAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    spec.maximumBlockSize = samplesPerBlock;
    spec.sampleRate = sampleRate;
    spec.numChannels = getTotalNumOutputChannels();
    
    // Initialize your DSP objects here
}

void %sAudioProcessor::releaseResources()
{
    // Release any resources here
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool %sAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;

    return true;
}
#endif

void %sAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    // Your audio processing code goes here
    // Example: Apply gain
    // for (int channel = 0; channel < totalNumInputChannels; ++channel)
    // {
    //     auto* channelData = buffer.getWritePointer (channel);
    //     for (int sample = 0; sample < buffer.getNumSamples(); ++sample)
    //         channelData[sample] *= 0.5f; // Reduce volume by half
    // }
}

bool %sAudioProcessor::hasEditor() const
{
    return true;
}

juce::AudioProcessorEditor* %sAudioProcessor::createEditor()
{
    return new %sAudioProcessorEditor (*this);
}

void %sAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
}

void %sAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
}

juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new %sAudioProcessor();
}
]], name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name, name)
      end
    }
  },
  
  ["DSP Effect"] = {
    description = "Audio effect with DSP processing",
    files = {
      ["main.cpp"] = function(name)
        return string.format([[
#include <JuceHeader.h>
#include <iostream>

class %sEffect
{
public:
    %sEffect() = default;
    
    void prepare(const juce::dsp::ProcessSpec& spec)
    {
        sampleRate = spec.sampleRate;
        
        // Prepare your DSP chain here
        processorChain.prepare(spec);
    }
    
    template<typename ProcessContext>
    void process(const ProcessContext& context)
    {
        processorChain.process(context);
    }
    
    void reset()
    {
        processorChain.reset();
    }
    
private:
    double sampleRate = 44100.0;
    
    // DSP Chain - modify as needed
    enum ChainPositions
    {
        Filter,
        Gain
    };
    
    using ProcessorChain = juce::dsp::ProcessorChain<
        juce::dsp::IIR::Filter<float>,
        juce::dsp::Gain<float>
    >;
    
    ProcessorChain processorChain;
};

int main()
{
    std::cout << "JUCE DSP Effect Test\\n";
    
    // Setup audio format
    juce::AudioFormatManager formatManager;
    formatManager.registerBasicFormats();
    
    // Create test audio buffer
    constexpr int sampleRate = 44100;
    constexpr int blockSize = 512;
    constexpr int numChannels = 2;
    
    juce::AudioBuffer<float> buffer(numChannels, blockSize);
    
    // Fill with sine wave for testing
    for (int channel = 0; channel < numChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer(channel);
        for (int sample = 0; sample < blockSize; ++sample)
        {
            channelData[sample] = std::sin(2.0f * juce::MathConstants<float>::pi * 440.0f * sample / sampleRate);
        }
    }
    
    // Setup DSP
    %sEffect effect;
    juce::dsp::ProcessSpec spec;
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = blockSize;
    spec.numChannels = numChannels;
    
    effect.prepare(spec);
    
    // Process audio
    auto audioBlock = juce::dsp::AudioBlock<float>(buffer);
    auto processContext = juce::dsp::ProcessContextReplacing<float>(audioBlock);
    
    effect.process(processContext);
    
    std::cout << "Audio processing completed successfully!\\n";
    
    return 0;
}
]], name, name, name)
      end
    }
  },
  
  ["Synthesizer"] = {
    description = "Basic JUCE synthesizer",
    files = {
      ["Synthesizer.h"] = function(name)
        return string.format([[
#pragma once
#include <JuceHeader.h>

struct %sVoice : public juce::SynthesiserVoice
{
    %sVoice() = default;
    
    bool canPlaySound(juce::SynthesiserSound* sound) override;
    void startNote(int midiNoteNumber, float velocity, juce::SynthesiserSound*, int) override;
    void stopNote(float velocity, bool allowTailOff) override;
    void pitchWheelMoved(int newPitchWheelValue) override;
    void controllerMoved(int controllerNumber, int newControllerValue) override;
    void prepareToPlay(double sampleRate, int samplesPerBlock, int outputChannels);
    void renderNextBlock(juce::AudioBuffer<float>& outputBuffer, int startSample, int numSamples) override;
    
private:
    juce::dsp::Oscillator<float> oscillator { [](float x) { return std::sin(x); } };
    juce::dsp::Gain<float> gain;
    juce::ADSR adsr;
    juce::ADSR::Parameters adsrParams;
    
    juce::dsp::ProcessSpec spec;
    bool isPrepared { false };
};

struct %sSound : public juce::SynthesiserSound
{
    bool appliesToNote(int) override { return true; }
    bool appliesToChannel(int) override { return true; }
};

class %sSynthesizer
{
public:
    %sSynthesizer();
    
    void prepareToPlay(double sampleRate, int samplesPerBlock, int outputChannels);
    void renderNextBlock(juce::AudioBuffer<float>& outputBuffer, juce::MidiBuffer& midiBuffer);
    
private:
    juce::Synthesiser synthesizer;
};
]], name, name, name, name, name)
      end
    }
  }
}

-- JUCE DSP Examples and Learning Resources
M.dsp_examples = {
  ["Filters"] = {
    ["Low-pass Filter"] = [[
// JUCE DSP Low-pass Filter Example
juce::dsp::IIR::Filter<float> lowPassFilter;

// In prepareToPlay:
lowPassFilter.prepare(spec);
auto& coeffs = *lowPassFilter.coefficients;
coeffs = *juce::dsp::IIR::Coefficients<float>::makeLowPass(sampleRate, 1000.0f);

// In processBlock:
lowPassFilter.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]],
    
    ["High-pass Filter"] = [[
// JUCE DSP High-pass Filter Example
juce::dsp::IIR::Filter<float> highPassFilter;

// In prepareToPlay:
highPassFilter.prepare(spec);
auto& coeffs = *highPassFilter.coefficients;
coeffs = *juce::dsp::IIR::Coefficients<float>::makeHighPass(sampleRate, 80.0f);

// In processBlock:
highPassFilter.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]],
    
    ["Band-pass Filter"] = [[
// JUCE DSP Band-pass Filter Example
juce::dsp::IIR::Filter<float> bandPassFilter;

// In prepareToPlay:
bandPassFilter.prepare(spec);
auto& coeffs = *bandPassFilter.coefficients;
coeffs = *juce::dsp::IIR::Coefficients<float>::makeBandPass(sampleRate, 1000.0f, 2.0f);

// In processBlock:
bandPassFilter.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]]
  },
  
  ["Oscillators"] = {
    ["Sine Wave"] = [[
// JUCE DSP Sine Wave Oscillator
juce::dsp::Oscillator<float> sineOsc;

// In prepareToPlay:
sineOsc.prepare(spec);
sineOsc.initialise([](float x) { return std::sin(x); });
sineOsc.setFrequency(440.0f);

// In processBlock:
sineOsc.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]],
    
    ["Sawtooth Wave"] = [[
// JUCE DSP Sawtooth Wave Oscillator
juce::dsp::Oscillator<float> sawOsc;

// In prepareToPlay:
sawOsc.prepare(spec);
sawOsc.initialise([](float x) { return x / juce::MathConstants<float>::pi; });
sawOsc.setFrequency(220.0f);

// In processBlock:
sawOsc.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]],
    
    ["Square Wave"] = [[
// JUCE DSP Square Wave Oscillator
juce::dsp::Oscillator<float> squareOsc;

// In prepareToPlay:
squareOsc.prepare(spec);
squareOsc.initialise([](float x) { return x < 0.0f ? -1.0f : 1.0f; });
squareOsc.setFrequency(330.0f);

// In processBlock:
squareOsc.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]]
  },
  
  ["Effects"] = {
    ["Reverb"] = [[
// JUCE DSP Reverb Effect
juce::dsp::Reverb reverb;

// In prepareToPlay:
reverb.prepare(spec);
juce::dsp::Reverb::Parameters reverbParams;
reverbParams.roomSize = 0.5f;
reverbParams.damping = 0.5f;
reverbParams.wetLevel = 0.3f;
reverbParams.dryLevel = 0.7f;
reverb.setParameters(reverbParams);

// In processBlock:
reverb.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]],
    
    ["Delay"] = [[
// JUCE DSP Delay Effect
juce::dsp::DelayLine<float> delay;

// In prepareToPlay:
delay.prepare(spec);
delay.setMaximumDelayInSamples(static_cast<int>(sampleRate * 0.5)); // 500ms max
delay.setDelay(sampleRate * 0.25f); // 250ms delay

// In processBlock:
for (int channel = 0; channel < buffer.getNumChannels(); ++channel) {
    auto* channelData = buffer.getWritePointer(channel);
    for (int sample = 0; sample < buffer.getNumSamples(); ++sample) {
        float input = channelData[sample];
        float delayed = delay.popSample(channel);
        delay.pushSample(channel, input + delayed * 0.3f);
        channelData[sample] = input + delayed * 0.5f;
    }
}
]],
    
    ["Chorus"] = [[
// JUCE DSP Chorus Effect
juce::dsp::Chorus<float> chorus;

// In prepareToPlay:
chorus.prepare(spec);
chorus.setRate(1.0f);
chorus.setDepth(0.25f);
chorus.setCentreDelay(7.0f);
chorus.setFeedback(0.0f);
chorus.setMix(0.5f);

// In processBlock:
chorus.process(juce::dsp::ProcessContextReplacing<float>(buffer));
]]
  }
}

-- Create a new JUCE project
function M.create_juce_project()
  vim.ui.select(vim.tbl_keys(M.juce_templates), {
    prompt = "Select JUCE project template:",
  }, function(choice)
    if not choice then return end
    
    vim.ui.input({
      prompt = "Project name: ",
    }, function(name)
      if not name or name == "" then return end
      
      -- Create project directory
      local project_dir = vim.fn.getcwd() .. "/" .. name
      vim.fn.mkdir(project_dir, "p")
      
      -- Create source directory
      vim.fn.mkdir(project_dir .. "/Source", "p")
      
      local template = M.juce_templates[choice]
      
      -- Generate files from template
      for file_path, content_func in pairs(template.files) do
        local full_path = project_dir .. "/" .. file_path
        local dir = vim.fn.fnamemodify(full_path, ":h")
        vim.fn.mkdir(dir, "p")
        
        local content = content_func(name)
        local file = io.open(full_path, "w")
        if file then
          file:write(content)
          file:close()
        end
      end
      
      -- Open the main file
      local main_file = project_dir .. "/Source/PluginProcessor.cpp"
      if vim.fn.filereadable(main_file) == 1 then
        vim.cmd("edit " .. main_file)
      else
        vim.cmd("edit " .. project_dir .. "/main.cpp")
      end
      
      print("JUCE project '" .. name .. "' created successfully!")
    end)
  end)
end

-- Show JUCE DSP examples
function M.show_dsp_examples()
  local examples = {}
  
  for category, items in pairs(M.dsp_examples) do
    for name, code in pairs(items) do
      table.insert(examples, category .. " -> " .. name)
    end
  end
  
  vim.ui.select(examples, {
    prompt = "Select DSP example:",
  }, function(choice)
    if not choice then return end
    
    local category, name = choice:match("(.+) %-> (.+)")
    local code = M.dsp_examples[category][name]
    
    -- Create a new buffer with the example code
    vim.cmd("enew")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(code, "\n"))
    vim.bo.filetype = "cpp"
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "wipe"
    
    print("DSP Example: " .. category .. " - " .. name)
  end)
end

-- JUCE build system integration
function M.build_juce_project()
  local project_root = vim.fn.getcwd()
  
  -- Check if CMakeLists.txt exists
  if vim.fn.filereadable(project_root .. "/CMakeLists.txt") == 0 then
    print("No CMakeLists.txt found in current directory")
    return
  end
  
  -- Create build directory
  vim.fn.mkdir(project_root .. "/build", "p")
  
  -- Configure CMake
  vim.cmd("terminal")
  vim.cmd("startinsert")
  vim.api.nvim_feedkeys("cd " .. project_root .. " && cmake -B build -S . && cmake --build build\n", "t", false)
end

-- Show JUCE/DSP learning resources
function M.show_learning_resources()
  local resources = {
    "JUCE Framework Overview",
    "Audio Processing Basics", 
    "DSP Chain Concepts",
    "Plugin Development Guide",
    "Real-time Audio Programming",
    "MIDI Processing",
    "Audio Effects Design",
    "Synthesizer Programming"
  }
  
  local content = {
    ["JUCE Framework Overview"] = [[
JUCE Framework Overview
=======================

JUCE is a comprehensive C++ framework for audio application development.

Key Components:
• Audio Processors - Core DSP processing units
• Audio Devices - Hardware interface abstraction  
• DSP Module - High-performance audio processing classes
• GUI Components - Cross-platform user interfaces
• MIDI Support - Complete MIDI I/O functionality

Core Classes:
• AudioProcessor - Base class for audio processing
• AudioBuffer - Container for audio samples
• dsp::ProcessSpec - Specifications for DSP setup
• dsp::ProcessContext - Context for DSP processing

Getting Started:
1. Download JUCE from juce.com
2. Use Projucer to create projects
3. Or use CMake with FetchContent/add_subdirectory
4. Link required JUCE modules
5. Implement AudioProcessor interface
]],
    
    ["Audio Processing Basics"] = [[
Audio Processing Basics
======================

Sample Rate & Block Size:
• Sample Rate: Number of samples per second (e.g., 44.1kHz, 48kHz)
• Block Size: Number of samples processed at once (e.g., 512 samples)
• Lower block sizes = lower latency, higher CPU usage

Audio Buffer Structure:
• Multi-channel interleaved or planar format
• Float samples typically in range [-1.0, 1.0]
• Access via getReadPointer() and getWritePointer()

Processing Pipeline:
1. prepareToPlay() - Initialize DSP objects
2. processBlock() - Process audio samples
3. releaseResources() - Cleanup when stopping

Key Concepts:
• Always use ScopedNoDenormals for performance
• Clear unused output channels
• Process in-place when possible
• Use ProcessSpec for DSP object setup
]],
    
    ["DSP Chain Concepts"] = [[
DSP Chain Concepts
==================

ProcessorChain allows chaining multiple DSP processors:

Example Chain:
```cpp
using Chain = juce::dsp::ProcessorChain<
    juce::dsp::IIR::Filter<float>,
    juce::dsp::Gain<float>,
    juce::dsp::Reverb
>;
```

Chain Operations:
• prepare() - Setup all processors in chain
• process() - Process through entire chain
• reset() - Reset all processors
• get<Index>() - Access specific processor

Benefits:
• Automatic audio routing
• Simplified parameter management
• Optimized processing
• Clean, readable code

Chain Positions:
Use enum for better code organization:
```cpp
enum ChainPositions { Filter, Gain, Reverb };
auto& filter = chain.get<ChainPositions::Filter>();
```
]],
    
    ["Plugin Development Guide"] = [[
Plugin Development Guide
========================

Plugin Types:
• Effect Plugins - Process existing audio
• Instrument Plugins - Generate audio from MIDI
• MIDI Effects - Process MIDI data only

Key Methods to Implement:
• processBlock() - Main audio processing
• prepareToPlay() - Initialize before playback
• releaseResources() - Cleanup resources
• hasEditor() / createEditor() - GUI support
• getStateInformation() - Save plugin state
• setStateInformation() - Restore plugin state

Plugin Formats:
• VST3 - Cross-platform, modern
• AU - Audio Units (macOS only)
• AAX - Pro Tools format
• Standalone - Desktop application

CMake Integration:
```cmake
juce_add_plugin(MyPlugin
    FORMATS VST3 AU Standalone
    PRODUCT_NAME "My Plugin")
```
]],
    
    ["Real-time Audio Programming"] = [[
Real-time Audio Programming
===========================

Core Principles:
• No memory allocation in audio thread
• Avoid blocking operations (file I/O, network)
• Use lock-free data structures
• Minimize processing time per block

JUCE Tools:
• AbstractFifo - Lock-free FIFO
• SpinLock - Lightweight locking
• Atomic<T> - Atomic operations
• CriticalSection - Mutex alternative

Performance Tips:
• Pre-allocate all buffers
• Use SIMD instructions when possible
• Profile with audio thread priority
• Avoid virtual function calls in hot paths
• Use restrict keyword for pointer aliasing

Memory Management:
• Use MemoryPool for fixed-size allocations
• Employ object pooling patterns
• Defer deletion to message thread
• Use placement new for real-time allocations

Debugging:
• Use real-time safe logging
• Monitor CPU usage per block
• Test with various block sizes
• Profile on target hardware
]]
  }
  
  vim.ui.select(resources, {
    prompt = "Select learning resource:",
  }, function(choice)
    if not choice then return end
    
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
      title = " " .. choice .. " ",
      title_pos = "center",
    })
    
    local lines = vim.split(content[choice] or "Content not available", "\n")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    
    -- Add key mappings for navigation and closing
    local opts = { noremap = true, silent = true, buffer = buf }
    vim.keymap.set('n', 'q', '<cmd>close<CR>', opts)
    vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', opts)
  end)
end

-- Setup JUCE development environment
function M.setup_juce_environment()
  -- Check if JUCE is available
  local juce_path = vim.fn.expand("~/JUCE")
  if vim.fn.isdirectory(juce_path) == 0 then
    print("JUCE not found at ~/JUCE. Consider installing JUCE framework.")
    print("Visit: https://juce.com/get-juce")
  end
  
  -- Create keymaps for JUCE development
  vim.keymap.set('n', '<leader>jn', M.create_juce_project, { desc = "Create new JUCE project" })
  vim.keymap.set('n', '<leader>je', M.show_dsp_examples, { desc = "Show JUCE DSP examples" })
  vim.keymap.set('n', '<leader>jb', M.build_juce_project, { desc = "Build JUCE project" })
  vim.keymap.set('n', '<leader>jl', M.show_learning_resources, { desc = "Show JUCE learning resources" })
  
  print("JUCE/DSP environment configured!")
  print("Keymaps: <leader>jn (new project), <leader>je (examples), <leader>jb (build), <leader>jl (learn)")
end

return M
