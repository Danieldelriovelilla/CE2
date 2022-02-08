clc
clear
close all


%% LOAD DATA
data_path = './Data/Training_Loss.csv';
loss = readtable(data_path);

color1 = [0, 0.4470, 0.7410];
color2 = [0.8500, 0.3250, 0.0980];

%% PROCESS DATA

% Extract data
lr = loss{:,1};
loss_g = loss{:, 2};
loss_x = loss{:, 3};
loss_y = loss{:, 4};



e = 1:length(lr);
idx_5 = e(lr==1e-5);
idx_6 = e(lr==1e-6);

% Plot global loss
f1 = figure();
    hold on
    plot(e([idx_5, idx_6(1)]), loss_g([idx_5, idx_6(1)]), 'Color',color1, 'LineWidth',2)
    plot(e(idx_6), loss_g(idx_6), 'Color',color2,'LineWidth',2)
    axis([1, 65, 0, 127])
    xlabel('Epochs','Interpreter','latex')
    ylabel({'MSE Loss';'[mm$^2$]'},'Interpreter','latex')
    title('\textbf{Global model validation loss (RMSE) sum}','Interpreter','latex')
    leg = legend({'$10^{-5}$','$10^{-6}$'}, 'location', 'northeast','Interpreter','latex');
    title(leg, '\textbf{Learning Rate}','Interpreter','latex')
    grid on; box on
Save_2D_Figure(f1, "Figures/Loss_Global.pdf", "horizontal", 4, 8)

% Plot global loss
f2 = figure();
    hold on
    plot(e([idx_5, idx_6(1)]), loss_x([idx_5, idx_6(1)]), 'Color',color1, 'LineWidth',2)
    plot(e(idx_6), loss_x(idx_6), 'Color',color2,'LineWidth',2)
    axis([1, 65, 0, 1405])
    xlabel('Epochs','Interpreter','latex')
    ylabel({'$\Sigma$(AE)';'[mm]'},'Interpreter','latex')
    title('\textbf{Target X validation absolute error sum}','Interpreter','latex')
    leg = legend({'$10^{-5}$','$10^{-6}$'}, 'location', 'northeast','Interpreter','latex');
    title(leg, '\textbf{Learning Rate}','Interpreter','latex')
    grid on; box on
Save_2D_Figure(f2, "Figures/Loss_X.pdf", "horizontal", 3, 5)


% Plot global loss
f3 = figure();
    hold on
    plot(e([idx_5, idx_6(1)]), loss_y([idx_5, idx_6(1)]), 'Color',color1, 'LineWidth',2)
    plot(e(idx_6), loss_y(idx_6), 'Color',color2,'LineWidth',2)
    axis([1, 65, 0, 2630])
    xlabel('Epochs','Interpreter','latex')
    ylabel({'$\Sigma$(AE)';'[mm]'},'Interpreter','latex')
    title('\textbf{Target Y validation absolute error sum}','Interpreter','latex')
    leg = legend({'$10^{-5}$','$10^{-6}$'}, 'location', 'northeast','Interpreter','latex');
    title(leg, '\textbf{Learning Rate}','Interpreter','latex')
    grid on; box on
Save_2D_Figure(f3, "Figures/Loss_Y.pdf", "horizontal", 3, 5)

