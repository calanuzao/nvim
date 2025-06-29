#!/bin/bash

# Python Development Setup Demo
# This script demonstrates the Python development capabilities

echo "🐍 Python Development Setup Demo"
echo ""

# Create a demo directory
mkdir -p ~/python_demo
cd ~/python_demo

echo "📁 Creating demo Python project in ~/python_demo"

# Create a simple Python project structure
cat > main.py << 'EOF'
#!/usr/bin/env python3
"""
Python Development Demo
A simple calculator with data analysis features
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from typing import List, Union
from calculator import Calculator


def main():
    """Main function demonstrating Python features."""
    print("🐍 Python Development Demo")
    
    # Test basic calculator
    calc = Calculator()
    
    print(f"5 + 3 = {calc.add(5, 3)}")
    print(f"10 - 4 = {calc.subtract(10, 4)}")
    print(f"6 * 7 = {calc.multiply(6, 7)}")
    print(f"15 / 3 = {calc.divide(15, 3)}")
    
    # Test with lists
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    print(f"Sum of {numbers}: {calc.sum_list(numbers)}")
    print(f"Mean: {calc.mean(numbers):.2f}")
    print(f"Standard deviation: {calc.std_dev(numbers):.2f}")
    
    # Data analysis example
    data_analysis_demo()
    
    # Plotting example
    plotting_demo()


def data_analysis_demo():
    """Demonstrate pandas data analysis."""
    print("\n📊 Data Analysis Demo")
    
    # Create sample data
    data = {
        'x': np.linspace(0, 10, 100),
        'y': np.sin(np.linspace(0, 10, 100)) + np.random.normal(0, 0.1, 100),
        'category': np.random.choice(['A', 'B', 'C'], 100)
    }
    
    df = pd.DataFrame(data)
    
    print("Dataset summary:")
    print(df.describe())
    
    print("\nGrouped statistics:")
    print(df.groupby('category')['y'].agg(['mean', 'std']))


def plotting_demo():
    """Demonstrate matplotlib plotting."""
    print("\n📈 Plotting Demo")
    
    x = np.linspace(0, 2*np.pi, 100)
    y1 = np.sin(x)
    y2 = np.cos(x)
    
    plt.figure(figsize=(10, 6))
    plt.plot(x, y1, label='sin(x)', linewidth=2)
    plt.plot(x, y2, label='cos(x)', linewidth=2)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('Trigonometric Functions')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.savefig('trig_functions.png', dpi=150, bbox_inches='tight')
    plt.close()
    
    print("Plot saved as 'trig_functions.png'")


if __name__ == "__main__":
    main()
EOF

cat > calculator.py << 'EOF'
"""
Calculator module with basic and advanced operations.
"""

from typing import List, Union
import statistics
import math


class Calculator:
    """A calculator class with basic and statistical operations."""
    
    def __init__(self):
        """Initialize calculator."""
        self.operation_count = 0
        self.history = []
    
    def add(self, a: float, b: float) -> float:
        """Add two numbers."""
        result = a + b
        self._record_operation(f"{a} + {b} = {result}")
        return result
    
    def subtract(self, a: float, b: float) -> float:
        """Subtract b from a."""
        result = a - b
        self._record_operation(f"{a} - {b} = {result}")
        return result
    
    def multiply(self, a: float, b: float) -> float:
        """Multiply two numbers."""
        result = a * b
        self._record_operation(f"{a} * {b} = {result}")
        return result
    
    def divide(self, a: float, b: float) -> float:
        """Divide a by b."""
        if b == 0:
            raise ValueError("Division by zero is not allowed")
        result = a / b
        self._record_operation(f"{a} / {b} = {result}")
        return result
    
    def power(self, base: float, exponent: float) -> float:
        """Raise base to the power of exponent."""
        result = math.pow(base, exponent)
        self._record_operation(f"{base} ^ {exponent} = {result}")
        return result
    
    def sqrt(self, number: float) -> float:
        """Calculate square root."""
        if number < 0:
            raise ValueError("Cannot calculate square root of negative number")
        result = math.sqrt(number)
        self._record_operation(f"√{number} = {result}")
        return result
    
    def sum_list(self, numbers: List[Union[int, float]]) -> float:
        """Calculate sum of a list of numbers."""
        result = sum(numbers)
        self._record_operation(f"sum({numbers}) = {result}")
        return result
    
    def mean(self, numbers: List[Union[int, float]]) -> float:
        """Calculate mean of a list of numbers."""
        if not numbers:
            raise ValueError("Cannot calculate mean of empty list")
        result = statistics.mean(numbers)
        self._record_operation(f"mean({numbers}) = {result}")
        return result
    
    def median(self, numbers: List[Union[int, float]]) -> float:
        """Calculate median of a list of numbers."""
        if not numbers:
            raise ValueError("Cannot calculate median of empty list")
        result = statistics.median(numbers)
        self._record_operation(f"median({numbers}) = {result}")
        return result
    
    def std_dev(self, numbers: List[Union[int, float]]) -> float:
        """Calculate standard deviation of a list of numbers."""
        if len(numbers) < 2:
            raise ValueError("Need at least 2 numbers for standard deviation")
        result = statistics.stdev(numbers)
        self._record_operation(f"stdev({numbers}) = {result}")
        return result
    
    def _record_operation(self, operation: str) -> None:
        """Record operation in history."""
        self.operation_count += 1
        self.history.append(operation)
    
    def get_history(self) -> List[str]:
        """Get operation history."""
        return self.history.copy()
    
    def clear_history(self) -> None:
        """Clear operation history."""
        self.history.clear()
        self.operation_count = 0
EOF

cat > test_calculator.py << 'EOF'
"""
Unit tests for the calculator module.
"""

import unittest
import math
from calculator import Calculator


class TestCalculator(unittest.TestCase):
    """Test cases for Calculator class."""
    
    def setUp(self):
        """Set up test calculator."""
        self.calc = Calculator()
    
    def test_add(self):
        """Test addition."""
        self.assertEqual(self.calc.add(2, 3), 5)
        self.assertEqual(self.calc.add(-1, 1), 0)
        self.assertAlmostEqual(self.calc.add(0.1, 0.2), 0.3, places=10)
    
    def test_subtract(self):
        """Test subtraction."""
        self.assertEqual(self.calc.subtract(5, 3), 2)
        self.assertEqual(self.calc.subtract(0, 5), -5)
    
    def test_multiply(self):
        """Test multiplication."""
        self.assertEqual(self.calc.multiply(3, 4), 12)
        self.assertEqual(self.calc.multiply(-2, 3), -6)
        self.assertEqual(self.calc.multiply(0, 100), 0)
    
    def test_divide(self):
        """Test division."""
        self.assertEqual(self.calc.divide(10, 2), 5)
        self.assertAlmostEqual(self.calc.divide(1, 3), 1/3, places=10)
        
        with self.assertRaises(ValueError):
            self.calc.divide(5, 0)
    
    def test_power(self):
        """Test power operation."""
        self.assertEqual(self.calc.power(2, 3), 8)
        self.assertEqual(self.calc.power(5, 0), 1)
        self.assertAlmostEqual(self.calc.power(4, 0.5), 2, places=10)
    
    def test_sqrt(self):
        """Test square root."""
        self.assertEqual(self.calc.sqrt(4), 2)
        self.assertEqual(self.calc.sqrt(0), 0)
        self.assertAlmostEqual(self.calc.sqrt(2), math.sqrt(2), places=10)
        
        with self.assertRaises(ValueError):
            self.calc.sqrt(-1)
    
    def test_sum_list(self):
        """Test list sum."""
        self.assertEqual(self.calc.sum_list([1, 2, 3, 4]), 10)
        self.assertEqual(self.calc.sum_list([]), 0)
        self.assertEqual(self.calc.sum_list([-1, 1]), 0)
    
    def test_mean(self):
        """Test mean calculation."""
        self.assertEqual(self.calc.mean([1, 2, 3, 4, 5]), 3)
        self.assertEqual(self.calc.mean([10]), 10)
        
        with self.assertRaises(ValueError):
            self.calc.mean([])
    
    def test_history(self):
        """Test operation history."""
        self.calc.add(1, 2)
        self.calc.multiply(3, 4)
        
        history = self.calc.get_history()
        self.assertEqual(len(history), 2)
        self.assertIn("1 + 2 = 3", history[0])
        self.assertIn("3 * 4 = 12", history[1])
        
        self.calc.clear_history()
        self.assertEqual(len(self.calc.get_history()), 0)


if __name__ == '__main__':
    unittest.main()
EOF

cat > requirements.txt << 'EOF'
numpy>=1.21.0
pandas>=1.3.0
matplotlib>=3.4.0
pytest>=6.0.0
black>=21.0.0
isort>=5.0.0
pylint>=2.0.0
mypy>=0.900
debugpy>=1.6.0
EOF

cat > .pylintrc << 'EOF'
[MESSAGES CONTROL]
disable=missing-docstring,too-few-public-methods,invalid-name

[FORMAT]
max-line-length=88
EOF

cat > pyproject.toml << 'EOF'
[tool.black]
line-length = 88
target-version = ['py38']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
EOF

# Create virtual environment setup script
cat > setup_venv.sh << 'EOF'
#!/bin/bash
echo "Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo "Virtual environment setup complete!"
echo "Activate with: source venv/bin/activate"
EOF

chmod +x setup_venv.sh

echo ""
echo "📋 Demo project created with:"
echo "  - main.py (main program with data analysis)"
echo "  - calculator.py (calculator class with type hints)"
echo "  - test_calculator.py (unit tests)"
echo "  - requirements.txt (dependencies)"
echo "  - .pylintrc (linting configuration)"
echo "  - pyproject.toml (tool configuration)"
echo "  - setup_venv.sh (virtual environment setup)"
echo ""

echo "🔧 Setup virtual environment (recommended):"
echo "   ./setup_venv.sh"
echo "   source venv/bin/activate"
echo ""

echo "🔧 Now open Neovim and try these features:"
echo ""
echo "1. Open the project:"
echo "   cd ~/python_demo && nvim main.py"
echo ""
echo "2. Language Server Features (Pyright + Ruff, automatic):"
echo "   - Hover over functions: K"
echo "   - Go to definition: gd"
echo "   - Find references: gr"
echo "   - Rename symbol: <leader>rn"
echo "   - Code actions: <leader>ca"
echo "   - Format code: <leader>f"
echo "   - Organize imports: <leader>pi"
echo ""
echo "3. Python Development Commands:"
echo "   - Run file: :PyRun"
echo "   - Run in terminal: :PyRunAsync"
echo "   - Run tests: :PyTest"
echo "   - Run all tests: :PyTestAll"
echo "   - Format with Black: :PyFormat"
echo "   - Lint with pylint: :PyLint"
echo "   - Profile code: :PyProfile"
echo ""
echo "4. Debugging:"
echo "   - Insert breakpoint: <leader>pd"
echo "   - Insert pprint: <leader>pp"
echo "   - Debug with DAP: <F5>"
echo ""
echo "5. Quick abbreviations (in insert mode):"
echo "   - pdb<space> → import pdb; pdb.set_trace()"
echo "   - np<space> → import numpy as np"
echo "   - pd<space> → import pandas as pd"
echo "   - plt<space> → import matplotlib.pyplot as plt"
echo ""

echo "🎉 Python development environment is ready!"
echo "   Tools installed: pyright, ruff-lsp, black, isort, pylint, mypy, debugpy"
echo ""
echo "💡 Pro tip: Use <leader>ff to quickly find files and <leader>fg to search code"
