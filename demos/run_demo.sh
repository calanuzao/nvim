#!/bin/bash

# Demo Index - Interactive demo selector
# This script helps you choose and run development environment demos

echo "🚀 Neovim Development Environment Demos"
echo "======================================"
echo ""
echo "Choose a demo to set up:"
echo ""
echo "1) 🐍 Python Development Demo"
echo "   - Data analysis with NumPy, Pandas, Matplotlib"
echo "   - Unit testing with pytest"
echo "   - Type checking and linting"
echo "   - Virtual environment setup"
echo ""
echo "2) 💻 C++ Development Demo"
echo "   - Modern C++17 project"
echo "   - Header/source separation"
echo "   - Makefile build system"
echo "   - Clangd LSP integration"
echo ""
echo "3) 📊 MATLAB Development Demo"
echo "   - Signal processing examples"
echo "   - Section-based development"
echo "   - MATLAB classes and functions"
echo "   - Professional documentation"
echo ""
echo "4) 📚 Show all demos documentation"
echo ""
echo "5) ❌ Exit"
echo ""

read -p "Enter your choice (1-5): " choice

case $choice in
  1)
    echo "Setting up Python development demo..."
    ./python_demo_setup.sh
    echo ""
    echo "✅ Python demo ready! Run: cd ~/python_demo && nvim main.py"
    ;;
  2)
    echo "Setting up C++ development demo..."
    ./cpp_demo_setup.sh
    echo ""
    echo "✅ C++ demo ready! Run: cd ~/cpp_demo && nvim main.cpp"
    ;;
  3)
    echo "Setting up MATLAB development demo..."
    ./matlab_demo_setup.sh
    echo ""
    echo "✅ MATLAB demo ready! Run: cd ~/matlab_demo && nvim signal_analysis_demo.m"
    ;;
  4)
    echo "Opening demos documentation..."
    if command -v nvim &> /dev/null; then
      nvim README.md
    else
      cat README.md
    fi
    ;;
  5)
    echo "Goodbye! 👋"
    exit 0
    ;;
  *)
    echo "Invalid choice. Please run the script again and choose 1-5."
    exit 1
    ;;
esac
