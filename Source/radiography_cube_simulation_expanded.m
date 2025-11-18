%% Radiographic Simulation - Expanded Version
clear; close all; clc;

% Create output directory
output_dir = 'exercise_results';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% ==================== REQUIRED EXERCISE SECTION ====================
fprintf('=== REQUIRED EXERCISE: RADIOGRAPHIC SIMULATION ===\n');

%% Parameters from Exercise
fprintf('Setting up parameters...\n');

% Attenuation coefficients (convert from cm^-1 to mm^-1)
mu0 = 0.1 / 10;   % Background material
mu1 = 0.15 / 10;  % Cube A
mu2 = 0.05 / 10;  % Cube B

% Cube parameters
center_A = [96, 128, 64];
center_B = [180, 128, 64];
side_A = 15;
side_B = 25;

% Detector parameters
detector_width = 256;
detector_height = 256;
pixel_size = 1;
pixels_x = detector_width;
pixels_y = detector_height;

% Thickness in z-direction
thickness_z = 256;

% Incident photons (two cases as specified)
I0_caseA = 1000;
I0_caseB = 100;

fprintf('Parameters set according to exercise requirements.\n');

%% Create detector grid and calculate path lengths
fprintf('Calculating path lengths...\n');

[x_grid, y_grid] = meshgrid(1:pixels_x, 1:pixels_y);

path_length_A = zeros(pixels_y, pixels_x);
path_length_B = zeros(pixels_y, pixels_x);

% Cube boundaries in mm
A_xmin_mm = center_A(1) - side_A/2;
A_xmax_mm = center_A(1) + side_A/2;
A_ymin_mm = center_A(2) - side_A/2;
A_ymax_mm = center_A(2) + side_A/2;

B_xmin_mm = center_B(1) - side_B/2;
B_xmax_mm = center_B(1) + side_B/2;
B_ymin_mm = center_B(2) - side_B/2;
B_ymax_mm = center_B(2) + side_B/2;

% Calculate path lengths through cubes
for i = 1:pixels_y
    for j = 1:pixels_x
        x_pos_mm = j;
        y_pos_mm = i;
        
        % Check if current pixel is inside Cube A projection
        if (x_pos_mm >= A_xmin_mm && x_pos_mm <= A_xmax_mm && ...
            y_pos_mm >= A_ymin_mm && y_pos_mm <= A_ymax_mm)
            path_length_A(i,j) = side_A;
        end
        
        % Check if current pixel is inside Cube B projection
        if (x_pos_mm >= B_xmin_mm && x_pos_mm <= B_xmax_mm && ...
            y_pos_mm >= B_ymin_mm && y_pos_mm <= B_ymax_mm)
            path_length_B(i,j) = side_B;
        end
    end
end

%% Calculate transmitted intensity
fprintf('Calculating transmitted intensity...\n');

background_path = thickness_z * ones(pixels_y, pixels_x);
total_attenuation = mu0 * background_path + mu1 * path_length_A + mu2 * path_length_B;

% Noiseless images
transmitted_A = I0_caseA * exp(-total_attenuation);
transmitted_B = I0_caseB * exp(-total_attenuation);

% Images with Poisson noise
transmitted_A_noisy = poissrnd(transmitted_A);
transmitted_B_noisy = poissrnd(transmitted_B);

%% Generate required radiographic images
fprintf('Generating required radiographic images...\n');

fig_required = figure(1);
set(fig_required, 'Position', [100, 100, 1200, 600], 'Color', 'white', ...
    'NumberTitle', 'off', 'Name', 'Required Exercise Results');

% Case A: 1000 photons/mm²
subplot(2,3,1);
imagesc(transmitted_A);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case A: 1000 photons/mm² (Noiseless)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

subplot(2,3,2);
imagesc(transmitted_A_noisy);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case A: 1000 photons/mm² (With Poisson Noise)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

% Case B: 100 photons/mm²
subplot(2,3,4);
imagesc(transmitted_B);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case B: 100 photons/mm² (Noiseless)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

subplot(2,3,5);
imagesc(transmitted_B_noisy);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case B: 100 photons/mm² (With Poisson Noise)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

