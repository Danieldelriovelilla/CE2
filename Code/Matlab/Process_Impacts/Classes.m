clc
clear
close all


%% READ TABLE

try
    folder = 'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data';
    Y = readtable(strcat(folder, '\', 'Y_No_Scaled.csv'));
catch
    folder = 'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data';
    Y = readtable(strcat(folder, '\', 'Y_No_Scaled.csv'));
end


%% CONVERT THE TABLE INTO CATEGORICAL

x = categorical(Y{:,1});
xcat = categories(x);
y = categorical(Y{:,2});
ycat = categories(y);


%% OBTAIN INDEXES

comb = [];
idx = [];

for i = 1:length(xcat)
    for j = 1:length(ycat)
        % Index
        idxs = find(x == xcat{i} & y == ycat{j});
        idx = cat(1,idx, idxs);
        % Comination array
        comb = cat(1, comb,...
            [str2double(xcat{i}), str2double(ycat{j}),...
            length(idx)-length(idxs)+1, length(idx)]);
    end 
end


%% SAVE COMBINATION CATEGORIES & IDX

save(strcat(folder, '\','Combination_XY.dat'),...
    'comb','-ascii','-double','-tabs');
save(strcat(folder, '\','Combination_IDX.dat'),...
    'idx','-ascii','-double','-tabs');
