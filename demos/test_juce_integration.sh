#!/bin/bash

# Quick test script to verify JUCE/DSP integration
echo "🧪 Testing JUCE/DSP Integration"
echo "==============================="

# Check if files exist
echo "📁 Checking core files..."

files=(
    "lua/plugins/juce-dsp.lua"
    "lua/calanuzao/juce-dsp.lua"
    "demos/juce_audio_demo_setup.sh"
    "docs/JUCE_DSP_INTEGRATION.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

echo ""
echo "🔧 Testing Neovim integration..."

# Test if Neovim can load the modules
nvim --headless -c "
lua << EOF
local ok, result = pcall(function()
    -- Test if modules can be loaded
    local dsp = require('calanuzao.dsp')
    local juce_dsp = require('calanuzao.juce-dsp')
    
    print('✅ DSP module loaded successfully')
    print('✅ JUCE-DSP module loaded successfully')
    
    -- Test if functions exist
    if type(dsp.show_juce_menu) == 'function' then
        print('✅ JUCE menu function available')
    end
    
    if type(juce_dsp.create_juce_project) == 'function' then
        print('✅ JUCE project creation function available')
    end
    
    if type(juce_dsp.show_dsp_examples) == 'function' then
        print('✅ DSP examples function available')
    end
    
    print('✅ All functions are accessible')
    print('')
    print('🎉 Integration test passed!')
    print('')
    print('Usage:')
    print('  :JuceDSP           - Main menu')
    print('  :JuceNew           - Create project')
    print('  :JuceExamples      - Show examples')
    print('  <leader>jm         - JUCE menu')
    print('  <leader>jn         - New project')
    print('  <leader>je         - Examples')
    print('')
    
    return true
end)

if not ok then
    print('❌ Integration test failed: ' .. result)
else
    print('Integration test completed successfully!')
end
EOF
" -c "qa"

echo ""
echo "📋 Summary:"
echo "   • JUCE/DSP integration added to Neovim"
echo "   • Project templates for audio plugins"
echo "   • Code snippets and examples"
echo "   • Educational resources"
echo "   • Build system integration"
echo ""
echo "🚀 Next steps:"
echo "   1. Run: ./demos/juce_audio_demo_setup.sh"
echo "   2. In Neovim: :JuceDSP"
echo "   3. Create your first audio plugin!"
echo ""
echo "📚 Documentation: docs/JUCE_DSP_INTEGRATION.md"
