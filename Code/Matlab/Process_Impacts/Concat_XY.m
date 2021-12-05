%% DESCRIPTION
%{
%-   Process_Folder_Impacts.m   -%

This code opens all impact.mat files and short them to a certain length. 
After that, all of this files are saved on the respective processed folder.

%}

clc
clear
close all


%% DATA EXTRACTION

inidvidual_paths = {'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-060\XY_20211028\';
         'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-110\XY_20211102\';
         'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-160\XY_20211103\'};
concatenated_path = 'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data\';
     
% Array initialization     
X = [];
Y = struct2table(...
    struct('x', [], 'y', [], 'mass', [], 'height', [], 'energy', []) );

for p = 1:numel(inidvidual_paths)
    
    x = load( [inidvidual_paths{p} 'X.mat'] ); 
    X = cat( 1, X, x.X );
    
    T = readtable( [inidvidual_paths{p} 'Y.csv' ]);
    Y = cat(1, Y, T);
    
    disp(p)
end


%% SAVE data (X) and labels (Y)

save([concatenated_path 'X.mat'], 'X', '-v7.3');
writetable(Y, [concatenated_path 'Y.csv'], 'Delimiter', ';');

