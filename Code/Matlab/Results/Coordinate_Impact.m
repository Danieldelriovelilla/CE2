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
var_x = zeros(15, 17);
var_y = zeros(15, 17);
var_a = zeros(15, 17);

c = 0;
for i = 1:15
    for j = 1:17
        c = c + 1;
        idx = comb(c).idx;
        % Error X
        ex = targ(idx, 1) - pred(idx, 1);
        mean_x(i, j) = mean(ex);
        var_x(i, j) = var(ex);
        % Error Y
        ey = targ(idx, 2) - pred(idx, 2);
        mean_y(i, j) = mean(ey);
        var_y(i, j) = var(ey);
        % Error Y
        ea_euc = [targ(idx, 1) - pred(idx, 1), targ(idx, 2) - pred(idx, 2)];
        ea = [];
            for k = 1:length(idx)
                ea =  cat(1, ea, sqrt(norm(ea_euc(k,:))));
            end
        mean_a(i, j) = mean(ea);
        var_a(i, j) = var(ea);
    end
end

%%
figure(1)
h = heatmap(rand(3,3));
h.XLabel = '$u_1$';
h.YLabel = '$u_2$';
h.Title = '$x^y$';
h.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
h.NodeChildren(3).Title.Interpreter = 'latex';

%%
close all
mycolormap = customcolormap([0 0.5 1], [242,223,208; 224,46,82 ; 38,23,54]/255);

h = figure();
    hm = heatmap(mean_a', 'FontName', 'Times New Roman');
%     hm.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
%     hm.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
%     hm.NodeChildren(3).Title.Interpreter = 'latex';
    hm.NodeChildren(3).YDir='normal';
    hGrid.ColorData = uint8([238;238;238;125]);
    colormap(mycolormap)
    title('MEAN')
    xlabel('X')
    ylabel('Y')
Save_Heatmap_As('png', h, 'Figures/mean_a');    

figure()
    hm = heatmap(var_a', 'FontName', 'Times New Roman', 'Colormap', mycolormap);
    hm.NodeChildren(3).YDir='normal';
    title('Variance')



%% 
h = Plot_Impact_Location(70, targ, pred);
Save_Heatmap_As('pdf', h, 'Figures/Impact');






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

% SAVE COMBINATION CATEGORIES & IDX
%{
save(strcat(folder, '\','Combination_XY.dat'),...
    'comb','-ascii','-double','-tabs');
save(strcat(folder, '\','Combination_IDX.dat'),...
    'idx','-ascii','-double','-tabs');
%}
end


function [h] = Plot_Impact_Location(idx, targ, pred)
xx = linspace(0, 630, 15);
yy = linspace(0, 710, 17);
[xx, yy] = meshgrid(xx, yy);
zz = 0*xx;
h = figure();
    mesh(xx', yy', zz', 'EdgeAlpha', '1', 'EdgeColor', [0,0,0], 'LineWidth', 0.05);
    xlabel('X [mm]')
    ylabel('Y [mm]')
    grid off; box on;
    view([0, 90])
    axis('equal')
    xlim([-30 660])
    ylim([-30 740])
    
    hold on
    scatter(targ(idx, 1), targ(idx, 2), 100, 'fill')
    scatter(pred(idx, 1), pred(idx, 2), 100, 'x', 'LineWidth', 2)
end