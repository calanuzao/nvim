#!/bin/bash

# MATLAB Development Setup Demo
# This script demonstrates the MATLAB development capabilities

echo "📊 MATLAB Development Setup Demo"
echo ""

# Create a demo directory
mkdir -p ~/matlab_demo
cd ~/matlab_demo

echo "📁 Creating demo MATLAB project in ~/matlab_demo"

# Create a main MATLAB script with sections
cat > signal_analysis_demo.m << 'EOF'
%% Signal Analysis Demo
% This script demonstrates MATLAB development features in Neovim
% Author: MATLAB Developer
% Date: $(date +%Y-%m-%d)

clear; close all; clc;

%% Section 1: Generate Test Signals
fprintf('🔊 Generating test signals...\n');

% Parameters
fs = 1000;              % Sampling frequency (Hz)
t = 0:1/fs:2-1/fs;      % Time vector (2 seconds)
f1 = 50;                % First frequency component
f2 = 120;               % Second frequency component

% Create composite signal with noise
signal_clean = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);
noise = 0.2*randn(size(t));
signal_noisy = signal_clean + noise;

fprintf('Generated signals with fs = %d Hz\n', fs);
fprintf('Signal length: %d samples (%.2f seconds)\n', length(t), t(end));

%% Section 2: Time Domain Analysis
fprintf('\n📈 Performing time domain analysis...\n');

% Calculate basic statistics
mean_val = mean(signal_noisy);
std_val = std(signal_noisy);
rms_val = rms(signal_noisy);
peak_val = max(abs(signal_noisy));

fprintf('Signal Statistics:\n');
fprintf('  Mean: %.4f\n', mean_val);
fprintf('  Std:  %.4f\n', std_val);
fprintf('  RMS:  %.4f\n', rms_val);
fprintf('  Peak: %.4f\n', peak_val);