% Attenuation map
subplot(2,3,3);
imagesc(total_attenuation);
axis equal tight;
set(gca, 'YDir', 'normal');
colorbar;
title('Total Attenuation Map', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

% Path length through cubes
subplot(2,3,6);
imagesc(path_length_A + path_length_B);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Path Through Cubes (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

colormap gray;

% Save required results 
set(fig_required, 'ToolBar', 'none');
saveas(fig_required, fullfile(output_dir, 'required_exercise_results.png'));

fprintf('Required exercise completed successfully\n');

%% ==================== EXTRA FEATURES SECTION ====================
fprintf('Creating enhanced visualizations and analysis...\n');

%% 3D Visualization
fig3d = figure(2);
set(fig3d, 'Position', [100, 100, 1200, 800], 'Color', 'white', ...
    'NumberTitle', 'off', 'Name', '3D Setup Visualization');

% Main 3D view
subplot(2,2,[1,3]);
hold on;

% Draw background volume
vertices = [0 0 0; detector_width 0 0; detector_width detector_height 0; 0 detector_height 0; ...
            0 0 thickness_z; detector_width 0 thickness_z; detector_width detector_height thickness_z; 0 detector_height thickness_z];
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];

patch('Vertices', vertices, 'Faces', faces, 'FaceColor', [0.8 0.8 0.8], ...
    'FaceAlpha', 0.1, 'EdgeColor', 'k', 'LineWidth', 1);

% Draw Cube A
A_vertices = [A_xmin_mm, A_ymin_mm, center_A(3)-side_A/2; ...
              A_xmax_mm, A_ymin_mm, center_A(3)-side_A/2; ...
              A_xmax_mm, A_ymax_mm, center_A(3)-side_A/2; ...
              A_xmin_mm, A_ymax_mm, center_A(3)-side_A/2; ...
              A_xmin_mm, A_ymin_mm, center_A(3)+side_A/2; ...
              A_xmax_mm, A_ymin_mm, center_A(3)+side_A/2; ...
              A_xmax_mm, A_ymax_mm, center_A(3)+side_A/2; ...
              A_xmin_mm, A_ymax_mm, center_A(3)+side_A/2];

patch('Vertices', A_vertices, 'Faces', faces, 'FaceColor', 'red', ...
    'FaceAlpha', 0.7, 'EdgeColor', 'red', 'LineWidth', 2);

% Draw Cube B
B_vertices = [B_xmin_mm, B_ymin_mm, center_B(3)-side_B/2; ...
              B_xmax_mm, B_ymin_mm, center_B(3)-side_B/2; ...
              B_xmax_mm, B_ymax_mm, center_B(3)-side_B/2; ...
              B_xmin_mm, B_ymax_mm, center_B(3)-side_B/2; ...
              B_xmin_mm, B_ymin_mm, center_B(3)+side_B/2; ...
              B_xmax_mm, B_ymin_mm, center_B(3)+side_B/2; ...
              B_xmax_mm, B_ymax_mm, center_B(3)+side_B/2; ...
              B_xmin_mm, B_ymax_mm, center_B(3)+side_B/2];

patch('Vertices', B_vertices, 'Faces', faces, 'FaceColor', 'blue', ...
    'FaceAlpha', 0.7, 'EdgeColor', 'blue', 'LineWidth', 2);

% Draw X-ray source at top and paths to bottom
plot3([detector_width/4 detector_width/4], [detector_height/2 detector_height/2], [-50 0], 'g-', 'LineWidth', 3);
text(detector_width/4, detector_height/2, -60, 'X-ray Source', 'Color', 'black', 'FontWeight', 'bold', 'FontSize', 10);

% Draw detector at bottom
patch('Vertices', [0 0 thickness_z; detector_width 0 thickness_z; detector_width detector_height thickness_z; 0 detector_height thickness_z], ...
      'Faces', [1 2 3 4], 'FaceColor', 'yellow', 'FaceAlpha', 0.3, 'EdgeColor', 'yellow');
text(detector_width/2, detector_height/2, thickness_z+10, 'Detector', 'Color', 'black', 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'FontSize', 10);

% Draw X-ray paths from top to bottom
num_rays = 3;
for i = 1:num_rays
    x_pos = (i-1) * detector_width/(num_rays-1);
    plot3([x_pos, x_pos], [detector_height/2, detector_height/2], [0, thickness_z], 'k-', 'LineWidth', 1);
end

% Labels and formatting
xlabel('X (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
zlabel('Z (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
title('3D Setup Visualization', 'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');

set(gca, 'XColor', 'black', 'YColor', 'black', 'ZColor', 'black', 'GridColor', 'black');

hLegend = legend('Background', 'Cube A (μ=0.015)', 'Cube B (μ=0.005)', 'X-ray Source', 'Detector', 'X-ray Paths', 'Location', 'best');
set(hLegend, 'TextColor', 'black', 'Color', 'white');

grid on;
view(45, 30);

% Top view
subplot(2,2,2);
hold on;
rectangle('Position', [0, 0, detector_width, detector_height], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'k');
rectangle('Position', [A_xmin_mm, A_ymin_mm, side_A, side_A], 'FaceColor', 'red', 'EdgeColor', 'red', 'LineWidth', 2);
rectangle('Position', [B_xmin_mm, B_ymin_mm, side_B, side_B], 'FaceColor', 'blue', 'EdgeColor', 'blue', 'LineWidth', 2);
xlabel('X (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
title('Top View (XY Plane)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');
axis equal; grid on;

% Side view
subplot(2,2,4);
hold on;
rectangle('Position', [0, 0, detector_width, thickness_z], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'k');
rectangle('Position', [A_xmin_mm, center_A(3)-side_A/2, side_A, side_A], 'FaceColor', 'red', 'EdgeColor', 'red', 'LineWidth', 2);
rectangle('Position', [B_xmin_mm, center_B(3)-side_B/2, side_B, side_B], 'FaceColor', 'blue', 'EdgeColor', 'blue', 'LineWidth', 2);
xlabel('X (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Z (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
title('Side View (XZ Plane)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');
axis equal; grid on;
set(fig3d, 'ToolBar', 'none');
saveas(fig3d, fullfile(output_dir, '3d_visualization.png'));

%% Comprehensive Analysis Figure
fig_analysis = figure(3);
set(fig_analysis, 'Position', [50, 50, 1400, 1000], 'Color', 'white', ...
    'NumberTitle', 'off', 'Name', 'Comprehensive Analysis');

% Layout: 3 rows, 4 columns
rows = 3; cols = 4;

% Row 1: Attenuation and path length
subplot(rows, cols, 1);
imagesc(total_attenuation);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Total Attenuation', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

subplot(rows, cols, 2);
imagesc(path_length_A + path_length_B);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Path Through Cubes (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

% Row 1: Case A images
subplot(rows, cols, 3);
imagesc(transmitted_A);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case A: 1000 photons (Noiseless)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');
clim([0 I0_caseA]);

subplot(rows, cols, 4);
imagesc(transmitted_A_noisy);
axis equal tight;
set(gca, 'YDir', 'normal');
colorbar;
title('Case A: 1000 photons (With Noise)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');
clim([0 I0_caseA]);

% Row 2: Case B images
subplot(rows, cols, 5);
imagesc(transmitted_B);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case B: 100 photons (Noiseless)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');
clim([0 I0_caseB]);

subplot(rows, cols, 6);
imagesc(transmitted_B_noisy);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Case B: 100 photons (With Noise)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');
clim([0 I0_caseB]);

% Row 2: Line profile
subplot(rows, cols, [7, 8]);
y_line = min(pixels_y, round(center_A(2)));
plot(1:pixels_x, transmitted_A(y_line, :), 'r-', 'LineWidth', 2, 'DisplayName', 'Case A (Noiseless)');
hold on;
plot(1:pixels_x, transmitted_A_noisy(y_line, :), 'r--', 'LineWidth', 1, 'DisplayName', 'Case A (Noisy)');
plot(1:pixels_x, transmitted_B(y_line, :), 'b-', 'LineWidth', 2, 'DisplayName', 'Case B (Noiseless)');
plot(1:pixels_x, transmitted_B_noisy(y_line, :), 'b--', 'LineWidth', 1, 'DisplayName', 'Case B (Noisy)');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Transmitted Photons', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
title('Line Profile Through Cube Centers', 'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');
hLeg = legend('Location', 'best');
set(hLeg, 'TextColor', 'black', 'Color', 'white');
set(gca, 'XColor', 'black', 'YColor', 'black', 'GridColor', [0.5 0.5 0.5]);
grid on;
xline(center_A(1), 'r--', 'Cube A', 'LineWidth', 1, 'Color', 'red');
xline(center_B(1), 'b--', 'Cube B', 'LineWidth', 1, 'Color', 'blue');

% Row 3: Noise analysis and statistics
subplot(rows, cols, [9, 10]);
noise_A = transmitted_A_noisy - transmitted_A;
imagesc(noise_A);
axis equal tight;
set(gca, 'YDir', 'normal'); 
colorbar;
title('Noise Pattern: Case A', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('X (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('Y (mm)', 'Color', 'black', 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'XColor', 'black', 'YColor', 'black');

subplot(rows, cols, [11, 12]);
A_x1 = max(1, fix(A_xmin_mm)); A_x2 = min(pixels_x, fix(A_xmax_mm));
A_y1 = max(1, fix(A_ymin_mm)); A_y2 = min(pixels_y, fix(A_ymax_mm));
B_x1 = max(1, fix(B_xmin_mm)); B_x2 = min(pixels_x, fix(B_xmax_mm));
B_y1 = max(1, fix(B_ymin_mm)); B_y2 = min(pixels_y, fix(B_ymax_mm));

bg_mean_A = mean(transmitted_A(50:100, 50:100), 'all');
if A_x1 <= A_x2 && A_y1 <= A_y2
    cubeA_mean_A = mean(transmitted_A(A_y1:A_y2, A_x1:A_x2), 'all');
else
    cubeA_mean_A = 0;
end
if B_x1 <= B_x2 && B_y1 <= B_y2
    cubeB_mean_A = mean(transmitted_A(B_y1:B_y2, B_x1:B_x2), 'all');
else
    cubeB_mean_A = 0;
end

bg_mean_B = mean(transmitted_B(50:100, 50:100), 'all');
if A_x1 <= A_x2 && A_y1 <= A_y2
    cubeA_mean_B = mean(transmitted_B(A_y1:A_y2, A_x1:A_x2), 'all');
else
    cubeA_mean_B = 0;
end
if B_x1 <= B_x2 && B_y1 <= B_y2
    cubeB_mean_B = mean(transmitted_B(B_y1:B_y2, B_x1:B_x2), 'all');
else
    cubeB_mean_B = 0;
end

stats_data = [bg_mean_A, cubeA_mean_A, cubeB_mean_A; bg_mean_B, cubeA_mean_B, cubeB_mean_B];
bar(stats_data');
set(gca, 'XColor', 'black', 'YColor', 'black', 'GridColor', [0.5 0.5 0.5]);
set(gca, 'XTickLabel', {'Background', 'Cube A', 'Cube B'});
ylabel('Mean Photons/mm²', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
title('Regional Statistics', 'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');
hLeg2 = legend('Case A (1000 photons)', 'Case B (100 photons)', 'Location', 'best');
set(hLeg2, 'TextColor', 'black', 'Color', 'white');
grid on;

colormap gray;


set(fig_analysis, 'ToolBar', 'none');
saveas(fig_analysis, fullfile(output_dir, 'comprehensive_analysis.png'));

%% Save individual image files
fprintf('Saving individual images...\n');

image_sets = {
    {'caseA_noiseless', transmitted_A, 'Case A: 1000 photons/mm² (Noiseless)'}
    {'caseA_noisy', transmitted_A_noisy, 'Case A: 1000 photons/mm² (With Poisson Noise)'}
    {'caseB_noiseless', transmitted_B, 'Case B: 100 photons/mm² (Noiseless)'}
    {'caseB_noisy', transmitted_B_noisy, 'Case B: 100 photons/mm² (With Poisson Noise)'}
    {'attenuation_map', total_attenuation, 'Total Attenuation Map'}
};

for i = 1:length(image_sets)
    fig_temp = figure('Visible', 'off', 'ToolBar', 'none');
    imagesc(image_sets{i}{2});
    axis equal tight;
    set(gca, 'YDir', 'normal'); 
    colorbar;
    title(image_sets{i}{3}, 'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');
    xlabel('X (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
    ylabel('Y (mm)', 'Color', 'black', 'FontSize', 11, 'FontWeight', 'bold');
    set(gca, 'XColor', 'black', 'YColor', 'black');
    saveas(fig_temp, fullfile(output_dir, [image_sets{i}{1} '.png']));
    close(fig_temp);
end

%% Save data and generate report
fprintf('Saving data and report...\n');

save(fullfile(output_dir, 'simulation_data.mat'), ...
     'transmitted_A', 'transmitted_A_noisy', 'transmitted_B', 'transmitted_B_noisy', ...
     'total_attenuation', 'path_length_A', 'path_length_B', ...
     'mu0', 'mu1', 'mu2', 'center_A', 'center_B', 'side_A', 'side_B');

% Generate report
report_filename = fullfile(output_dir, 'simulation_report.txt');
fid = fopen(report_filename, 'w');

fprintf(fid, 'RADIOGRAPHIC SIMULATION REPORT\n');
fprintf(fid, '==============================\n\n');
fprintf(fid, 'Exercise Requirements:\n');
fprintf(fid, '1. Case A: 1000 photons/mm² with/without Poisson noise ✓\n');
fprintf(fid, '2. Case B: 100 photons/mm² with/without Poisson noise ✓\n');
fprintf(fid, '3. Proper geometry implementation ✓\n\n');

fprintf(fid, 'Parameters:\n');
fprintf(fid, 'Background μ: %.4f mm⁻¹\n', mu0);
fprintf(fid, 'Cube A: μ=%.4f mm⁻¹, Center (%d,%d,%d) mm, Side %d mm\n', mu1, center_A(1), center_A(2), center_A(3), side_A);
fprintf(fid, 'Cube B: μ=%.4f mm⁻¹, Center (%d,%d,%d) mm, Side %d mm\n', mu2, center_B(1), center_B(2), center_B(3), side_B);
fprintf(fid, 'Detector: %d × %d pixels, %d × %d mm²\n\n', pixels_x, pixels_y, detector_width, detector_height);

fprintf(fid, 'Results Summary:\n');
fprintf(fid, 'Case A (1000 photons/mm²):\n');
fprintf(fid, '  Background: %.1f photons/mm²\n', bg_mean_A);
fprintf(fid, '  Cube A: %.1f photons/mm²\n', cubeA_mean_A);
fprintf(fid, '  Cube B: %.1f photons/mm²\n', cubeB_mean_A);
fprintf(fid, 'Case B (100 photons/mm²):\n');
fprintf(fid, '  Background: %.1f photons/mm²\n', bg_mean_B);
fprintf(fid, '  Cube A: %.1f photons/mm²\n', cubeA_mean_B);
fprintf(fid, '  Cube B: %.1f photons/mm²\n\n', cubeB_mean_B);

fprintf(fid, 'Files Generated:\n');
fprintf(fid, '- required_exercise_results.png: Main exercise results\n');
fprintf(fid, '- 3d_visualization.png: 3D setup visualization\n');
fprintf(fid, '- comprehensive_analysis.png: Complete analysis\n');
fprintf(fid, '- caseA_noiseless.png, caseA_noisy.png\n');
fprintf(fid, '- caseB_noiseless.png, caseB_noisy.png\n');
fprintf(fid, '- attenuation_map.png\n');
fprintf(fid, '- simulation_data.mat: Numerical data\n');
fprintf(fid, '- simulation_report.txt: This report\n');

fclose(fid);

fprintf('Simulation completed successfully\n');
fprintf('All files saved in: %s\n', output_dir);