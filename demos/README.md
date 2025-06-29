# 🚀 Development Environment Demos

This directory contains demo setup scripts that showcase the language-specific development capabilities of this Neovim configuration. Each script creates a complete project structure with example code, configuration files, and documentation to help you get started with different programming languages.

## 📋 Available Demos

### 🐍 [Python Development Demo](./python_demo_setup.sh)
**Creates:** `~/python_demo/`

A comprehensive Python project demonstrating:
- **Data Analysis & Visualization** with NumPy, Pandas, Matplotlib
- **Object-Oriented Programming** with type hints
- **Unit Testing** with pytest
- **Code Quality** tools (Black, isort, pylint, mypy)
- **Virtual Environment** setup
- **Debugging** configuration

**Features Demonstrated:**
- Pyright + Ruff LSP integration
- Auto-formatting on save
- Import organization
- Type checking and IntelliSense
- Virtual environment detection
- Debugging with breakpoints

**Generated Files:**
```
~/python_demo/
├── main.py              # Main program with data analysis
├── calculator.py        # Calculator class with type hints
├── test_calculator.py   # Comprehensive unit tests
├── requirements.txt     # Project dependencies
├── .pylintrc           # Linting configuration
├── pyproject.toml      # Tool configuration (Black, isort, mypy)
└── setup_venv.sh       # Virtual environment setup script
```

---

### 💻 [C++ Development Demo](./cpp_demo_setup.sh)
**Creates:** `~/cpp_demo/`

A modern C++ project demonstrating:
- **Object-Oriented Design** with header/source separation
- **Modern C++17** features
- **Error Handling** with exceptions
- **STL Usage** (vectors, algorithms)
- **Build System** with Makefile

**Features Demonstrated:**
- Clangd LSP with advanced features
- Auto-formatting with clang-format
- Header/source switching
- IntelliSense and symbol navigation
- Debugging support with codelldb

**Generated Files:**
```
~/cpp_demo/
├── main.cpp            # Main program
├── calculator.h        # Header file with class declaration
├── calculator.cpp      # Implementation file
└── Makefile           # Build configuration
```

---

### 📊 [MATLAB Development Demo](./matlab_demo_setup.sh)
**Creates:** `~/matlab_demo/`

A comprehensive MATLAB project demonstrating:
- **Signal Processing** with multiple analysis sections
- **Object-Oriented Programming** with MATLAB classes
- **Function Development** with proper documentation
- **Advanced Analysis** (FFT, filtering, correlation)
- **Visualization** with multiple plot types

**Features Demonstrated:**
- Section-based development (`%%` sections)
- Function templates and class creation
- Code execution by sections
- MATLAB-specific navigation and shortcuts
- Professional documentation standards

**Generated Files:**
```
~/matlab_demo/
├── signal_analysis_demo.m    # Main demo script with 6 sections
├── butter_bandpass.m         # Custom filter function
├── SignalProcessor.m         # MATLAB class for signal processing
└── test_signal_processor.m   # Test script for the class
```

## 🚀 Quick Start

### Interactive Demo Runner
```bash
cd ~/.config/nvim/demos
./run_demo.sh
```

The interactive runner will guide you through selecting and setting up any demo project.

### Run All Demos
```bash
cd ~/.config/nvim/demos

# Python Demo
./python_demo_setup.sh
cd ~/python_demo && nvim main.py

# C++ Demo  
./cpp_demo_setup.sh
cd ~/cpp_demo && nvim main.cpp

# MATLAB Demo
./matlab_demo_setup.sh
cd ~/matlab_demo && nvim signal_analysis_demo.m
```

### Individual Demo Setup

#### Python Development
```bash
./python_demo_setup.sh
cd ~/python_demo
source venv/bin/activate  # Activate virtual environment
nvim main.py
```

**Try these features:**
- `K` - Hover documentation
- `gd` - Go to definition
- `<leader>ca` - Code actions
- `<leader>f` - Format code
- `:PyTest` - Run tests
- `<leader>pd` - Insert breakpoint

#### C++ Development
```bash
./cpp_demo_setup.sh
cd ~/cpp_demo
nvim main.cpp
```

