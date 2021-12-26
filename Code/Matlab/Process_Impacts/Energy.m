clc
clear
close all

try
    folder = 'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data';
    X_MinMax = readtable(strcat(folder, '\', 'X_MinMax.csv'));
    load( strcat(folder, '\', 'X_No_Scaled.mat') );
catch
    folder = 'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data';
    load( strcat(folder, '\', 'X_No_Scaled.mat') );
    X_MinMax = readtable(strcat(folder, '\', 'X_MinMax.csv'));
end


%% INTEGRATE THE NORMALIZED SIGNAL
E = zeros(size(X,1), 8);
xm = X_MinMax{1,1};
xx = X_MinMax{1,2};

for i = 1:size(X, 1)
    E(i,:) = trapz(...
        (reshape(X(i,:), 2000, 8) - xm )/(xx - xm)...
        );
end

save(strcat(folder, '\', 'E.mat'), 'E', '-v7.3');


%% NORMALIZE INTEGRATED ENERGY
em = min(min(E));
ex = max(max(E));
E_MinMax = [em; ex];
    
E = (E - em )/(ex - em);

save(strcat(folder, '\', 'E_Normalized.mat'),...
    'E', '-v7.3');
save(strcat(folder, '\','E_MinMax.dat'),...
    'E_MinMax','-ascii','-double','-tabs');


%% PLOT LESS ENERGETIC
%{
xm = X(1,:);
xem = ( reshape(xm,2000,8)+10.3 )/(2*10.3);
env = envelope(xem, 50, 'rms');

figure()
    plot(xem(:,:))
    title('LESS ENERGETIC')
figure()
    plot(env(:,:))
    title('LESS ENERGETIC')

em = trapz(abs(xem));
disp(['Integral señal LOW ENERGY:' num2str(em)])


%% PLOT MORE ENERGETIC
xx = X(36733,:);
xex = ( reshape(xx, 2000, 8)+10.3 )/(2*10.3);
env = envelope(xex, 50, 'rms');

figure()
    plot(xex(:,:))
    title('MEDIUM ENERGETIC')
figure()
    plot(env(:,:))
    title('MEDIUM ENERGETIC')

ex = trapz(abs(xex));
disp(['Integral señal MEDIUM ENERGY:' num2str(ex)])



%% PLOT MORE ENERGETIC
xx = X(44372,:);
xex = ( reshape(xx, 2000, 8)+10.3 )/(2*10.3);
env = envelope(xex, 50, 'rms');

figure()
    plot(xex(:,:))
    title('MORE ENERGETIC')
figure()
    plot(env(:,:))
    title('MORE ENERGETIC')

ex = trapz(abs(xex));
disp(['Integral señal HIGH ENERGY:' num2str(ex)])
%}
