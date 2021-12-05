%{
    1. Load data from directory, this data contains a data matrix and a table with the data labels
    2. create a function that performs a dimensionality reduction with various methods and returns the reduced matrix
    3. compare the accuracy of the domensionality reduction matrix with the original
%}

% Load data from directory

% load('data_files/data_files/data_files/data.mat')

from_folder = 'D:\DMPA\Impactor\Impacts\Stiffened\Processed\m-110\Single_Mass/';

load([from_folder 'X.mat'])
Y = readtable([from_folder 'Y.csv']);
data = X(:,1:50:end);
clear X
labels = Y.height;

% Create a function that performs a dimensionality reduction with various methods and returns the reduced matrix

% PCA
[coeff,score,latent] = pca(data);

% SVD
[U,S,V] = svd(data);

% NCA
% [W,Z,T,P,Q] = nca(data,labels);

% LDA
[L,J,M] = lda(data,labels);

% ICA
[S,A] = fastica(data);

% Plot the data
figure;
subplot(2,3,1);
plot(score(:,1),score(:,2),'.');
title('PCA');
subplot(2,3,2);
plot(U(:,1),U(:,2),'.');
title('SVD');
subplot(2,3,3);
plot(W(:,1),W(:,2),'.');
title('NCA');
subplot(2,3,4);
plot(L(:,1),L(:,2),'.');
title('LDA');
subplot(2,3,5);
plot(A(:,1),A(:,2),'.');
title('ICA');


% Compare the accuracy of the domensionality reduction matrix with the original

% PCA
[coeff,score,latent] = pca(data);
accuracy_pca = sum(score(:,1)==labels)/length(labels)

% SVD
[U,S,V] = svd(data);
accuracy_svd = sum(U(:,1)==labels)/length(labels)

% NCA
% [W,Z,T,P,Q] = nca(data,labels);
% accuracy_nca = sum(W(:,1)==labels)/length(labels)

% LDA
[L,J,M] = lda(data,labels);
accuracy_lda = sum(L(:,1)==labels)/length(labels)

% ICA
[S,A] = fastica(data);
accuracy_ica = sum(A(:,1)==labels)/length(labels)