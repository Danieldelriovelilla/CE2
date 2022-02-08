clc
clear
close all

% https://es.mathworks.com/help/stats/gscatter.html#d117e458073

%% LOAD DATA
kf = 1;
saveit = true;
fig_background = [1, 1, 1]; % [244,241,236]/255;

folder = '.\Data\mhe_Results';
targ = load(strcat(folder, '\', 'Target_mhe_0', num2str(kf), '.dat'));
pred = load(strcat(folder, '\', 'Predictions_mhe_0', num2str(kf), '.dat'));


%% PREPARE DATA

% Targets
m = targ(:,1);
h = round(targ(:,2));
e = targ(:,3)*1e3;
v = round( sqrt( 2*9.81*targ(:,2)/1000 ), 2 );
mhe = table(m, h, e);
mve = table(m, v, e);

% Predictions
M = pred(:,1);% round(pred(:,1), 0);
H = pred(:,2);% round(pred(:,2));
V = sqrt( 2*9.81*pred(:,2)/1000 );
E = pred(:,3)*1e3;
MHE = table(M, H, E);
MVE = table(M, V, E);

% Legend
hc = categorical(h);
hcat = categories(hc);
hs = [];
for i = 1:length(hcat)
    hs = cat(2, hs, str2double(hcat{i}));
end
vc = categorical(v);
vcat = categories(vc);
vs = [];
for i = 1:length(vcat)
    vs = cat(2, vs, str2double(vcat{i}));
end
ms = 60:50:260;
mkr = {'o', '+', '*', 'x', '<', '>', 's', 'd', '^', 'v'};
color = lines(length(ms)); % Generate color values


%% PLOTS
%%{
for i = 1:length(ms)
    % Scatter 3D
    %{
    f = figure('Color', fig_background, 'InvertHardcopy','off');
        f.Position = [680 558 675+50 420];
        axes1 = axes('Parent',f);
        hold on
        for j = 1:length(vs)
            scatter3(NaN, NaN, NaN, 'k', mkr{j}, 'LineWidth', 1.25)
        end
        leg = legend(num2str(vs'), 'location', 'eastoutside','Interpreter','latex');
        title(leg, '\textbf{Velocity [m/s]}','Interpreter','latex')
        set(leg,'AutoUpdate','off')
        for j = 1:length(hs)
            hold on
            scatter3(MVE([m==ms(i)&h==hs(j)], :), "M", "V", "E",...
                "Marker", mkr{j}, 'Linewidth', 1., 'ColorVariable', "E")
        end
            view(-65, 20)
            colormap(jet)
            colorbar
            title(['\textbf{k = ', num2str(kf), ', Masa = ', num2str(ms(i)), ' g}'],...
                'Interpreter','latex')
            xlabel('Mass [g]','Interpreter','latex')
            ylabel('Velocity [m/s]','Interpreter','latex')
            zlabel('Energy [mJ]','Interpreter','latex')
            grid on, box on
    % Save_Heatmap(f, "Figures/mve_single_3D.pdf", 'save', saveit)
    Save_3D_Figure(f, "Figures/mve_single_3D.pdf", 'on', 1, 0)
    %}
    % Scatter 2D
    f = figure('Color', fig_background, 'InvertHardcopy','off');
        f.Position = [680 558 675 420]; % [680 558 560 420];
        axes1 = axes('Parent',f);
        hold on
        for j = 1:length(vs)
            scatter(NaN, NaN, 'k', mkr{j}, 'LineWidth', 1.25)
        end
        leg = legend(num2str(vs'), 'location', 'eastoutside','Interpreter','latex');
        title(leg, '\textbf{Velocity [m/s]}','Interpreter','latex')
        set(leg,'AutoUpdate','off')
        for j = 1:length(hs)
            scatter(MVE([m==ms(i)&h==hs(j)], :), "M", "V", "Marker",...
                mkr{j},'LineWidth', 1., 'ColorVariable', "E")
        end
        colormap(jet)
        c = colorbar;
        c.TickLabelInterpreter = 'Latex'; 
        set(get(c,'Title'),'string','\textbf{Energy [mJ]}','Interpreter','latex');
        xlabel('Mass [g]','Interpreter','latex')
        ylabel('Velocity [m/s]','Interpreter','latex')
%         title(['\textbf{k = ', num2str(kf), ', Masa = ', num2str(ms(i)), ' g}'],...
%             'Interpreter','latex')
        grid on, box on
    Save_2D_Figure(f, strcat("Figures/mve_single_2D_k", num2str(kf), ".pdf"), 'vertical', 0, 0)
        % Save_Heatmap(f, "Figures/mve_single_2D.pdf", 'save', saveit)
end
%%}
%%
%%{
f = figure('Color', fig_background, 'InvertHardcopy','off');
f.Position = [680 558 675+100 420];
axes1 = axes('Parent',f);
hold on
% Velocity plot
for j = 1:length(vs)
    scatter(NaN, NaN, 'k', mkr{j}, 'LineWidth', 1.25)
end
% Mass plot
for i = 1:length(ms)
    scatter(NaN, NaN, "Marker", "_", 'MarkerFaceColor', color(i,:),...
        'MarkerEdgeColor', color(i,:),'LineWidth', 5.)
end
% Add velocity legend
tv = {};
for i = 1:length(vs)
    tv{i} = ['v = ', num2str(vs(i))];
end
tm = {};
for i = 1:length(ms)
    tm{i} = ['m = ', num2str(ms(i))];
end
leg = legend([tv, tm], 'interpreter', 'latex', 'location', 'eastoutside');
% Mass legend
title(leg, '\textbf{Targets}','Interpreter','latex')
set(leg,'AutoUpdate','off')

% Plot markers
for i = 1:length(ms)
    for j = 1:length(vs)
        scatter3(MVE([m==ms(i)&h==hs(j)], :), "M", "V", "E",...
                "Marker", mkr{j}, 'Linewidth', 1., 'CData', color(i,:))
    end
end
    view(-80, 12)
    xlabel('Mass [g]','Interpreter','latex')
    ylabel('Velocity [m/s]','Interpreter','latex')
    zlabel('Energy [mJ]','Interpreter','latex')
%     title(['\textbf{k = ', num2str(kf), ', TODAS LAS MASAS Y VELOCIDADES}'],...
%             'Interpreter','latex')
    grid on, box on

% Add energy surface
m = linspace(50, 280, 25);
v = linspace(0.79, 2.35, 25);
[M, V] = meshgrid(m,v);
e = M.*V.^2/2;
surf(m, v, e, 'EdgeColor', 'none', 'FaceAlpha',0.4)
colormap("jet")
c = colorbar;
c.TickLabelInterpreter = 'Latex'; 
set(get(c,'Title'),'string','\textbf{Energy [mJ]}','Interpreter','latex');

xlim([50, 280])
ylim([0.79, 2.35])
zlim([0, 800])
Save_3D_Figure(f, strcat("Figures/mve_all_3D_k", num2str(kf), ".pdf"), 'off', 0.5, 0)
    % Save_Heatmap(f, "Figures/mve_all_3D.pdf", 'save', saveit)


%% ENERGY SURFACE

% Background color
f = figure('Color', fig_background, 'InvertHardcopy','off');
f.Position = [680 558 675+100 420];
axes1 = axes('Parent',f);
hold on

% Velocity plot
for j = 1:length(vs)
    scatter(NaN, NaN, 'k', mkr{j}, 'LineWidth', 1.25)
end
% Mass plot
for i = 1:length(ms)
    scatter(NaN, NaN, "Marker", "_", 'MarkerFaceColor', color(i,:),...
        'MarkerEdgeColor', color(i,:),'LineWidth', 5.)
end
% Add velocity legend
tv = {};
for i = 1:length(vs)
    tv{i} = ['v = ', num2str(vs(i))];
end
tm = {};
for i = 1:length(ms)
    tm{i} = ['m = ', num2str(ms(i))];
end
leg = legend([tv, tm], 'interpreter', 'latex', 'location', 'eastoutside');
% Mass legend
title(leg, '\textbf{Targets}','Interpreter','latex')
set(leg,'AutoUpdate','off')

% Surface
surf(m, v, e, 'EdgeColor', 'none', 'FaceAlpha',0.4)
view(-80, 12)

xlim([50, 280])
ylim([0.79, 2.35])
zlim([0, 800])
c = colorbar;
c.TickLabelInterpreter = 'Latex'; 
colormap("jet")
set(get(c,'Title'),'string','\textbf{Energy [mJ]}','Interpreter','latex');
xlabel('Mass [g]','Interpreter','latex')
ylabel('Velocity [m/s]','Interpreter','latex')
zlabel('Energy [mJ]','Interpreter','latex')
% title(['\textbf{k = ', num2str(kf), ', TODAS LAS MASAS Y VELOCIDADES}'],...
%         'Interpreter','latex')
grid on, box on

Save_3D_Figure(f, "Figures/mve_all_3D_Surface.pdf", 'off', 0.5, 0)
    
    %}

%%

for kf = 1:4
    folder = '.\Data\mhe_Results';
    targ = load(strcat(folder, '\', 'Target_mhe_0', num2str(kf), '.dat'));
    pred = load(strcat(folder, '\', 'Predictions_mhe_0', num2str(kf), '.dat'));

    % Targets
    m = targ(:,1);
    h = targ(:,2);
    e = targ(:,3)*1e3;
    v = round( sqrt( 2*9.81*targ(:,2)/1000 ), 2 );
    mve_t = [m, v, e];
    
    % Predictions
    M = pred(:,1);% round(pred(:,1), 0);
    H = pred(:,2);% round(pred(:,2));
    V = sqrt( 2*9.81*pred(:,2)/1000 );
    E = pred(:,3)*1e3;
    mve_p = [M, V, E];

    error = mve_p - mve_t;
    mve_mean(kf,:) = mean( error, 1 );
    mve_sigm(kf,:) = sqrt( var( error, 1 ) );

   

end


%% HISTOGRAMS
% m
[D, PD] = allfitdist(error(:,1));
x = linspace( -20, 20, 1000);
y = pdf(PD{1}, x);
y = y*(1/max(y));

f = figure();
hold on
h = histogram(error(:,1), 35, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
xlim([-20, 20])
grid on; box on
legend({'Error histogram', [D(1).DistName, ' distribution']}, 'Location','northoutside',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Error_m_Hist.pdf", 'horizontal', 52.5, 0)

% v
[D, PD] = allfitdist(error(:,2));
x = linspace( -0.25, 0.25, 1000);
y = pdf(PD{4}, x);
y = y*(1/max(y));

f = figure();
hold on
h = histogram(error(:,2), 25, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
xlim([-0.25, .25])
grid on; box on
legend({'Error histogram', [D(1).DistName, ' distribution']}, 'Location','northoutside',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Error_v_Hist.pdf", 'horizontal', 52.5, 0)

% E
[D, PD] = allfitdist(error(:,3));
x = linspace( -60, 60, 1000);
y = pdf(PD{1}, x);
y = y*(1/max(y));

f = figure();
hold on
h = histogram(error(:,3), 35, 'FaceColor','k');
[maxcount, whichbin] = max(h.Values);
plot(x, y*maxcount, 'LineWidth',3)
xlim([-60, 60])
grid on; box on
legend({'Error histogram', [D(1).DistName, ' distribution']}, 'Location','northoutside',Interpreter='latex')
xlabel('Error [mm]', 'Interpreter','latex')
ylabel({'N'}, 'Interpreter','latex')
Save_2D_Figure(f, "Figures/Error_E_Hist.pdf", 'horizontal', 52.5, 0)


%% FUNCTIONS