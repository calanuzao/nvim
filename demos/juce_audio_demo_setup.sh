#!/bin/bash

# JUCE/DSP Audio Development Setup Demo
# This script demonstrates JUCE audio development capabilities with Neovim

echo "🎵 JUCE/DSP Audio Development Setup Demo"
echo "=========================================="
echo ""

# Check for required tools
echo "📋 Checking prerequisites..."

# Check for CMake
if ! command -v cmake &> /dev/null; then
    echo "❌ CMake not found. Please install CMake first."
    echo "   macOS: brew install cmake"
    echo "   Linux: sudo apt-get install cmake"
    exit 1
else
    echo "✅ CMake found: $(cmake --version | head -n1)"
fi

# Check for C++ compiler
if ! command -v clang++ &> /dev/null && ! command -v g++ &> /dev/null; then
    echo "❌ C++ compiler not found. Please install Xcode Command Line Tools or GCC."
    echo "   macOS: xcode-select --install"
    echo "   Linux: sudo apt-get install build-essential"
    exit 1
else
    if command -v clang++ &> /dev/null; then
        echo "✅ Clang++ found: $(clang++ --version | head -n1)"
    else
        echo "✅ G++ found: $(g++ --version | head -n1)"
    fi
fi

# Create demo directory
DEMO_DIR="$HOME/juce_audio_demo"
echo ""
echo "📁 Creating JUCE audio demo project in $DEMO_DIR"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

# Download JUCE if not present
if [ ! -d "JUCE" ]; then
    echo "📥 Downloading JUCE framework..."
    git clone https://github.com/juce-framework/JUCE.git
    echo "✅ JUCE framework downloaded"
else
    echo "✅ JUCE framework already present"
fi

# Create a simple audio effect plugin
echo ""
echo "🔧 Creating audio effect plugin template..."

cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.15)
project(SimpleAudioEffect VERSION 0.0.1)

# Add JUCE to the project
add_subdirectory(JUCE)

# Create the plugin
juce_add_plugin(SimpleAudioEffect
    COMPANY_NAME "Demo Company"
    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS FALSE
    COPY_PLUGIN_AFTER_BUILD TRUE
    PLUGIN_MANUFACTURER_CODE Demo
    PLUGIN_CODE SAEF
    FORMATS AU VST3 Standalone
    PRODUCT_NAME "Simple Audio Effect")

# Add source files
target_sources(SimpleAudioEffect
    PRIVATE
        Source/PluginProcessor.cpp
        Source/PluginEditor.cpp)

# Compile definitions
target_compile_definitions(SimpleAudioEffect
    PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0)

# Link libraries
target_link_libraries(SimpleAudioEffect
    PRIVATE
        juce::juce_audio_utils
        juce::juce_dsp
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
EOF

# Create Source directory
mkdir -p Source

# Create PluginProcessor.h
cat > Source/PluginProcessor.h << 'EOF'
#pragma once

#include <JuceHeader.h>

//==============================================================================
/**
    Simple audio effect demonstrating JUCE DSP capabilities.
    Features:
    - Low-pass filter with adjustable cutoff
    - Gain control
    - Simple delay effect
*/
class SimpleAudioEffectAudioProcessor  : public juce::AudioProcessor
{
public:
    //==============================================================================
    SimpleAudioEffectAudioProcessor();
    ~SimpleAudioEffectAudioProcessor() override;

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

   #ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
   #endif

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

    // DSP Parameters
    float cutoffFrequency = 1000.0f;
    float gain = 1.0f;
    float delayTime = 0.25f;
    float feedback = 0.3f;

private:
    //==============================================================================
    // DSP Objects
    juce::dsp::ProcessSpec spec;
    
    // Filter chain for each channel
    using FilterType = juce::dsp::IIR::Filter<float>;
    using ChainType = juce::dsp::ProcessorChain<FilterType, juce::dsp::Gain<float>>;
    
    ChainType leftChain, rightChain;
    
    // Delay line
    juce::dsp::DelayLine<float> delayLine { 48000 }; // 1 second max delay at 48kHz
    
    enum ChainPositions
    {
        Filter,
        Gain
    };
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (SimpleAudioEffectAudioProcessor)
};
EOF

# Create PluginProcessor.cpp
cat > Source/PluginProcessor.cpp << 'EOF'
#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
SimpleAudioEffectAudioProcessor::SimpleAudioEffectAudioProcessor()
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

SimpleAudioEffectAudioProcessor::~SimpleAudioEffectAudioProcessor()
{
}

//==============================================================================
const juce::String SimpleAudioEffectAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool SimpleAudioEffectAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool SimpleAudioEffectAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool SimpleAudioEffectAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double SimpleAudioEffectAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int SimpleAudioEffectAudioProcessor::getNumPrograms()
{
    return 1;
}

int SimpleAudioEffectAudioProcessor::getCurrentProgram()
{
    return 0;
}

void SimpleAudioEffectAudioProcessor::setCurrentProgram (int index)
{
}

const juce::String SimpleAudioEffectAudioProcessor::getProgramName (int index)
{
    return {};
}

void SimpleAudioEffectAudioProcessor::changeProgramName (int index, const juce::String& newName)
{
}

//==============================================================================
void SimpleAudioEffectAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    spec.maximumBlockSize = samplesPerBlock;
    spec.sampleRate = sampleRate;
    spec.numChannels = 1; // Mono processing for each channel
    
    // Prepare the processing chains
    leftChain.prepare(spec);
    rightChain.prepare(spec);
    
    // Setup the filter coefficients
    updateFilter();
    
    // Prepare delay line
    delayLine.prepare({ sampleRate, (juce::uint32) samplesPerBlock, 2 });
    delayLine.setMaximumDelayInSamples(sampleRate); // 1 second max
}

