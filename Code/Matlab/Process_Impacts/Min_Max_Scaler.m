clc
clear 
close all


%% LOAD XY

folder = 'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data';
load( strcat(folder, '\', 'X_No_Scaled.mat') );
Y = readtable( strcat(folder, '\', 'Y_No_Scaled.csv'));

%% SCALE X

% Find the minimum and maximum value
mx = min( min(X) );
Mx = max( max(X) );
X_MinMax(1, 1)= mx;
X_MinMax(1, 2) = Mx;

% Scale X
X_Scaled = (X - mx)/(Mx - mx);

% Save scaled X
save(strcat(folder, '\', 'X_Scaled.mat'), 'X_Scaled', '-v7.3');

% Save minmax values
X_MinMax = array2table(X_MinMax);
writetable(X_MinMax, strcat(folder, '\', 'X_MinMax.csv'), 'Delimiter', ';');


%% SCALE Y

% Initialize arrays
Y_Scaled = [];
Y_MinMax = [];

% Sacle targets
for c = 1:size(Y, 2)
    my = min( min(Y{:,c}) );
    My = max( max(Y{:,c}) );
    Y_Scaled(:,c) = (Y{:,c} - my)/(My - my);
    
    Y_MinMax(1, c) = my;
    Y_MinMax(2, c) = My;
end

% Save sacled targets
Y_Scaled = array2table(Y_Scaled);
writetable(Y_Scaled, strcat(folder, '\', 'Y_Scaled.csv'), 'Delimiter', ';');

% Save minmax values
Y_MinMax = array2table(Y_MinMax);
writetable(Y_MinMax, strcat(folder, '\', 'Y_MinMax.csv'), 'Delimiter', ';');