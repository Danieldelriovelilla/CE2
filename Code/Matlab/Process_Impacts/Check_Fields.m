%% DESCRIPTION
%{
    %- Check_Fields.mat -%
    Read the files in a folder and check if the field is correct.
%}

clc
clear
close all

%% VARIABLES DEFFINITION

% Folders
from_path = 'G:\DMPA_Dani\20211103_0846/';


%% DATA EXTRACTION

files = dir(from_path);
files(1:2) = [];

for f = 1:numel(files)
    load( [files(f).folder '\' files(f).name] ); 
    
    if impact.mass ~= 160
        disp( ['Wrong mass: ' num2str(f)])
    end 
        
    disp(f)
end