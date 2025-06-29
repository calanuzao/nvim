# JUCE/DSP Integration for Neovim

This integration adds comprehensive JUCE (C++ audio framework) and Digital Signal Processing (DSP) development capabilities to your Neovim configuration.

## 🎵 Features

### Core JUCE Development
- **Project Templates**: Quick generation of JUCE audio plugins, synthesizers, and effects
- **Code Snippets**: Pre-built patterns for common DSP operations
- **Build Integration**: CMake-based build system with one-command compilation
- **LSP Support**: Enhanced C++ development with clangd extensions

### Educational Resources
- **DSP Formulas**: Interactive reference for mathematical formulas
- **JUCE API Reference**: Quick lookup for classes and methods
- **Learning Materials**: Structured tutorials and examples
- **Code Examples**: Copy-paste ready implementations

### Development Tools
- **Auto-completion**: Context-aware code completion for JUCE classes
- **Syntax Highlighting**: Enhanced C++ highlighting for audio code
- **Error Detection**: Real-time compilation error checking
- **File Detection**: Automatic setup for JUCE project files

## 🚀 Quick Start

### 1. Run the Demo Setup
```bash
cd ~/.config/nvim/demos
./juce_audio_demo_setup.sh
```

This will:
- Download the JUCE framework
- Create a complete audio plugin project
- Generate DSP test programs
- Set up build configurations

### 2. Essential Commands

In Neovim, you can use these commands:

#### Menu-Based Access
- `:JuceDSP` - Main JUCE/DSP menu with all options
- `:DSP` - Show DSP formulas (existing functionality)

#### Direct Commands
- `:JuceNew` - Create new JUCE project
- `:JuceExamples` - Browse DSP code examples
- `:JuceBuild` - Build current project
- `:JuceLearn` - Show learning resources
- `:DSPSnippet` - Insert code snippets
- `:JuceRef` - JUCE API reference

### 3. Key Bindings

| Key | Action |
|-----|--------|
| `<leader>jm` | JUCE/DSP Development Menu |
| `<leader>jn` | Create New JUCE Project |
| `<leader>je` | Show DSP Examples |
| `<leader>jb` | Build JUCE Project |
| `<leader>jl` | Learning Resources |
| `<leader>ji` | Insert DSP Snippet |
| `<leader>jr` | JUCE API Reference |
| `<leader>df` | DSP Formulas |

## 📚 Learning Path

### Beginner (Start Here)
1. **Run the demo**: `./juce_audio_demo_setup.sh`
2. **Explore formulas**: `<leader>df` or `:DSP`
3. **Try examples**: `<leader>je` or `:JuceExamples`
4. **Read basics**: `<leader>jl` → "Audio Processing Basics"

### Intermediate
1. **Create first plugin**: `<leader>jn` → "Audio Plugin"
2. **Build and test**: `<leader>jb` or `:JuceBuild`
3. **Study code structure**: Examine generated files
4. **Modify parameters**: Change filter frequencies, gain values

### Advanced
1. **Custom DSP**: Create your own effect algorithms
2. **GUI Development**: Add visual controls and meters
3. **Real-time Safety**: Learn lock-free programming
4. **Optimization**: SIMD and performance tuning

## 🔧 Project Types

### 1. Audio Plugin
Complete VST3/AU plugin with:
- Audio processing chain
- Parameter management
- GUI framework
- State saving/loading

### 2. DSP Effect
Standalone effect processor:
- Filter implementations
- Modulation effects
- Time-based effects
- Analysis tools

### 3. Synthesizer
MIDI-controlled sound generator:
- Oscillator banks
- Envelope generators
- Voice management
- Modulation matrix

## 📖 Code Examples

### Basic Filter
```cpp
juce::dsp::IIR::Filter<float> filter;

// Setup
filter.prepare(spec);
*filter.coefficients = *juce::dsp::IIR::Coefficients<float>::makeLowPass(
    sampleRate, 1000.0f);

// Process
filter.process(juce::dsp::ProcessContextReplacing<float>(buffer));
```

