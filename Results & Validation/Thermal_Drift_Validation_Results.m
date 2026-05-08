%% BMI270 Thermal Analysis: Professional Multi-Color Validation
clc; clear; close all;

% 1. File Selection
[fileC, pathC] = uigetfile('*.csv', 'Select COLD test CSV');
[fileH, pathH] = uigetfile('*.csv', 'Select HOT test CSV');
if isequal(fileC, 0) || isequal(fileH, 0), return; end

% 2. Load and Clean Data
coldData = filterSevenCols(fullfile(pathC, fileC));
hotData = filterSevenCols(fullfile(pathH, fileH));

% 3. Process Data
combinedData = [coldData; hotData];
T = combinedData(:, 1);
Gyr = combinedData(:, 5:7);
AccCold = coldData(:, 2:4) * 4.0;
AccHot = hotData(:, 2:4) * 4.0;

% Vector Magnitude calculation
magCold = sqrt(sum(AccCold.^2, 2));
magHot = sqrt(sum(AccHot.^2, 2));

% --- PROFESSIONAL COLOR PALETTE ---
colors = [0.00, 0.45, 0.74;  % Professional Blue (X)
          0.85, 0.33, 0.10;  % Professional Orange (Y)
          0.47, 0.67, 0.19]; % Professional Green (Z)
axisNames = {'X-Axis', 'Y-Axis', 'Z-Axis'};

%% 4. Gyroscope Bias Drift Analysis (Colourful & Styled)
fig1 = figure('Name', 'Gyroscope Thermal Bias Drift', 'Color', 'w', 'Position', [100 100 1000 900]);
sgtitle('BMI270 Gyroscope: Thermal Bias Drift Characterization', 'FontSize', 16, 'FontWeight', 'bold');

for i = 1:3
    p = polyfit(T, Gyr(:, i), 1);
    
    subplot(3, 1, i);
    % Plot raw data with transparency (scatter) for a professional look
    scatter(T, Gyr(:, i), 10, colors(i,:), 'filled', 'MarkerFaceAlpha', 0.15); hold on;
    
    % Plot thick regression line
    plot(T, polyval(p, T), 'r-', 'LineWidth', 2.5);
    
    grid on; ax = gca; ax.GridLineStyle = ':'; ax.GridAlpha = 0.4;
    title(['\color[rgb]{' num2str(colors(i,:)) '}' axisNames{i} ' Drift: ' num2str(p(1), '%.6f') ' dps/°C'], 'FontSize', 12);
    ylabel('Bias (deg/s)');
    if i == 3, xlabel('Internal Die Temperature (°C)'); end
    
    % Add a textbox with the equation
    text(min(T)+1, max(Gyr(:,i)), sprintf('y = %.4fx + %.4f', p(1), p(2)), ...
        'Color', 'r', 'FontWeight', 'bold', 'VerticalAlignment', 'top');
end

%% 5. Accelerometer Magnitude Validation (High Contrast)
fig2 = figure('Name', 'Accelerometer Magnitude', 'Color', 'w', 'Position', [150 150 900 500]);
hold on;

% Use "Cool" blue for cold and "Vibrant" orange for hot
s1 = scatter(coldData(:,1), magCold, 15, [0 0.75 1], 'filled', 'MarkerFaceAlpha', 0.4, 'DisplayName', 'Cold Environment (~13°C)');
s2 = scatter(hotData(:,1), magHot, 15, [1 0.4 0], 'filled', 'MarkerFaceAlpha', 0.4, 'DisplayName', 'Hot Environment (~49°C)');

% Ideal 1.0g Reference Line
yline(1.0, 'k--', 'Ideal Gravity (1.0g)', 'LineWidth', 2, 'LabelHorizontalAlignment', 'left');

% Calculate Stats for the legend
sensitivityShift = ((mean(magHot) - mean(magCold)) / mean(magCold)) * 100;

grid on; box on;
title(['Accelerometer Vector Magnitude: ' num2str(sensitivityShift, '%.2f') '% Thermal Sensitivity Shift'], 'FontSize', 14);
xlabel('Temperature (°C)');
ylabel('Total G-Force (g)');
legend('show', 'Location', 'southoutside', 'Orientation', 'horizontal');

% Clean formatting
set(gca, 'FontSize', 11);
fprintf('\nSuccess: Graphs generated with professional styling.\n');

%% Helper Function
function data = filterSevenCols(filePath)
    opts = detectImportOptions(filePath, 'FileType', 'text');
    opts.DataLines = 2;
    T_raw = readtable(filePath, opts);
    rawArray = table2array(T_raw);
    if size(rawArray, 2) > 7, rawArray = rawArray(:, 1:7); end
    data = rawArray(all(~isnan(rawArray), 2) & rawArray(:,1) > 0, :);
end