%% DESCRIPTION
%{
%-   Concat_XYs.m   -%

This code opens all impact.mat files and short them to a certain length. 
After that, all of this files are saved on the respective processed folder.

%}

clc
clear
close all


%% DATA EXTRACTION

concatenated_path = 'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data\';
folder = dir(concatenated_path);

if any(strcmp({folder(:).name}, 'X.mat'))
    % Load XY
  disp('X matrix already exists.');
  load([concatenated_path 'X.mat'])
  Y = readtable( [concatenated_path 'Y.csv']);
else
    % XY initialization
    X = [];
    Y = struct2table(...
        struct('x', [], 'y', [], 'mass', [], 'height', [], 'energy', []) );
end

inidvidual_paths = {'E:\DMPA_Dani\m-060\19800102_0257\Processed\XY\';
         'E:\DMPA_Dani\m-060\20211104_1151\Processed\XY\';
         'E:\DMPA_Dani\m-110\19800104_2005\XY\';
         'E:\DMPA_Dani\m-160\19800106_2144\XY\';
         'E:\DMPA_Dani\m-210\19800101_0011\XY\';
         'E:\DMPA_Dani\m-260\19800101_0011\XY\';
         'E:\DMPA_Dani\m-260\19800103_2144\XY\'};

     
%%

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