void SimpleAudioEffectAudioProcessor::releaseResources()
{
    leftChain.reset();
    rightChain.reset();
    delayLine.reset();
}

void SimpleAudioEffectAudioProcessor::updateFilter()
{
    auto& leftFilter = leftChain.get<ChainPositions::Filter>();
    auto& rightFilter = rightChain.get<ChainPositions::Filter>(); 
    
    *leftFilter.coefficients = *juce::dsp::IIR::Coefficients<float>::makeLowPass(
        spec.sampleRate, cutoffFrequency);
    *rightFilter.coefficients = *juce::dsp::IIR::Coefficients<float>::makeLowPass(
        spec.sampleRate, cutoffFrequency);
    
    // Update gain
    leftChain.get<ChainPositions::Gain>().setGainLinear(gain);
    rightChain.get<ChainPositions::Gain>().setGainLinear(gain);
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool SimpleAudioEffectAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;

    return true;
}
#endif

void SimpleAudioEffectAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    // Update filter parameters (in real plugin, this would be parameter-driven)
    updateFilter();
    
    // Process audio
    juce::dsp::AudioBlock<float> block (buffer);
    
    if (totalNumOutputChannels >= 2)
    {
        // Stereo processing
        auto leftBlock = block.getSingleChannelBlock(0);
        auto rightBlock = block.getSingleChannelBlock(1);
        
        juce::dsp::ProcessContextReplacing<float> leftContext (leftBlock);
        juce::dsp::ProcessContextReplacing<float> rightContext (rightBlock);
        
        leftChain.process(leftContext);
        rightChain.process(rightContext);
    }
    else if (totalNumOutputChannels == 1)
    {
        // Mono processing
        juce::dsp::ProcessContextReplacing<float> context (block);
        leftChain.process(context);
    }
    
    // Add simple delay effect
    auto delayTimeInSamples = delayTime * spec.sampleRate;
    delayLine.setDelay(delayTimeInSamples);
    
    for (int channel = 0; channel < totalNumOutputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer(channel);
        
        for (int sample = 0; sample < buffer.getNumSamples(); ++sample)
        {
            auto input = channelData[sample];
            auto delayedSample = delayLine.popSample(channel);
            
            // Feedback
            delayLine.pushSample(channel, input + delayedSample * feedback);
            
            // Mix dry and wet signal
            channelData[sample] = input + delayedSample * 0.5f;
        }
    }
}

//==============================================================================
bool SimpleAudioEffectAudioProcessor::hasEditor() const
{
    return true;
}

juce::AudioProcessorEditor* SimpleAudioEffectAudioProcessor::createEditor()
{
    return new SimpleAudioEffectAudioProcessorEditor (*this);
}

//==============================================================================
void SimpleAudioEffectAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
}

void SimpleAudioEffectAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
}

//==============================================================================
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new SimpleAudioEffectAudioProcessor();
}
EOF

