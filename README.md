# 🚀  Neovim Configuration

A powerful, feature-rich Neovim configuration optimized for audio development, Python, Arduino, and LaTeX, with a focus on productivity and extensibility.

![Neovim Dashboard](./assets/homepage.png)

## ✨ Features

- 🎵 Audio Development Support
- 🐍 Python Development Environment
- ⚡ Arduino Development with ESP32 Integration
- 📝 LaTeX Support with Live Preview
- 🎨 Beautiful UI with Lavender Theme
- 📦 Lazy Loading for Fast Startup
- 🔍 Powerful Search with Telescope
- 🌳 File Explorer with NvimTree
- 🔧 Git Integration with Fugitive and Gitsigns
- 💻 Terminal Integration with Toggleterm
- ✅ LSP Support with Mason

## 🔧 Prerequisites

- Neovim >= 0.9.0
- Git
- Node.js >= 14
- Python >= 3.8
- A C compiler (gcc/clang)
- ripgrep for telescope search
- arduino-cli for Arduino development
- LaTeX distribution (e.g., TexLive)
- Zathura (PDF viewer for LaTeX)

## 📦 Installation

1. Create necessary directories:
```bash
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/UltiSnips
```

2. Install dependencies (macOS):
```bash
# Create Python virtual environment
python3 -m venv ~/.virtualenvs/neovim
source ~/.virtualenvs/neovim/bin/activate
pip install pynvim

# Install system dependencies
brew install neovim ripgrep fd
brew install --cask mactex
brew install zathura zathura-pdf-poppler

# Install Arduino CLI
brew install arduino-cli
arduino-cli config init
arduino-cli core update-index
arduino-cli core install esp32:esp32
```

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration file
├── lua/
│   └── plugins.lua         # Plugin configurations
└── UltiSnips/
    └── tex.snippets        # LaTeX snippets
```

## ⚡ Quick Start

1. Open a LaTeX file:
```bash
nvim document.tex
```

2. Use snippets:
- Type `beg` then Tab for environment
- Type `mk` then Tab for math mode
- Type `dm` then Tab for display math

3. Compile LaTeX:
- Save file to trigger compilation
- Use `:VimtexCompile` for manual compilation

4. Arduino commands:
```vim
:ArduinoVerify  " Verify sketch
:ArduinoUpload  " Upload to ESP32
```

## 🔑 Key Mappings

Leader key: `Space`

### General
- `<Space>ft` - Open floating terminal
- `<Space>ff` - Find files
- `<Space>fg` - Live grep
- `<Space>fb` - Browse buffers

### Git
- `<Space>gs` - Git status
- `<Space>gc` - Git commit
- `<Space>gp` - Git push
- `<Space>gh` - Show git hunks

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `<Space>ca` - Code actions

### LaTeX
- `<Space>lc` - Compile document
- `<Space>lv` - View PDF
- `<Space>ls` - Toggle continuous compilation
- `Ctrl+l` - Fix last spelling mistake

## 🔧 Troubleshooting

1. Plugin Installation Issues:
```bash
rm -rf ~/.local/share/nvim
nvim --headless "+Lazy! sync" +qa
```

2. LaTeX Preview:
- Ensure Zathura is installed
- Check VimTeX configuration
- Verify LaTeX installation

3. Arduino Upload:
- Verify arduino-cli installation
- Check board permissions
- Confirm port selection

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Neovim community
- Plugin authors
- LazyVim for inspiration
- All contributors

## 📚 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [VimTeX Documentation](https://github.com/lervag/vimtex)
- [Arduino CLI Documentation](https://arduino.github.io/arduino-cli/)
- [LaTeX Documentation](https://www.latex-project.org/help/documentation/)


