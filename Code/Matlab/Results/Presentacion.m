clc
clear
close all

%%

bg_color = [1,1,1];% [244,241,236]/255;
pre_path = ['D:\DMPA\Impactor\Impacts\Stiffened\Raw_Impact\m-060\20211028_1001\' ...
    'X-0_Y-0_h-260_m-60_20211104_115401.mat'];

pre = load(pre_path);
pre = pre.impact;
pre_imp = pre.data;
t = linspace(0,length(pre_imp)/1e6,length(pre_imp));

% Color de fondo
h = figure('Color', bg_color, 'InvertHardcopy','off');
axes1 = axes('Parent',h);
        % 'Color',[244,241,236]/255);
hold(axes1,'all');
    plot(t, pre_imp)
    xlim([0, t(end)])
    grid on; box on
    xlabel('Time [s]','Interpreter','latex')
    ylabel({'V';'[V]'},'Interpreter','latex')
Save_2D_Figure(h, "Figures/Preprocessed_Impact.pdf", "horizontal", 1, 0)


%% 

pos_path = ['C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data\' ...
    'Single_Impact.mat'];

load(pos_path)
t = linspace(0,0.02,2000);

h = figure('Color', bg_color, 'InvertHardcopy','off');
axes1 = axes('Parent',h);
        % 'Color',[244,241,236]/255);
hold(axes1,'all');
    plot(t, Single_Impact)
    xlim([0, t(end)])
    grid on; box on
    xlabel('Time [s]','Interpreter','latex')
    ylabel({' ';' '},'Interpreter','latex')
Save_2D_Figure(h, "Figures/Postprocessed_Impact.pdf", "horizontal", 0, 0)