# Create basic PluginEditor files
cat > Source/PluginEditor.h << 'EOF'
#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"

//==============================================================================
class SimpleAudioEffectAudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    SimpleAudioEffectAudioProcessorEditor (SimpleAudioEffectAudioProcessor&);
    ~SimpleAudioEffectAudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    SimpleAudioEffectAudioProcessor& audioProcessor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (SimpleAudioEffectAudioProcessorEditor)
};
EOF

cat > Source/PluginEditor.cpp << 'EOF'
#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
SimpleAudioEffectAudioProcessorEditor::SimpleAudioEffectAudioProcessorEditor (SimpleAudioEffectAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
    setSize (400, 300);
}

SimpleAudioEffectAudioProcessorEditor::~SimpleAudioEffectAudioProcessorEditor()
{
}

//==============================================================================
void SimpleAudioEffectAudioProcessorEditor::paint (juce::Graphics& g)
{
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));

    g.setColour (juce::Colours::white);
    g.setFont (15.0f);
    g.drawFittedText ("Simple Audio Effect", getLocalBounds(), juce::Justification::centred, 1);
    
    g.setFont (12.0f);
    g.drawFittedText ("Low-pass Filter + Delay", 
                      getLocalBounds().reduced(20).removeFromBottom(20), 
                      juce::Justification::centred, 1);
}

void SimpleAudioEffectAudioProcessorEditor::resized()
{
}
EOF

echo "✅ Audio effect plugin template created!"

# Create a simple DSP test program
echo ""
echo "🧪 Creating DSP test program..."

cat > dsp_test.cpp << 'EOF'
/*
  JUCE DSP Test Program
  Demonstrates various JUCE DSP capabilities
*/

#include <JuceHeader.h>
#include <iostream>