% Plot time domain signals
figure('Name', 'Time Domain Analysis', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
plot(t, signal_clean, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Amplitude');
title('Clean Signal'); grid on;

subplot(1, 3, 2);
plot(t, signal_noisy, 'r-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Noisy Signal'); grid on;

subplot(1, 3, 3);
plot(t, noise, 'g-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Noise Component'); grid on;

%% Section 3: Frequency Domain Analysis
fprintf('\n🔍 Performing frequency domain analysis...\n');

% Compute FFT
N = length(signal_noisy);
Y = fft(signal_noisy);
f = (0:N-1)*(fs/N);

% Single-sided spectrum
P1 = abs(Y/N);
P1 = P1(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f_single = f(1:N/2+1);

% Find peaks
[peaks, locs] = findpeaks(P1, 'MinPeakHeight', 0.1);
peak_freqs = f_single(locs);

fprintf('Detected frequency components:\n');
for i = 1:length(peak_freqs)
    fprintf('  Peak %d: %.1f Hz (Amplitude: %.3f)\n', i, peak_freqs(i), peaks(i));
end

% Plot frequency domain
figure('Name', 'Frequency Domain Analysis', 'Position', [200, 200, 800, 600]);

subplot(2, 1, 1);
plot(f_single, P1, 'b-', 'LineWidth', 1.5);
hold on;
plot(peak_freqs, peaks, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Frequency (Hz)'); ylabel('|P1(f)|');
title('Single-Sided Amplitude Spectrum'); grid on;
legend('Spectrum', 'Detected Peaks');

subplot(2, 1, 2);
spectrogram(signal_noisy, hamming(256), 128, 512, fs, 'yaxis');
title('Spectrogram');

%% Section 4: Digital Filtering
fprintf('\n🔧 Applying digital filters...\n');

% Design lowpass filter
fc = 80;  % Cutoff frequency
[b, a] = butter(4, fc/(fs/2), 'low');

% Apply filter
signal_filtered = filtfilt(b, a, signal_noisy);

% Calculate filter performance
noise_power_before = var(signal_noisy - signal_clean);
noise_power_after = var(signal_filtered - signal_clean);
snr_improvement = 10*log10(noise_power_before/noise_power_after);

fprintf('Filter Performance:\n');
fprintf('  Cutoff frequency: %.1f Hz\n', fc);
fprintf('  SNR improvement: %.2f dB\n', snr_improvement);

% Plot filtering results
figure('Name', 'Digital Filtering Results', 'Position', [300, 300, 1000, 600]);

subplot(2, 2, 1);
plot(t, signal_clean, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Amplitude');
title('Original Clean Signal'); grid on;

subplot(2, 2, 2);
plot(t, signal_noisy, 'r-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Noisy Signal'); grid on;

subplot(2, 2, 3);
plot(t, signal_filtered, 'g-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Amplitude');
title('Filtered Signal'); grid on;

subplot(2, 2, 4);
plot(t, signal_clean, 'b-', t, signal_filtered, 'g--', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Amplitude');
title('Clean vs Filtered'); grid on;
legend('Original', 'Filtered');

%% Section 5: Advanced Analysis
fprintf('\n🧮 Performing advanced analysis...\n');

% Autocorrelation
[acf, lags] = xcorr(signal_noisy, 100, 'coeff');

% Cross-correlation with clean signal
[ccf, ccf_lags] = xcorr(signal_filtered, signal_clean, 100, 'coeff');
[max_ccf, max_idx] = max(ccf);
delay_samples = ccf_lags(max_idx);

fprintf('Correlation Analysis:\n');
fprintf('  Max cross-correlation: %.4f\n', max_ccf);
fprintf('  Delay: %d samples\n', delay_samples);

% Plot correlation results
figure('Name', 'Correlation Analysis', 'Position', [400, 400, 1000, 400]);

subplot(1, 2, 1);
plot(lags, acf, 'b-', 'LineWidth', 1.5);
xlabel('Lag'); ylabel('Autocorrelation');
title('Autocorrelation of Noisy Signal'); grid on;

subplot(1, 2, 2);
plot(ccf_lags, ccf, 'r-', 'LineWidth', 1.5);
hold on;
plot(delay_samples, max_ccf, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
xlabel('Lag'); ylabel('Cross-correlation');
title('Cross-correlation (Filtered vs Clean)'); grid on;
legend('CCF', 'Maximum');

%% Section 6: Save Results
fprintf('\n💾 Saving results...\n');

% Save data
save('signal_analysis_results.mat', 'signal_clean', 'signal_noisy', ...
     'signal_filtered', 't', 'fs', 'f_single', 'P1');

% Export figures
try
    exportgraphics(gcf, 'correlation_analysis.png', 'Resolution', 300);
    fprintf('Figures saved successfully!\n');
catch ME
    fprintf('Warning: Could not save figures - %s\n', ME.message);
end

fprintf('\n✅ Signal analysis complete!\n');
fprintf('Check the workspace for variables and generated plots.\n');
EOF

# Create a MATLAB function file
cat > butter_bandpass.m << 'EOF'
function [b, a] = butter_bandpass(low_freq, high_freq, fs, order)
%BUTTER_BANDPASS Design a Butterworth bandpass filter
%
% Syntax:
%   [b, a] = butter_bandpass(low_freq, high_freq, fs, order)
%
% Inputs:
%   low_freq  - Lower cutoff frequency (Hz)
%   high_freq - Higher cutoff frequency (Hz)
%   fs        - Sampling frequency (Hz)
%   order     - Filter order (default: 4)
%
% Outputs:
%   b - Numerator coefficients
%   a - Denominator coefficients
%
% Example:
%   [b, a] = butter_bandpass(10, 100, 1000, 6);
%   freqz(b, a, 512, 1000);
%
% Author: MATLAB Developer
% Date: $(date +%Y-%m-%d)

if nargin < 4
    order = 4;
end

% Validate inputs
if low_freq >= high_freq
    error('Lower frequency must be less than higher frequency');
end

if high_freq >= fs/2
    error('Higher frequency must be less than Nyquist frequency');
end

% Normalize frequencies
Wn = [low_freq, high_freq] / (fs/2);

% Design filter
[b, a] = butter(order, Wn, 'bandpass');

end
EOF

# Create a MATLAB class file
cat > SignalProcessor.m << 'EOF'
classdef SignalProcessor < handle
    %SIGNALPROCESSOR A class for digital signal processing operations
    %   This class provides methods for common signal processing tasks
    %   including filtering, spectral analysis, and feature extraction.
    
    properties (Access = private)
        sample_rate
        buffer_size
        window_type
    end
    
    properties (Access = public)
        verbose = false;
    end
    
    methods
        function obj = SignalProcessor(fs, buffer_size, window_type)
            %SIGNALPROCESSOR Constructor
            %   obj = SignalProcessor(fs, buffer_size, window_type)
            
            if nargin < 1, fs = 1000; end
            if nargin < 2, buffer_size = 1024; end
            if nargin < 3, window_type = 'hamming'; end
            
            obj.sample_rate = fs;
            obj.buffer_size = buffer_size;
            obj.window_type = window_type;
            
            if obj.verbose
                fprintf('SignalProcessor initialized:\n');
                fprintf('  Sample rate: %d Hz\n', fs);
                fprintf('  Buffer size: %d samples\n', buffer_size);
                fprintf('  Window type: %s\n', window_type);
            end
        end
        
        function [filtered_signal, b, a] = apply_filter(obj, signal, filter_type, frequencies, order)
            %APPLY_FILTER Apply digital filter to signal
            
            if nargin < 5, order = 4; end
            
            switch lower(filter_type)
                case 'lowpass'
                    [b, a] = butter(order, frequencies/(obj.sample_rate/2), 'low');
                case 'highpass'
                    [b, a] = butter(order, frequencies/(obj.sample_rate/2), 'high');
                case 'bandpass'
                    [b, a] = butter(order, frequencies/(obj.sample_rate/2), 'bandpass');
                case 'bandstop'
                    [b, a] = butter(order, frequencies/(obj.sample_rate/2), 'stop');
                otherwise
                    error('Unknown filter type: %s', filter_type);
            end
            
            filtered_signal = filtfilt(b, a, signal);
            
            if obj.verbose
                fprintf('Applied %s filter (order %d)\n', filter_type, order);
            end
        end
        
        function [psd, f] = compute_psd(obj, signal)
            %COMPUTE_PSD Compute power spectral density
            
            [psd, f] = pwelch(signal, obj.get_window(), [], [], obj.sample_rate);
            
            if obj.verbose
                fprintf('Computed PSD using %s window\n', obj.window_type);
            end
        end
        
        function features = extract_features(obj, signal)
            %EXTRACT_FEATURES Extract common signal features
            
            features = struct();
            features.mean = mean(signal);
            features.std = std(signal);
            features.rms = rms(signal);
            features.peak = max(abs(signal));
            features.energy = sum(signal.^2);
            features.zero_crossings = obj.count_zero_crossings(signal);
            
            % Spectral features
            [psd, f] = obj.compute_psd(signal);
            features.spectral_centroid = sum(f .* psd) / sum(psd);
            features.spectral_bandwidth = sqrt(sum(((f - features.spectral_centroid).^2) .* psd) / sum(psd));
            
            if obj.verbose
                fprintf('Extracted %d features\n', length(fieldnames(features)));
            end
        end
    end
    
    methods (Access = private)
        function window = get_window(obj)
            %GET_WINDOW Get window function
            
            switch lower(obj.window_type)
                case 'hamming'
                    window = hamming(obj.buffer_size);
                case 'hanning'
                    window = hanning(obj.buffer_size);
                case 'blackman'
                    window = blackman(obj.buffer_size);
                case 'rectangular'
                    window = rectwin(obj.buffer_size);
                otherwise
                    window = hamming(obj.buffer_size);
            end
        end
        
        function count = count_zero_crossings(~, signal)
            %COUNT_ZERO_CROSSINGS Count zero crossings in signal
            
            sign_changes = diff(sign(signal));
            count = sum(sign_changes ~= 0);
        end
    end
end
EOF

# Create a test script
cat > test_signal_processor.m << 'EOF'
%% Test Script for SignalProcessor Class
% This script tests the SignalProcessor class functionality

clear; close all; clc;

fprintf('🧪 Testing SignalProcessor Class\n');
fprintf('================================\n\n');

%% Test 1: Constructor
fprintf('Test 1: Constructor\n');
processor = SignalProcessor(1000, 512, 'hamming');
processor.verbose = true;

%% Test 2: Generate test signal
fprintf('\nTest 2: Generate test signal\n');
fs = 1000;
t = 0:1/fs:1-1/fs;
test_signal = sin(2*pi*50*t) + 0.5*sin(2*pi*150*t) + 0.1*randn(size(t));

%% Test 3: Apply filters
fprintf('\nTest 3: Apply filters\n');
[lowpass_signal, ~, ~] = processor.apply_filter(test_signal, 'lowpass', 80, 4);
[highpass_signal, ~, ~] = processor.apply_filter(test_signal, 'highpass', 20, 4);
[bandpass_signal, ~, ~] = processor.apply_filter(test_signal, 'bandpass', [40, 60], 4);

%% Test 4: Compute PSD
fprintf('\nTest 4: Compute PSD\n');
[psd, f] = processor.compute_psd(test_signal);

%% Test 5: Extract features
fprintf('\nTest 5: Extract features\n');
features = processor.extract_features(test_signal);

fprintf('Extracted features:\n');
field_names = fieldnames(features);
for i = 1:length(field_names)
    fprintf('  %s: %.4f\n', field_names{i}, features.(field_names{i}));
end

%% Test 6: Visualization
fprintf('\nTest 6: Create visualizations\n');

figure('Name', 'SignalProcessor Test Results', 'Position', [100, 100, 1200, 800]);

% Time domain plots
subplot(3, 2, 1);
plot(t, test_signal, 'b-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Original Signal'); grid on;

subplot(3, 2, 2);
plot(t, lowpass_signal, 'r-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Lowpass Filtered (80 Hz)'); grid on;

subplot(3, 2, 3);
plot(t, highpass_signal, 'g-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Highpass Filtered (20 Hz)'); grid on;

subplot(3, 2, 4);
plot(t, bandpass_signal, 'm-', 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Bandpass Filtered (40-60 Hz)'); grid on;

% Frequency domain plots
subplot(3, 2, 5);
semilogy(f, psd, 'b-', 'LineWidth', 1.5);
xlabel('Frequency (Hz)'); ylabel('PSD');
title('Power Spectral Density'); grid on;

subplot(3, 2, 6);
bar(1:length(field_names), struct2array(features));
set(gca, 'XTickLabel', field_names, 'XTickLabelRotation', 45);
ylabel('Feature Value'); title('Extracted Features'); grid on;

fprintf('\n✅ All tests completed successfully!\n');
EOF

echo ""
echo "📋 Demo project created with:"
echo "  - signal_analysis_demo.m (comprehensive signal processing demo)"
echo "  - butter_bandpass.m (custom filter function)"
echo "  - SignalProcessor.m (MATLAB class for signal processing)"
echo "  - test_signal_processor.m (test script for the class)"
echo ""

echo "🔧 Now open Neovim and try these features:"
echo ""
echo "1. Open the project:"
echo "   cd ~/matlab_demo && nvim signal_analysis_demo.m"
echo ""
echo "2. MATLAB Section Navigation:"
echo "   - Next section: ]]"
echo "   - Previous section: [["
echo "   - Current section shows in status line"
echo ""
echo "3. MATLAB Execution:"
echo "   - Run entire file: <leader>mr or :MatlabRun"
echo "   - Run current section: <leader>ms or :MatlabRunSection"
echo "   - Debug file: <leader>md or :MatlabDebug"
echo ""
echo "4. MATLAB Development:"
echo "   - Insert function template: <leader>mf"
echo "   - Insert breakpoint: <leader>mb"
echo "   - Insert disp(): <leader>mp"
echo "   - Quick plot: <leader>mP"
echo "   - Help for word: <leader>mh"
echo "   - Documentation: <leader>mD"
echo ""
echo "5. Template Shortcuts (in insert mode):"
echo "   - for<Tab> → for loop template"
echo "   - if<Tab> → if statement template"
echo "   - while<Tab> → while loop template"
echo "   - try<Tab> → try-catch template"
echo ""
echo "6. MATLAB Commands:"
echo "   - :MatlabLint (run Code Analyzer)"
echo "   - :MatlabProfile (profile code)"
echo "   - :MatlabFunction (insert function template)"
echo "   - :MatlabToggleFunction (toggle script/function)"
echo ""

echo "🎉 MATLAB development environment is ready!"
echo ""
echo "💡 Pro tips:"
echo "   - Use %% to create sections that can be run independently"
echo "   - Fold code by sections with zc/zo (close/open fold)"
echo "   - Use <leader>ff to quickly find files in your project"
echo ""
echo "⚠️  Note: MATLAB must be installed and available in PATH for execution features"
