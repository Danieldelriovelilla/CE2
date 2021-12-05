%% DESCRIPTION
%{
%-   Process_Folder_Impacts.m   -%

This code opens all impact.mat files and short them to a certain length. 
After that, all of this files are saved on the respective processed folder.

%}

clc
clear
close all


%% VARIABLES DEFFINITION

% Folders
raw_path = 'D:\DMPA\Impactor\Impacts\Stiffened\Raw_Impact\m-160\20211103/';
xy_path = 'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-160\XY_20211103\';
report_path = 'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-160\Report_20211103\';


% Impact retain samples
idx_start = 451;
idx_end = idx_start + 20000 - 1;


%% DATA EXTRACTION

files = dir(raw_path);
files(1:2) = [];
Nf = numel(files);

% Initialize arrays
X = [];
Y = [];
coord = {};
idx_cat = 1;

% Error report
error_report = struct('File', [], 'Error', []);
idx_e = 1;

for f = 1:Nf
    
    % Load raw impact
    load( [files(f).folder '\' files(f).name] ); 
    
    
    % Check if the impact has been shorted
    if length( impact.data ) <= 10000
        error_report(idx_e).File = files(f).name;
        error_report(idx_e).Error = 'Not enough data';
        idx_e = idx_e + 1;
    elseif max( abs( impact.data(1,:) ) ) > 0.025
        error_report(idx_e).File = files(f).name;
        error_report(idx_e).Error = 'Higher initial voltage';
        idx_e = idx_e + 1;
    elseif length( impact.data ) == 10000
    
    else    % If there is not an error in the impact 
        if length( impact.data ) == 10000
            % Already shorted
        else
            % Short impact
            data = impact.data(idx_start:10:idx_end,:);
            impact.window = 2e4/2e6;
            % impact.SR = '1MHz';
        end
        
        % save( [single_path files(f).name], 'impact' )
        % Concatenate mass matrix
        X = cat( 1, X, reshape(data, 1, []) );
        Y = cat( 1, Y, [impact.x, impact.y, impact.mass, impact.height, impact.energy] );
        
        % Generate categorical cell arrays
        coord{idx_cat,1} = [num2str(impact.x), ' - ', num2str(impact.y)];
        idx_cat = idx_cat + 1;
        
        disp( ['Impact: ' num2str(f) ' of ' num2str(Nf)] )

    end
    

end
disp( 'END OF PROCESSING LOOP' )


%% WRITE ERROR REPORT

writetable(struct2table( error_report ), [report_path 'Error_Report.xlsx'])


%% WRITE REPORTS TABLES

mass = categorical( Y(:,3) );
mass_table = Categories_Report( mass, report_path, 'Mass' );

height = categorical( Y(:,4) );
height_table = Categories_Report( height, report_path, 'Height' );

energy = categorical( Y(:,5) );
energy_table = Categories_Report( energy, report_path, 'Energy' );

coord = categorical( coord );
coord_table = Categories_Report( coord, report_path, 'Coordinates' );


%% SAVE data (X) and labels (Y)

save([xy_path 'X.mat'], 'X', '-v7.3');
% save([to_folder 'Y.mat'], 'Y');
T = table( Y(:,1), Y(:,2), Y(:,3), Y(:,4), Y(:,5), ...
    'VariableNames',[{'x'},{'y'},{'mass'},{'height'},{'energy'}] );
writetable(T, [xy_path 'Y.csv'], 'Delimiter', ';');




%% FUNCTIONS

function T = Categories_Report( target, path, filename )

cats = categories( target );
cat_count = countcats( target );

cats(:,2) = num2cell( cat_count );

T = cell2table(cats,...
    'VariableNames',{'Category' 'Count'});

writetable(T, [path filename '.xlsx'])

end
