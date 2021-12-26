clc
clear
close all

%% LOAD DATA
try
    folder = 'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Matlab\Results\Data';
    targ = load(strcat(folder, '\', 'Target_mhe.dat'));
    pred = load(strcat(folder, '\', 'Predictions_mhe.dat'));
catch
    folder = 'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Matlab\Results\Data';
    targ = load(strcat(folder, '\', 'Target_mhe.dat'));
    pred = load(strcat(folder, '\', 'Predictions_mhe.dat'));
end

m = targ(:,1);
h = targ(:,2);
e = targ(:,3);
M = round(pred(:,1), -1);
H = round(pred(:,2));
E = pred(:,3);

%%
figure()
for i = 1:10
    scatter3(m(i), h(i), e(i), 50, 'x', 'LineWidth', 2)
    hold on
    scatter3(M(i), H(i), E(i), 50, 'o', 'LineWidth', 2)
    xlabel('Mass')
    ylabel('Height')
    zlabel('Energy')
    title('X = target || o = prediction')
    grid on, box on
end

% scatter3(M(i), E./(9.81*M)*1e6, E)

%%
% [X,Y] = meshgrid(-8:.5:8);
% R = sqrt(X.^2 + Y.^2) + eps;
% Z = sin(R)./R;
% C = gradient(Z);
% 
% figure
% mesh(X,Y,Z,C)