### Oscillator
```cpp
juce::dsp::Oscillator<float> osc;

// Setup
osc.prepare(spec);
osc.initialise([](float x) { return std::sin(x); }); // Sine wave
osc.setFrequency(440.0f);

// Process
osc.process(juce::dsp::ProcessContextReplacing<float>(buffer));
```

### Processor Chain
```cpp
using Chain = juce::dsp::ProcessorChain<
    juce::dsp::IIR::Filter<float>,
    juce::dsp::Gain<float>,
    juce::dsp::Reverb
>;

Chain processorChain;
processorChain.prepare(spec);
processorChain.process(context);
```

## 🛠️ Build System

The integration uses CMake with FetchContent for JUCE:

```cmake
# Basic plugin structure
juce_add_plugin(MyPlugin
    FORMATS VST3 AU Standalone
    PRODUCT_NAME "My Plugin")

target_link_libraries(MyPlugin
    PRIVATE
        juce::juce_audio_utils
        juce::juce_dsp)
```

## 🎯 Use Cases

### Music Production
- **Audio Effects**: Reverb, delay, distortion, modulation
- **Dynamics**: Compressors, limiters, gates
- **Filters**: EQ, crossovers, creative filtering
- **Analysis**: Spectrum analyzers, meters

### Engineering Education
- **Signal Processing**: Filter design, frequency analysis
- **Real-time Systems**: Low-latency audio processing
- **Algorithm Development**: Custom DSP implementations
- **Performance Optimization**: SIMD, threading, memory management

### Research & Development
- **Prototype Development**: Quick algorithm testing
- **Academic Projects**: Research implementations
- **Algorithm Validation**: Test against known results
- **Performance Benchmarking**: Optimize for different platforms

## 🔍 Troubleshooting

### Common Issues

**JUCE Not Found**
```bash
# Download JUCE manually
git clone https://github.com/juce-framework/JUCE.git ~/JUCE
```

**Build Errors**
```bash
# Ensure you have CMake and a C++ compiler
brew install cmake  # macOS
sudo apt install cmake build-essential  # Linux
```

**Missing Dependencies**
```bash
# macOS: Install Xcode Command Line Tools
xcode-select --install

# Linux: Install development packages
sudo apt install libasound2-dev libjack-jackd2-dev
```

### Performance Tips
1. **Use Release builds** for audio processing
2. **Enable optimizations** in CMake
3. **Profile your code** regularly
4. **Test on target hardware**

## 🌟 Advanced Features

### Custom Templates
You can add your own project templates by extending the `juce_templates` table in `lua/calanuzao/juce-dsp.lua`.

### Integration with DAW
Built plugins automatically install to:
- **macOS**: `~/Library/Audio/Plug-Ins/VST3/`
- **Linux**: `~/.vst3/`
- **Windows**: `%PROGRAMFILES%\Common Files\VST3\`

### Real-time Debugging
The integration includes tools for:
- CPU usage monitoring
- Memory allocation tracking
- Audio thread safety validation
- Performance profiling

## 📚 Resources

### Official Documentation
- [JUCE Framework](https://juce.com/)
- [JUCE Tutorials](https://docs.juce.com/master/tutorial_getting_started.html)
- [DSP Module Docs](https://docs.juce.com/master/group__juce__dsp.html)

### Community
- [JUCE Forum](https://forum.juce.com/)
- [The Audio Programmer](https://www.theaudioprogrammer.com/)
- [KVR Audio](https://www.kvraudio.com/)

### Books
- "Audio Effects: Theory, Implementation and Application" by Reiss & McPherson
- "Real-Time Audio Programming" by Puckette
- "Digital Signal Processing" by Proakis & Manolakis

## 🤝 Contributing

To extend this integration:

1. **Add Templates**: Extend the templates in `juce-dsp.lua`
2. **Add Examples**: Include new DSP examples
3. **Improve Documentation**: Add more learning resources
4. **Optimize Performance**: Enhance build configurations

## 📄 License

This integration follows the same license as your Neovim configuration. JUCE framework has its own licensing terms - see [JUCE License](https://juce.com/juce-6-licence/) for details.

---

*Happy audio DSP development! 🎵*
