#!/bin/bash

# C++ Development Setup Demo
# This script demonstrates the C++ development capabilities

echo "🚀 C++ Development Setup Demo"
echo ""

# Create a demo directory
mkdir -p ~/cpp_demo
cd ~/cpp_demo

echo "📁 Creating demo C++ project in ~/cpp_demo"

# Create a simple C++ project structure
cat > main.cpp << 'EOF'
#include <iostream>
#include <vector>
#include <string>
#include "calculator.h"

int main() {
    std::cout << "C++ Development Demo\n";
    
    Calculator calc;
    
    // Test basic operations
    std::cout << "5 + 3 = " << calc.add(5, 3) << std::endl;
    std::cout << "10 - 4 = " << calc.subtract(10, 4) << std::endl;
    std::cout << "6 * 7 = " << calc.multiply(6, 7) << std::endl;
    std::cout << "15 / 3 = " << calc.divide(15, 3) << std::endl;
    
    // Test with vectors
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    std::cout << "Sum of vector: " << calc.sum_vector(numbers) << std::endl;
    
    return 0;
}
EOF

cat > calculator.h << 'EOF'
#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <vector>

class Calculator {
public:
    Calculator();
    ~Calculator();
    
    // Basic operations
    double add(double a, double b);
    double subtract(double a, double b);
    double multiply(double a, double b);
    double divide(double a, double b);
    
    // Advanced operations
    double sum_vector(const std::vector<int>& numbers);
    
private:
    // Private members
    int operation_count;
};

#endif // CALCULATOR_H
EOF

cat > calculator.cpp << 'EOF'
#include "calculator.h"
#include <stdexcept>
#include <numeric>

Calculator::Calculator() : operation_count(0) {
    // Constructor
}

Calculator::~Calculator() {
    // Destructor
}

double Calculator::add(double a, double b) {
    operation_count++;
    return a + b;
}

double Calculator::subtract(double a, double b) {
    operation_count++;
    return a - b;
}

double Calculator::multiply(double a, double b) {
    operation_count++;
    return a * b;
}

double Calculator::divide(double a, double b) {
    if (b == 0) {
        throw std::runtime_error("Division by zero");
    }
    operation_count++;
    return a / b;
}

double Calculator::sum_vector(const std::vector<int>& numbers) {
    operation_count++;
    return std::accumulate(numbers.begin(), numbers.end(), 0);
}
EOF

# Create a Makefile for easy compilation
cat > Makefile << 'EOF'
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -g
TARGET = calculator_demo
SOURCES = main.cpp calculator.cpp

$(TARGET): $(SOURCES)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SOURCES)

clean:
	rm -f $(TARGET)

.PHONY: clean
EOF

echo ""
echo "📋 Demo project created with:"
echo "  - main.cpp (main program)"
echo "  - calculator.h (header file)"
echo "  - calculator.cpp (implementation)"
echo "  - Makefile (build system)"
echo ""

echo "🔧 Now open Neovim and try these features:"
echo ""
echo "1. Open the project:"
echo "   cd ~/cpp_demo && nvim main.cpp"
echo ""
echo "2. Language Server Features (automatic):"
echo "   - Hover over functions: K"
echo "   - Go to definition: gd"
echo "   - Find references: gr"
echo "   - Rename symbol: <leader>rn"
echo "   - Code actions: <leader>ca"
echo "   - Format code: <leader>f"
echo ""
echo "3. C++ Specific Features:"
echo "   - Switch header/source: <leader>ch"
echo "   - Symbol info: <leader>cs"
echo "   - Type hierarchy: <leader>ct"
echo ""
echo "4. Build and Run:"
echo "   - Compile: :CppCompile"
echo "   - Run: :CppRun"
echo "   - Compile and run: :CppCompileRun"
echo ""
echo "5. Header file features (open calculator.h):"
echo "   - Insert header guard: :HeaderGuard"
echo "   - Insert class template: :ClassTemplate"
echo ""
echo "6. Auto-formatting:"
echo "   - Code is automatically formatted on save"
echo "   - Manual format: <leader>f"
echo ""

echo "🎉 C++ development environment is ready!"
echo "   Tools installed: clangd (LSP), clang-format (formatter), codelldb (debugger)"
echo ""
echo "💡 Pro tip: Use <leader>ff to quickly find files in your project"
echo "   and <leader>fg to search for text across all files"
