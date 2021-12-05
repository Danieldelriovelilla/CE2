clc
clear
close all


%% LOAD PROCESSED DATA

from_folder = 'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-110\Single_Mass/';

load([from_folder 'X.mat'])
Y = readtable([from_folder 'Y.csv']);
X = X(:,1:50:end);

%% GET LABELS

ym = Y.mass;
yh = Y.height;
ye = Y.energy;
yp = {};
for i = 1:size(Y,1)
    yp{i,1} = ['X-' num2str( Y.x(i) ) ' Y-' num2str( Y.y(i) )];
end


%% t-SNE 2D
% Y = tsne(x, 'Exaggeration', 10, 'Perplexity', 1000, 'Standardize', true);
Y = tsne( X );


%%
[h2p] = f_Plot2D(Y, yp, 'Position');
%Save_as_PDF(h2p, ['Figures/Position_2D'],'vert');
[h2m] = f_Plot2D(Y, ym, 'Mass [g]');
%Save_as_PDF(h2m, ['Figures/Mass_2D'],'vert');
[h2h] = f_Plot2D(Y, yh, 'Height [mm]');
%Save_as_PDF(h2h, ['Figures/Height_2D'],'vert');
[h2e] = f_Plot2D(Y, ye, 'Energy [J]');
%Save_as_PDF(h2e, ['Figures/Energy_2D'],'vert');


%% t-SNE 3D

Y = tsne(X(:,1:50:end), 'Algorithm', 'exact', 'NumDimensions',3);

%%
[h3p] = f_Plot3D(Y, yp, 'Position');
% Save_as_PDF(h3p, ['Figures/Position_3D'],'vert');
[h3h] = f_Plot3D(Y, yh, 'Height');
% Save_as_PDF(h3h, ['Figures/Mass_3D'],'vert');
[h3m] = f_Plot3D(Y, ym, 'Mass');
% Save_as_PDF(h3m, ['Figures/Height_3D'],'vert');
% [h3v] = f_Plot3D(Y, yv, 'Velocity');
% Save_as_PDF(h3v, ['Figures/Velocity_3D'],'vert');
[h3e] = f_Plot3D(Y, ye, 'Energy');
% Save_as_PDF(h3e, ['Figures/Energy_3D'],'vert');
    
    
%% FUNCTIONS

function [concat_data] = impact_detection(data)

    concat_data = [];
    for i = 1:size(data,2)
        concat_data = cat(1, concat_data, data(:,i));
    end
    
    concat_data = concat_data';

end