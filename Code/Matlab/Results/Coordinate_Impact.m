clc
clear
close all


%% LOAD PREDICTIONS
try
    folder = 'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Matlab\Results\Data';
    targ = load(strcat(folder, '\', 'Target_xy.dat'));
    pred = load(strcat(folder, '\', 'Predictions_xy.dat'));
catch
    folder = 'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Matlab\Results\Data';
    targ = load(strcat(folder, '\', 'Target_XY.dat'));
    pred = load(strcat(folder, '\', 'Predictions_XY.dat'));
end


%% CONVERT THE TABLE INTO CATEGORICAL
[comb, idx] = Find_Combinations(targ);
mean_x = zeros(15, 17);
mean_y = zeros(15, 17);
mean_a = zeros(15, 17);
sig_x = zeros(15, 17);
sig_y = zeros(15, 17);
sig_a = zeros(15, 17);

c = 0;
for i = 1:15
    for j = 1:17
        c = c + 1;
        idx = comb(c).idx;
        % Error X
        ex = abs( targ(idx, 1) - pred(idx, 1) );
        mean_x(i, j) = mean(ex);
        sig_x(i, j) = sqrt(var(ex));
        % Error Y
        ey = abs( targ(idx, 2) - pred(idx, 2) );
        mean_y(i, j) = mean(ey);
        sig_y(i, j) = sqrt(var(ey));
        % Error Y
        ea_euc = [targ(idx, 1) - pred(idx, 1), targ(idx, 2) - pred(idx, 2)];
        ea = [];
            for k = 1:length(idx)
                ea =  cat(1, ea, sqrt(norm(ea_euc(k,:))));
            end
        mean_a(i, j) = mean(ea);
        sig_a(i, j) = sqrt(var(ea));
    end
end


%% PLOT AND SAVE HEATMAPS

% Labels
x = table2cell(array2table((linspace(0, 630, 15))));
y = table2cell(array2table((linspace(0, 710, 17))));
% Custom colormap setup
mycolormap = customcolormap([0, 0.25 0.5, 0.75, 1],... 
    [5,6,24; 118,36,94; 205,33,81; 233,109,73; 254,234,219]/255);

% X
h = Plot_Heatmap(x, y, mean_x, 'MEDIA (\mu) [mm]', mycolormap);
Save_Heatmap_As('pdf', h, 'Figures/Mean_x');    
% Save_Heatmap_As('svg', h, 'Figures/Mean_x');   
h = Plot_Heatmap(x, y, sig_x, 'DESVIACION TIPICA (\sigma) [mm]', mycolormap);
Save_Heatmap_As('pdf', h, 'Figures/Variance_x'); 
% Save_Heatmap_As('svg', h, 'Figures/Variance_x'); 
% Y
h = Plot_Heatmap(x, y, mean_y, 'MEDIA (\mu) [mm]', mycolormap);
Save_Heatmap_As('pdf', h, 'Figures/Mean_y');    
% Save_Heatmap_As('svg', h, 'Figures/Mean_y');   
h = Plot_Heatmap(x, y, sig_y, 'DESVIACION TIPICA (\sigma) [mm]', mycolormap);
Save_Heatmap_As('pdf', h, 'Figures/Variance_y'); 
% Save_Heatmap_As('svg', h, 'Figures/Variance_y'); 
% Absolute
h = Plot_Heatmap(x, y, mean_a, 'MEDIA (\mu) [mm]', mycolormap);
Save_Heatmap_As('pdf', h, 'Figures/Mean_a');    
% Save_Heatmap_As('svg', h, 'Figures/Mean_a');   
h = Plot_Heatmap(x, y, sig_a, 'DESVIACION TIPICA (\sigma) [mm]', mycolormap);
Save_Heatmap_As('pdf', h, 'Figures/Variance_a'); 
% Save_Heatmap_As('svg', h, 'Figures/Variance_a'); 
    

%% PLOT AND SAVE AN IMPACT
h = Plot_Impact_Location(1, targ, pred);
Save_Heatmap_As('pdf', h, 'Figures/Impact');
Save_Heatmap_As('svg', h, 'Figures/Impact');






%% FUNCTIONS

function [comb, idx] = Find_Combinations(X)
x = categorical(X(:,1));
xcat = categories(x);
y = categorical(X(:,2));
ycat = categories(y);

% OBTAIN INDEXES
comb = struct('X', [], 'Y', [], 'idx', []);
idx = [];

c = 0;
for i = 1:length(xcat)
    for j = 1:length(ycat)
        c = c + 1;
        % Index
        idx = find(x == xcat{i} & y == ycat{j});
        % Comination array
        comb(c).X = str2double(xcat{i});
        comb(c).Y = str2double(ycat{j});
        comb(c).idx = idx;
    end 
end
end

function [h] = Plot_Heatmap(x, y, z, tit, cm)
h = figure();
    hm = heatmap(x, y, z', 'FontName', 'Times New Roman');
%     hm.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
%     hm.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
%     hm.NodeChildren(3).Title.Interpreter = 'latex';
    hm.NodeChildren(3).XAxis.TickLabelRotation = -45;
    hm.NodeChildren(3).YAxis.TickLabelRotation = -0;
    hm.NodeChildren(3).YDir='normal';
    hHeatmap = struct(hm).Heatmap;
    hGrid = struct(hHeatmap).Grid;
    hGrid.ColorData = uint8([255;255;255;255]);
    colormap(cm)
    title(tit)
    xlabel('X')
    ylabel('Y')
    
end

function [h] = Plot_Impact_Location(idx, targ, pred)
xx = linspace(0, 630, 15);
yy = linspace(0, 710, 17);
[xx, yy] = meshgrid(xx, yy);
zz = 0*xx;
h = figure();
    mesh(xx', yy', zz', 'EdgeAlpha', '1', 'EdgeColor', [0,0,0], 'LineWidth', 0.05);
    title(strcat('Target:$\;$', num2str(targ(idx, 1)), '$\,$-$\,$', num2str(targ(idx, 2)),...
        '$\;$ Prediction:$\;$', num2str(pred(idx, 1)), '$\,$-$\,$', num2str(pred(idx, 2))),...
        'Interpreter', 'Latex')
    xlabel('X [mm]','Interpreter', 'Latex')
    ylabel('Y [mm]', 'Interpreter', 'Latex')
    grid off; box on;
    view([0, 90])
    axis('equal')
    xlim([-30 660])
    ylim([-30 740])
    
    hold on
    scatter(targ(idx, 1), targ(idx, 2), 100, 'fill')
    scatter(pred(idx, 1), pred(idx, 2), 100, 'x', 'LineWidth', 2)
end