**Try these features:**
- `<leader>ch` - Switch header/source
- `:CppCompileRun` - Compile and run
- `<leader>cs` - Symbol info
- Auto-formatting on save

#### MATLAB Development
```bash
./matlab_demo_setup.sh
cd ~/matlab_demo
nvim signal_analysis_demo.m
```

**Try these features:**
- `]]` / `[[` - Navigate sections
- `<leader>ms` - Run current section
- `<leader>mf` - Insert function template
- `for<Tab>` - Insert for loop template

## 🎯 Language Server Features

All demos showcase these common LSP features:

### 🔍 **Navigation**
- `gd` - Go to definition
- `gD` - Go to declaration  
- `gr` - Find references
- `gi` - Go to implementation

### 📝 **Code Intelligence**
- `K` - Show hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format code

### 🐛 **Debugging**
- Integrated debug adapter support
- Language-specific debugging commands
- Breakpoint management

## 🛠️ Tool Installation

The demos automatically work with tools installed via Mason:

### Python Tools
```vim
:MasonInstall pyright ruff-lsp black isort pylint mypy debugpy
```

### C++ Tools  
```vim
:MasonInstall clangd clang-format codelldb
```

### Java Tools (already configured)
```vim
:MasonInstall jdtls
```

## 📚 Learning Path

### Beginner
1. **Start with Python demo** - Most familiar syntax
2. **Explore LSP features** - Learn `gd`, `K`, `<leader>ca`
3. **Try debugging** - Set breakpoints with `<leader>pd`

### Intermediate
1. **C++ demo** - Learn header/source workflow
2. **MATLAB sections** - Understand section-based development
3. **Custom commands** - Explore `:PyTest`, `:CppCompile`, etc.

### Advanced
1. **Extend configurations** - Add new ftplugin files
2. **Custom snippets** - Modify abbreviations
3. **Debug configurations** - Customize DAP settings

## 🔧 Customization

### Adding New Languages
Create new ftplugin files based on existing patterns:

```bash
# Example: Add Rust support
touch ~/.config/nvim/ftplugin/rust.lua

# Example: Add Go support  
touch ~/.config/nvim/ftplugin/go.lua
```

### Modifying Existing Configs
Edit the ftplugin files directly:
- `~/.config/nvim/ftplugin/python.lua`
- `~/.config/nvim/ftplugin/cpp.lua` 
- `~/.config/nvim/ftplugin/matlab.lua`

### Creating Custom Demo Scripts
Use the existing scripts as templates:
1. Copy an existing demo script
2. Modify the generated project structure
3. Update the documentation
4. Add language-specific features

## 🆘 Troubleshooting

### Python Issues
- **Virtual Environment**: Run `source venv/bin/activate` in project directory
- **Missing Packages**: Run `pip install -r requirements.txt`
- **LSP Not Working**: Check `:LspInfo` and ensure pyright is installed

### C++ Issues
- **Compilation Errors**: Ensure g++ is installed and in PATH
- **LSP Not Working**: Check `:LspInfo` and ensure clangd is installed
- **No IntelliSense**: Wait for clangd to index the project

### MATLAB Issues
- **Execution Fails**: Ensure MATLAB is installed and in PATH
- **No Syntax Highlighting**: Check if vim-matlab plugin is loaded
- **Section Navigation**: Ensure sections start with `%%`

### General LSP Issues
```vim
:LspRestart          " Restart language server
:LspInfo             " Check LSP status
:checkhealth lsp     " Run LSP health check
:Mason               " Check installed tools
```

## 📖 Additional Resources

- [Main README](../README.md) - Complete configuration documentation
- [ftplugin Directory](../ftplugin/) - Language-specific configurations
- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [Mason.nvim](https://github.com/williamboman/mason.nvim) - Tool installation

## 🎉 Happy Coding!

These demos showcase the power of ftplugin-based language-specific configurations. Each language gets its own optimized development environment while sharing the same underlying Neovim configuration. Explore, experiment, and extend these examples to fit your workflow!

---

*Generated by the Neovim ftplugin configuration system*
