%{
%-   Process_Impacts_Mat2Py.m   -%

This code saves processed impact and save them on a file (single mass).

%}


clc
clear
close all

%% VARIABLES DEFFINITION

% Folders

paths = {'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-060\Single_Mass/';
         'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-110\Single_Mass/'};


%% DATA EXTRACTION

X = [];
Y = [];

for p = 1:numel(paths)
    
    load( [paths{p} 'X.mat'] ); 
    
    X = cat( 1, X, reshape(impact.data, 1, []) );
    Y = cat( 1, Y, [impact.x, impact.y, impact.mass, impact.height, impact.energy] );
    
    disp(f)
end

T = table( Y(:,1), Y(:,2), Y(:,3), Y(:,4), Y(:,5), ...
    'VariableNames',[{'x'},{'y'},{'mass'},{'height'},{'energy'}] );


%% SAVE data (X) and labels (Y)

save([to_path 'X.mat'], 'X', '-v7.3');
% save([to_folder 'Y.mat'], 'Y');
writetable(T, [to_path 'Y.csv'], 'Delimiter', ';');
