clc
clear
close all


%% SETUP
save_fig = false;
fig_background = [1 1 1];% [244,241,236]/255;


%% LOAD PREDICTIONS
kf = 1;
folder = '.\Data\XY_Results';
targ = round( ...
    load( strcat( folder, '\', 'Target_XY_0', num2str(kf), '.dat' ) ), ...
    3);
pred = load( strcat( folder, '\', 'Predictions_XY_0', num2str(kf), '.dat' ) );


%% ERRORES
[targ, pred, error] = f_Remove_Outliers(targ, pred);

%% ERROR STATISTICS
% X
[D, PD] = allfitdist(error(:,1));
x = linspace( -15, 15, 1000);
y = pdf(PD{1}, x);
y = y*(1/max(y));

f = figure();
hold on
h = histogram(error(:,1), 25, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
grid on; box on
legend({'Error histogram', [D(1).DistName, ' distribution']}, 'Location','northoutside',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Error_X_Hist.pdf", 'horizontal', 52.5, 0)

% Y
[D, PD] = allfitdist(error(:,2));
x = linspace( -15, 15, 1000);
y = pdf(PD{1}, x);
y = y*(1/max(y));

f = figure();
hold on
h = histogram(error(:,2), 25, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
grid on; box on
legend({'Error histogram', [D(1).DistName, ' distribution']}, 'Location','northoutside',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Error_Y_Hist.pdf", 'horizontal', 55, 0)

% Distance
[D, PD] = allfitdist(error(:,3));
x = linspace( 0, 15, 500);
y = pdf(PD{1}, x);
y = y*(1/max(y));

f = figure();
hold on
h = histogram(error(:,3), 25, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
grid on; box on
legend({'Error histogram', [D(1).DistName, ' distribution']}, 'Location','northoutside',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Error_Dist_Hist.pdf", 'horizontal', 7.5, 0)



%% ERROR MEAN AND DEVIATION
[mean_x, sig_x, mean_y, sig_y, mean_a, sig_a] = Mean_Var(targ, pred);


%% PLOT AND SAVE HEATMAPS

% Labels
x = table2cell(array2table((linspace(0, 630, 15))));
y = table2cell(array2table((linspace(0, 710, 17))));

% Custom colormap setup
% mycolormap = customcolormap([0, 0.25 0.5, 0.75, 1],[5,6,24; 118,36,94; 205,33,81; 233,109,73; 254,234,219]/255);
mycolormap = "jet";

%{
% X
% Mean
h = Plot_Heatmap(x, y, mean_x, ['Target X  ||  k = ', num2str(kf)], mycolormap, fig_background);
annotation('textarrow',[0.89,0],[0.94,0],'interpreter','latex','string','{\boldmath$\mu \mathrm{[mm]}$}', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',0);
Save_Heatmap(h, strcat("Figures/Mean_X_k_", num2str(kf), ".pdf"), "save", save_fig); 
% Sigma
h = Plot_Heatmap(x, y, sig_x, ['Target X  ||  k = ', num2str(kf)], mycolormap, fig_background);
annotation('textarrow',[0.89,0],[0.94,0],'interpreter','latex','string','{\boldmath$\sigma \mathrm{[mm]}$}', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',0);
Save_Heatmap(h, strcat("Figures/Sigma_X_k_", num2str(kf), ".pdf"), "save", save_fig); 

% Y
% Mean
h = Plot_Heatmap(x, y, mean_y, ['Target Y  || k = ', num2str(kf)], mycolormap, fig_background);
annotation('textarrow',[0.89,0],[0.94,0],'interpreter','latex','string','{\boldmath$\mu \mathrm{[mm]}$}', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',0);
Save_Heatmap(h, strcat("Figures/Mean_Y_k_", num2str(kf), ".pdf"), "save", save_fig); 
% Sgima
h = Plot_Heatmap(x, y, sig_y, ['Target Y  ||  k = ', num2str(kf)], mycolormap, fig_background);
annotation('textarrow',[0.89,0],[0.94,0],'interpreter','latex','string','{\boldmath$\sigma \mathrm{[mm]}$}', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',0);
Save_Heatmap(h, strcat("Figures/Sigma_Y_k_", num2str(kf), ".pdf"), "save", save_fig); 

% Distance
% Mean
h = Plot_Heatmap(x, y, mean_a, ['Target XY  ||  k = ', num2str(kf)], mycolormap, fig_background);
annotation('textarrow',[0.89,0],[0.94,0],'interpreter','latex','string','{\boldmath$\mu \mathrm{[mm]}$}', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',0);
Save_Heatmap(h, strcat('Figures/Mean_XY_k_', num2str(kf), ".pdf"), "save", save_fig);    
% Sigma
h = Plot_Heatmap(x, y, sig_a, ['Target XY  ||  k = ', num2str(kf)], mycolormap, fig_background);
annotation('textarrow',[0.89,0],[0.94,0],'interpreter','latex','string','{\boldmath$\sigma \mathrm{[mm]}$}', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',0);
Save_Heatmap(h, strcat("Figures/Sigma_XY_k_", num2str(kf), ".pdf"), "save", save_fig); 
%}    


%% SINGLE COORDINATE IMPACTS

% FInd idxs of an impact
[comb] = Find_Combinations(targ);
idx_p = comb(128).idx;

% Plot some of that indexes
f = Plot_Impact_Location(idx_p(1:1:end), targ, pred, fig_background);
Save_2D_Figure(f, "Figures/Impact.pdf", 'horizontal', 11, -10)


% Error
pred_p = pred(idx_p, :);
error_p = pred_p - [targ(idx_p(1), 1), targ(idx_p(1), 2)];
error_pn = vecnorm(error_p')';

% Distribucion
%%{
[D, PD] = allfitdist(error_pn);
x = linspace( 0, 10, 500);
y = pdf(PD{1}, x);
y = y*(1/max(y));

f = figure('Color', fig_background, 'InvertHardcopy','off');
axes1 = axes('Parent',f);
hold on
h = histogram(error_pn, 6, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
grid on; box on
legend({'Error histogram', 'Lognormal distribution'}, 'Location','northeast',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Impact_Hist.pdf", 'horizontal', 3, 0)
%}


%% ALL ks
for kf = 1:4
    folder = '.\Data\XY_Results';
    targ = load(strcat(folder, '\', 'Target_XY_0', num2str(kf), '.dat'));
    pred = load(strcat(folder, '\', 'Predictions_XY_0', num2str(kf), '.dat'));

    [targ, pred, error] = f_Remove_Outliers(targ, pred);
    
    [mean_x, sig_x, mean_y, sig_y, mean_a, sig_a] = Mean_Var(targ, pred);

    mean_X(kf,1) = round( mean(error(:,1)), 2 );
    sigma_X(kf,1) = round( sqrt( var( error(:,1) ) ), 2 );
    mean_Y(kf,1) = round( mean(error(:,2) ), 2 );
    sigma_Y(kf,1) = round( sqrt( var( error(:,2) ) ), 2 );
    mean_XY(kf,1) = round( mean( error(:,3) ), 2 );
    sigma_XY(kf,1) = round( sqrt( var( error(:,3) ) ), 2 );
end


%%
%{
% Find idxs of an impact
[comb] = Find_Combinations(targ);

idx_p = comb(238).idx;
f = Plot_Impact_Location(idx_p(:), targ, pred, fig_background);
% Plot some of that indexes
% for i = 1:length(idx_p)
%     f = Plot_Impact_Location(idx_p(i), targ, pred, fig_background);
% end
e = pred(idx_p,:) - targ(idx_p,:);
ae = sqrt( sum( e.^2, 2 ) );
mae = mean(ae)
%}








%% FUNCTIONS

function [targ, pred, error] = f_Remove_Outliers(targ, pred)
% Calcular error y distancia
error = [pred-targ, sqrt( sum( (pred-targ).^2, 2 ) )];

% Detectar outliers
outliers = find(abs(error(:,1))>15 | abs(error(:,2))>15);

% Eliminar otuliers
targ(outliers,:) = [];
pred(outliers,:) = [];
error(outliers,:) = [];


end

function [comb] = Find_Combinations(targ)
% Categories
X_str = cellstr(num2str(targ(:,1)));
X_cat = categorical(X_str);
X_cats = categories(X_cat);
Y_str = cellstr(num2str(targ(:,2)));
Y_cat = categorical(Y_str);
Y_cats = categories(Y_cat);

% Sort categories numbering
X_num = zeros(size(X_cats));
for i = 1:length(X_num)
    X_num(i) = str2double(X_cats{i});
end
[X_sort,idx_X] = sort(X_num);
Y_num = zeros(size(Y_cats));
for i = 1:length(Y_num)
    Y_num(i) = str2double(Y_cats{i});
end
[Y_sort,idx_Y] = sort(Y_num);

% Sort the impacts in a struct
comb = struct('X', [], 'Y', [], 'idx', []);
c = 0;
for i = 1:length(X_sort)
    for j = 1:length(Y_sort)
        c = c + 1;
        % Index
        idx = find(targ(:,1) == X_sort(i) & targ(:,2) == Y_sort(j));
        % Comination array
        comb(c).X = X_sort(i);
        comb(c).Y = Y_sort(j);
        comb(c).idx = idx;
    end 
end
end


function [mean_x, sig_x, mean_y, sig_y, mean_a, sig_a] = Mean_Var(targ, pred)

[comb] = Find_Combinations(targ);
mean_x = zeros(15, 17);
mean_y = zeros(15, 17);
mean_a = zeros(15, 17);
sig_x = zeros(15, 17);
sig_y = zeros(15, 17);
sig_a = zeros(15, 17);

for i = 1:15
    for j = 1:17
        c = (i-1)*17 + j;
        idx = comb(c).idx;

        % Error X -> sin abs
        ex = targ(idx, 1) - pred(idx, 1);% abs( targ(idx, 1) - pred(idx, 1) );
        mean_x(i, j) = mean(ex);
        sig_x(i, j) = sqrt(var(ex));
        
        % Error Y -> sin abs
        ey = targ(idx, 2) - pred(idx, 2); % abs( targ(idx, 2) - pred(idx, 2) );
        mean_y(i, j) = mean(ey);
        sig_y(i, j) = sqrt(var(ey));
        
        % Error Euclidean distance
        euc_error = sqrt( sum( (pred(idx,:) - targ(idx,:)).^2, 2 ) );
        mean_a(i, j) = mean(euc_error);
        sig_a(i, j) = sqrt(var(euc_error));
    end
end


end


function [h] = Plot_Heatmap(x, y, z, tit, cm, fig_background)
h = figure('Color', fig_background, 'InvertHardcopy','off');
axes1 = axes('Parent',h);
    hm = heatmap(x, y, z', 'FontName', 'Times New Roman','CellLabelColor','none');
%    hm.NodeChildren(3).XAxis.Label.Interpreter = 'latex';
%    hm.NodeChildren(3).YAxis.Label.Interpreter = 'latex';
%    hm.NodeChildren(3).Title.Interpreter = 'latex';
    hm.NodeChildren(3).XAxis.TickLabelRotation = -45;
    hm.NodeChildren(3).YAxis.TickLabelRotation = -0;
    hm.NodeChildren(3).YDir='normal';
    hHeatmap = struct(hm).Heatmap;
    hGrid = struct(hHeatmap).Grid;
    hGrid.ColorData = uint8([255;255;255;255]);% uint8([255;255;255;255]);
    colormap(cm)
    
    % FIGURE
    xlabel('X [mm]')
    ylabel('Y [mm]')
    title(tit)
    
end


function [h] = Plot_Impact_Location(idx, targ, pred, fig_background)
xx = linspace(0, 630, 15);
yy = linspace(0, 710, 17);
[xx, yy] = meshgrid(xx, yy);
zz = 0*xx;
h = figure('Color', fig_background, 'InvertHardcopy','off');
axes1 = axes('Parent',h);
    mesh(xx', yy', zz', 'EdgeAlpha', '1', 'EdgeColor', [0,0,0], 'LineWidth', 0.05);
%     title(strcat('Target:$\;$', num2str(targ(idx, 1)), '$\,$-$\,$', num2str(targ(idx, 2)),...
%         '$\;$ Prediction:$\;$', num2str(pred(idx, 1)), '$\,$-$\,$', num2str(pred(idx, 2))),...
%         'Interpreter', 'Latex')
    title(strcat( '\textbf{Target $\;$(', num2str(targ(idx(1), 1)), '$\,$,$\,$',...
        num2str(targ(idx(1), 2)),') [mm]}' ), 'Interpreter', 'Latex')
    xlabel('X [mm]','Interpreter', 'Latex')
    ylabel({'Y'; '[mm]'}, 'Interpreter', 'Latex')
    grid off; box on;
    view([0, 90])
    axis('equal')
    xlim([-30 660])
    ylim([-30 740])
    
    hold on
    scatter(targ(idx, 1), targ(idx, 2), 150,[67,67,67]/255,'fill') % [193, 178, 152]/255
    for i = 1:length(idx)
        scatter(pred(idx(i), 1), pred(idx(i), 2), 100, [0.8500, 0.3250, 0.0980],  'x', 'LineWidth', 1)    % [67,67,67]/255
    end
end