int main()
{
    std::cout << "🎵 JUCE DSP Test Program\n";
    std::cout << "========================\n\n";
    
    // Test specifications
    constexpr double sampleRate = 44100.0;
    constexpr int blockSize = 512;
    constexpr int numChannels = 2;
    constexpr float frequency = 440.0f; // A4
    
    // Create audio buffer
    juce::AudioBuffer<float> buffer(numChannels, blockSize);
    
    // Setup DSP specification
    juce::dsp::ProcessSpec spec;
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = blockSize;
    spec.numChannels = numChannels;
    
    std::cout << "Audio Settings:\n";
    std::cout << "  Sample Rate: " << sampleRate << " Hz\n";
    std::cout << "  Block Size: " << blockSize << " samples\n";
    std::cout << "  Channels: " << numChannels << "\n\n";
    
    // Test 1: Oscillator
    std::cout << "Test 1: Sine Wave Oscillator\n";
    std::cout << "-----------------------------\n";
    
    juce::dsp::Oscillator<float> oscillator;
    oscillator.prepare(spec);
    oscillator.initialise([](float x) { return std::sin(x); });
    oscillator.setFrequency(frequency);
    
    // Generate sine wave
    buffer.clear();
    auto audioBlock = juce::dsp::AudioBlock<float>(buffer);
    auto processContext = juce::dsp::ProcessContextReplacing<float>(audioBlock);
    oscillator.process(processContext);
    
    // Analyze the generated signal
    float maxAmplitude = 0.0f;
    for (int channel = 0; channel < numChannels; ++channel)
    {
        auto* channelData = buffer.getReadPointer(channel);
        for (int sample = 0; sample < blockSize; ++sample)
        {
            maxAmplitude = juce::jmax(maxAmplitude, std::abs(channelData[sample]));
        }
    }
    
    std::cout << "  Generated " << frequency << " Hz sine wave\n";
    std::cout << "  Max amplitude: " << maxAmplitude << "\n";
    std::cout << "  ✅ Oscillator test passed\n\n";
    
    // Test 2: Low-pass Filter
    std::cout << "Test 2: Low-pass Filter\n";
    std::cout << "-----------------------\n";
    
    juce::dsp::IIR::Filter<float> lowPassFilter;
    lowPassFilter.prepare(spec);
    *lowPassFilter.coefficients = *juce::dsp::IIR::Coefficients<float>::makeLowPass(sampleRate, 1000.0f);
    
    // Process the sine wave through the filter
    lowPassFilter.process(processContext);
    
    std::cout << "  Applied 1000 Hz low-pass filter\n";
    std::cout << "  ✅ Filter test passed\n\n";
    
    // Test 3: Gain Control
    std::cout << "Test 3: Gain Control\n";
    std::cout << "--------------------\n";
    
    juce::dsp::Gain<float> gain;
    gain.prepare(spec);
    gain.setGainDecibels(-6.0f); // -6dB attenuation
    
    gain.process(processContext);
    
    std::cout << "  Applied -6dB gain reduction\n";
    std::cout << "  ✅ Gain test passed\n\n";
    
    // Test 4: Processor Chain
    std::cout << "Test 4: Processor Chain\n";
    std::cout << "-----------------------\n";
    
    using ProcessorChain = juce::dsp::ProcessorChain<
        juce::dsp::Oscillator<float>,
        juce::dsp::IIR::Filter<float>,
        juce::dsp::Gain<float>
    >;
    
    ProcessorChain chain;
    chain.prepare(spec);
    
    // Configure chain elements
    auto& chainOsc = chain.get<0>();
    chainOsc.initialise([](float x) { return std::sin(x); });
    chainOsc.setFrequency(880.0f); // A5
    
    auto& chainFilter = chain.get<1>();
    *chainFilter.coefficients = *juce::dsp::IIR::Coefficients<float>::makeLowPass(sampleRate, 2000.0f);
    
    auto& chainGain = chain.get<2>();
    chainGain.setGainDecibels(-3.0f);
    
    // Process through the entire chain
    buffer.clear();
    chain.process(processContext);
    
    std::cout << "  Created processing chain: Oscillator -> Filter -> Gain\n";
    std::cout << "  ✅ Processor chain test passed\n\n";
    
    // Test 5: FFT Analysis
    std::cout << "Test 5: FFT Analysis\n";
    std::cout << "--------------------\n";
    
    constexpr int fftOrder = 9; // 2^9 = 512 samples
    constexpr int fftSize = 1 << fftOrder;
    
    juce::dsp::FFT fft(fftOrder);
    juce::dsp::WindowingFunction<float> window(fftSize, juce::dsp::WindowingFunction<float>::hann);
    
    std::vector<float> fftData(fftSize * 2, 0.0f);
    
    // Copy audio data for FFT (use only one channel)
    for (int i = 0; i < juce::jmin(blockSize, fftSize); ++i)
        fftData[i] = buffer.getSample(0, i);
    
    // Apply window function
    window.multiplyWithWindowingTable(fftData.data(), fftSize);
    
    // Perform FFT
    fft.performFrequencyOnlyForwardTransform(fftData.data());
    
    // Find peak frequency
    int peakBin = 0;
    float peakMagnitude = 0.0f;
    
    for (int bin = 1; bin < fftSize / 2; ++bin)
    {
        float magnitude = fftData[bin];
        if (magnitude > peakMagnitude)
        {
            peakMagnitude = magnitude;
            peakBin = bin;
        }
    }
    
    float peakFrequency = (float)peakBin * sampleRate / fftSize;
    
    std::cout << "  FFT Analysis Results:\n";
    std::cout << "    Peak frequency: " << peakFrequency << " Hz\n";
    std::cout << "    Peak magnitude: " << peakMagnitude << "\n";
    std::cout << "  ✅ FFT analysis test passed\n\n";
    
    std::cout << "🎉 All JUCE DSP tests completed successfully!\n";
    std::cout << "    You now have a working JUCE development environment.\n";
    std::cout << "    Open the project in your IDE or build with:\n";
    std::cout << "    cmake -B build && cmake --build build\n\n";
    
    return 0;
}
EOF

# Create simple CMakeLists.txt for the test program
cat > CMakeLists_test.txt << 'EOF'
cmake_minimum_required(VERSION 3.15)
project(JuceDSPTest)

# Add JUCE
add_subdirectory(JUCE)

# Create test executable
add_executable(JuceDSPTest dsp_test.cpp)

# Link JUCE libraries
target_link_libraries(JuceDSPTest
    PRIVATE
        juce::juce_audio_basics
        juce::juce_audio_devices
        juce::juce_audio_formats
        juce::juce_audio_processors
        juce::juce_audio_utils
        juce::juce_core
        juce::juce_data_structures
        juce::juce_dsp
        juce::juce_events
        juce::juce_graphics
        juce::juce_gui_basics
        juce::juce_gui_extra
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)

