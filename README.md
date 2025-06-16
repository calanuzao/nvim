# 🚀  Neovim Configuration

Before you begin, please ensure you have the latest version of Neovim installed. This configuration is designed to work with Neovim 0.9.0 and above. 
Also it's very easy, and common, to be a 'vimpostor' and easily drown in configurations and not get actual work done. From experience, work with what you need, and add more as you go,
or even better, use this configuration as a starting point and reverse engineer it to understand how it works.

A few things to consider: I constantly update functions, and add new features, so not everything might work as expected, especially when a plugin 
is no longer being suppoerted. My preferred GNU terminal is Alacritty and the GUI of my choice is Neovide. Both are great, but you can use whatever you
want but for the love of God, almighty, please do not use ChatGPT to generate your configuration without understading it. Understand how it works, then use AI 
to automate the boring parts. Without further ado, here is a prety **** configuration. Up to you what **** means.

## Why This Configuration?
When I was in finance and marketing I used SQL and Python for data analysis mostly through the Jupyter Environment, then when I pivoted to engineering I realized how little I knew about how a computer
actually works, and how to use a terminal. Hence my journey to the world of NeoVim began. I have always enjoyed music production and even though my hearing loss tried to get in the way, here I am, 
developing audio applications. Think of me as the Vim Beethoven, but with a keyboard instead of a piano.

I started using ChadVim, but I had no idea how vim actully worked, and I was just copying and pasting configurations without understanding them. My job required me to work with audio develpment, and 
embedded systems, and going back and forth between my NeoVim configuration and the documentation was a pain. I just used the good old VSCode, turns out using an IDE was not ideal for me give the fact
that I had a potato of a laptop (not anymore - thank you capitalism), and I needed something lightweight, fast, and easy to use. This configuration has everything I use ona daily basis, from a neat 
dashboard, to LSP support, to Arduino development, and LaTeX integration. It is designed to be extensible, so you can easily add or remove features as needed.

One of my favorite features is my DIY theme switcher, which allows me to change the theme on the fly. People often laugh at me for being excited for the theme switcher, but trust me, it comes in handy
when it's 3:25am on a Tuesday, and you live in a studio apartment with your girlfriend (hopefully she says yes to the ring situation), and you need to change the theme from light to dark, or whatever the 
trillions of themes out there.

So yes - enjoy this powerful, feature-rich NeoVim configuration optimized for audio development, Python, Arduino, and LaTeX, with a focus on productivity and extensibility blah, blah, blah. 
Take into consideration that this will not make you a better engineer, we all still suck at electromagnetism:, and we all still have impostor syndrome, but at least you will have a nice looking NeoVim
configuration. 

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
- 🏠 Personalized Dashboard with Alpha
- 🎨 Personalized Theme Switcher with :Atheme command 

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
# or use conda environment
conda create -n nvim python=3.8 -y
conda activate nvim
conda install neovim -y

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

``````
~/.config/nvim/
│  
├── init.lua (main configuration file)
├── init.lua.bak
├── lazy-lock.json
├── lua
│   ├── calanuzao (custom namespace)
│   │   ├── compat.lua
│   │   ├── dsp.lua
│   │   ├── globals.lua
│   │   ├── options.lua
│   │   └── remaps.lua
│   ├── plugins (plugin configurations)
│   │   ├── coc.lua
│   │   ├── harpoon.lua
│   │   ├── lsp.lua
│   │   ├── neoclip.lua
│   │   ├── neoscroll.lua
│   │   ├── nvim-dap-vscode-js.lua
│   │   ├── nvim-ufo.lua
│   │   ├── obsidian.lua
│   │   ├── telescope.lua
│   │   ├── tmux.lua
│   │   ├── vim-matlab.lua
│   │   └── VimTeX.lua
│   ├── plugins.lua
│   └── plugins.lua.bak
├── README.md
└── UltiSnips
    └── tex.snippets

``````
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

### File Explorer
- `Ctrl+n` - Toggle Finder

### Terminal
- `Ctrl+\` - Toggle Terminal

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

### Favorite Commands 
- `:Atheme` - Switch themes
- `:ArduinoVerify` - Verify Arduino sketch
- `:ArduinoUpload` - Upload to Arduino board
- `:VimtexCompile` - Compile LaTex Documentation
- `:VimtexView'` - View LaTex Documentation

## 🔧 Troubleshooting

1. Plugin Installation Issues:
```bash
rm -rf ~/.local/share/nvim
nvim --headless "+Lazy! sync" +qa
```

2. LaTeX Preview:
- LaTex preview does not work with Alacritty terminal, iTerm2 and Kitty work fine.
- Ensure Zathura is installed
- Check VimTeX configuration
- Verify LaTeX installation

3. Arduino Upload:
- Verify arduino-cli installation
- Check board permissions
- Confirm port selection

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details.

## 🙌🏻 Acknowledgments

- Neovim community
- Plugin authors
- LazyVim for inspiration
- All contributors

## 📚 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [VimTeX Documentation](https://github.com/lervag/vimtex)
- [Arduino CLI Documentation](https://arduino.github.io/arduino-cli/)
- [LaTeX Documentation](https://www.latex-project.org/help/documentation/)
