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
mycolormap = customcolormap([0 0.5 1], [1 1 1; 1 0 0; 0 0 0]);

figure()
    
    hm = heatmap(mean_a', 'Colormap', mycolormap);
    hm.NodeChildren(3).YDir='normal';
    hGrid.ColorData = uint8([238;238;238;125]);
    plot([0,0], [0, 17], 'w')
    plot([1,1], [0, 17], 'w')
figure()
hm = heatmap(var_a', 'Colormap', winter);
hm.NodeChildren(3).YDir='normal';


%%
figure()
    hold on
    imagesc(mean_a')
    colormap(mycolormap);
    colorbar
    plot([-0.5,-.5], [-0.5, 17.5], 'w')
    plot([.5,.5], [.5, 17.5], 'w')
    plot([1.5,1.5], [-0.5, 17.5], 'w')
    plot([2.5,2.5], [-0.5, 17.5], 'w')
%% 
Plot_Impact_Location(70, targ, pred)







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


function [] = Plot_Impact_Location(idx, targ, pred)
xx = linspace(0, 630, 15);
yy = linspace(0, 710, 17);
[xx, yy] = meshgrid(xx, yy);
zz = 0*xx;
figure()
    mesh(xx', yy', zz', 'EdgeAlpha', '0.5', 'EdgeColor', [0,0,0]);
    xlabel('X [mm]')
    ylabel('Y [mm]')
    grid off; box on
    view([0, 90])
    axis('equal')
    xlim([0 630])
    ylim([0 710])
    
    hold on
    scatter(targ(idx, 1), targ(idx, 2), 100, 'fill')
    scatter(pred(idx, 1), pred(idx, 2), 100, 'x', 'LineWidth', 2)
end