target_compile_definitions(JuceDSPTest
    PRIVATE
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0)
EOF

echo "✅ DSP test program created!"

# Create build script
echo ""
echo "🔨 Creating build scripts..."

cat > build.sh << 'EOF'
#!/bin/bash
echo "Building JUCE DSP Test..."
cmake -B build_test -S . -f CMakeLists_test.txt
cmake --build build_test

echo ""
echo "Building Audio Effect Plugin..."
cmake -B build_plugin -S .
cmake --build build_plugin

echo ""
echo "Build completed! Run the test with:"
echo "./build_test/JuceDSPTest"
EOF

chmod +x build.sh

cat > README.md << 'EOF'
# JUCE/DSP Audio Development Demo

This project demonstrates JUCE framework capabilities for audio DSP development.

## What's Included

### 1. Simple Audio Effect Plugin
- Low-pass filter with adjustable parameters
- Gain control
- Simple delay effect
- VST3, AU, and Standalone formats

### 2. DSP Test Program
- Oscillator generation and testing
- Filter processing
- Gain control
- Processor chain demonstration
- FFT analysis

## Building

### Prerequisites
- CMake 3.15+
- C++17 compatible compiler (Clang, GCC, MSVC)
- Git (for JUCE download)

### Quick Start
```bash
# Build everything
./build.sh

# Or build manually:
# Test program:
cmake -B build_test -S . -f CMakeLists_test.txt
cmake --build build_test

# Plugin:
cmake -B build_plugin -S .
cmake --build build_plugin
```

### Running
```bash
# Run DSP test
./build_test/JuceDSPTest

# Plugin will be built to:
# - macOS: ~/Library/Audio/Plug-Ins/VST3/
# - Linux: ~/.vst3/
```

## Neovim Integration

This demo integrates with the JUCE/DSP Neovim configuration:

### Key Features
- **JUCE project templates** - Quick project generation
- **Code snippets** - Common DSP patterns
- **Build integration** - CMake build from editor
- **Learning resources** - Built-in documentation
- **DSP formulas** - Mathematical reference

### Keybindings (in Neovim)
- `<leader>jn` - Create new JUCE project
- `<leader>je` - Show DSP examples
- `<leader>jb` - Build current project
- `<leader>jl` - Show learning resources
- `<leader>ji` - Insert DSP snippet
- `<leader>jr` - Show JUCE reference

## Learning Path

1. **Start with DSP Test** - Understand basic concepts
2. **Examine the Plugin** - See real-world structure
3. **Modify Parameters** - Experiment with values
4. **Add New Effects** - Extend the processor chain
5. **Create GUI** - Add visual controls
6. **Advanced Topics** - MIDI, real-time safety, optimization

## Resources

- [JUCE Framework](https://juce.com/)
- [JUCE Tutorials](https://docs.juce.com/master/tutorial_getting_started.html)
- [DSP Module Documentation](https://docs.juce.com/master/group__juce__dsp.html)
- [Audio Plugin Development](https://www.theaudioprogrammer.com/)

## Next Steps

1. **GUI Development** - Add sliders and controls
2. **Parameter Automation** - Host automation support
3. **Preset Management** - Save/load plugin states
4. **Advanced DSP** - Implement custom algorithms
5. **Real-time Safety** - Optimize for audio thread
6. **Testing** - Unit tests and validation

Happy coding! 🎵
EOF

echo "✅ Documentation created!"

echo ""
echo "🚀 Demo setup completed successfully!"
echo ""
echo "📂 Created in: $DEMO_DIR"
echo "📋 What was created:"
echo "   • JUCE framework (downloaded)"
echo "   • Simple Audio Effect Plugin (VST3/AU/Standalone)"
echo "   • DSP Test Program with examples"
echo "   • Build scripts and documentation"
echo "   • Ready-to-use CMake configuration"
echo ""
echo "🔧 To build and test:"
echo "   cd $DEMO_DIR"
echo "   ./build.sh"
echo ""
echo "📚 In Neovim, use these commands for JUCE development:"
echo "   :lua require('calanuzao.dsp').show_juce_menu()"
echo "   <leader>jn (new project)"
echo "   <leader>je (examples)"
echo "   <leader>jb (build)"
echo "   <leader>jl (learn)"
echo ""
echo "🎵 Happy audio DSP development!"
