clc
clear
close all

% https://es.mathworks.com/help/stats/gscatter.html#d117e458073

%% LOAD DATA
kf = 2;
folder = '.\Data\mhe_Results';
targ = load(strcat(folder, '\', 'Target_mhe_0', num2str(kf), '.dat'));
pred = load(strcat(folder, '\', 'Predictions_mhe_0', num2str(kf), '.dat'));


m = targ(:,1);
h = round(targ(:,2));
e = targ(:,3);
v = sqrt( 2*9.81*targ(:,2)/1000 );
mhe = table(m, h, e);
mve = table(m, v, e);
M = pred(:,1);% round(pred(:,1), 0);
H = pred(:,2);% round(pred(:,2));
V = sqrt( 2*9.81*pred(:,2)/1000 );
E = pred(:,3);
MHE = table(M, H, E);
MVE = table(M, V, E);

hc = categorical(h);
hcat = categories(hc);
ms = 60:50:260;

mkr = {'o', '+', '*', 'x', '<', '>', 's', 'd', '^', 'v'};

hs = [];
for i = 1:length(hcat)
    hs = cat(2, hs, str2double(hcat{i}));
end

%%

for i = 1:length(ms)
    % Scatter 3D
    f = figure();
        f.Position = [680 558 675 420];
        hold on
        for j = 1:length(hs)
            scatter3(NaN, NaN, NaN, 'k', mkr{j}, 'LineWidth', 1.25)
        end
        leg = legend(num2str(hs'), 'location', 'eastoutside');
        title(leg, 'Height [mm]')
        set(leg,'AutoUpdate','off')
        for j = 1:length(hs)
            hold on
            % scatter3(MHE([m==ms(i)&h==hs(j)], :), "M", "H", "E",...
            %     "Marker", mkr{j}, 'Linewidth', 1., 'ColorVariable', "E")
            scatter3(MVE([m==ms(i)&h==hs(j)], :), "M", "V", "E",...
                "Marker", mkr{j}, 'Linewidth', 1., 'ColorVariable', "E")
        end
            view(-20, 10)
            colormap(jet)
            colorbar
            title(['k = ', num2str(kf), ', Masa = ', num2str(ms(i)), ' g'])
            xlabel('Mass [g]')
            % ylabel('Height [mm]')
            ylabel('Velocity [m/s]')
            zlabel('Energy')
            grid on, box on
            

    % Scatter 2D
    f = figure();
        f.Position = [680 558 675 420]; % [680 558 560 420];
        % scatter3(m, h, e, 200, 'x', 'LineWidth', 2)
        hold on
        for j = 1:length(hs)
            scatter(NaN, NaN, 'k', mkr{j}, 'LineWidth', 1.25)
        end
        leg = legend(num2str(hs'), 'location', 'eastoutside');
        title(leg, 'Height [mm]')
        set(leg,'AutoUpdate','off')
        for j = 1:length(hs)
            % scatter(MHE([m==ms(i)&h==hs(j)], :), "M", "H", "Marker",...
            %     mkr{j},'LineWidth', 1., 'ColorVariable', "E")
            scatter(MVE([m==ms(i)&h==hs(j)], :), "M", "V", "Marker",...
                mkr{j},'LineWidth', 1., 'ColorVariable', "E")
        end
        colormap(jet)
        colorbar
        xlabel('Mass [g]')
        % ylabel('Height [mm]')
        ylabel('Velocity [m/s]')
        title(['k = ', num2str(kf), ', Masa = ', num2str(ms(i)), ' g'])
        grid on, box on

end

figure()
    % scatter3(MHE, "M", "H", "E", 'ColorVariable', "E")
    scatter3(MVE, "M", "V", "E", 'ColorVariable', "E")
    colormap(jet)
        colorbar


%% FUNCTIONS