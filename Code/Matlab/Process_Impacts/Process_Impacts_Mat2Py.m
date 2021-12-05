%{
%-   Process_Impacts_Mat2Py.m   -%

This code saves processed impacts to be oppened with python code

%}


clc
clear
close all

%% VARIABLES DEFFINITION

% Folders
from_path = 'D:\DMPA\Impactor\Impacts\Stiffened\Raw_Impact\m-060\20211028_1001/';
to_path = 'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Data\401_7000/';

% Impact retain samples
idx_start = 401;
idx_end = 7000;


%% DATA EXTRACTION

files = dir(from_path);
files([1:2]) = [];

X = [];
Y = [];

for f = 1:numel(files)
    load( [files(f).folder '\' files(f).name] ); 
    
    X = cat( 1, X, reshape(impact.data(idx_start:idx_end,:), 1, []) );
    Y = cat( 1, Y, [impact.x, impact.y, impact.mass, impact.height, impact.energy] );
    
    disp(f)
end

T = table( Y(:,1), Y(:,2), Y(:,3), Y(:,4), Y(:,5), ...
    'VariableNames',[{'x'},{'y'},{'mass'},{'height'},{'energy'}] );


%% SAVE data (X) and labels (Y)

save([to_folder 'X.mat'], 'X', '-v7.3');
% save([to_folder 'Y.mat'], 'Y');
writetable(T, [to_folder 'Y.csv'], 'Delimiter', ';');
