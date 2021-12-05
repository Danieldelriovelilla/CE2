"""
    1. Load data from directory, this data contains a data matrix and a table with the data labels
    2. create a function that performs a dimensionality reduction with various methods and returns the reduced matrix
    3. compare the accuracy of the domensionality reduction matrix with the original
"""
from utils import *
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.decomposition import KernelPCA

# load data
"""
    data = load_iris()
    X = data["data"]
    y = data["target"]
"""
data_dir = r'C:\Users\danie\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Data\Processed\m-110'
X, Y = f_Get_Impact_Database_XY( data_dir )
y = np.array(Y.height)

# split data into training and testing
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

# scale the data
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# create a function that performs a dimensionality reduction with various methods and returns the reduced matrix
def dimensionality_reduction(X_train, X_test, y_train, y_test, method):
    if method == "PCA":
        pca = PCA(n_components=2)
        X_train = pca.fit_transform(X_train)
        X_test = pca.transform(X_test)
        explained_variance = pca.explained_variance_ratio_
        return X_train, X_test, explained_variance
    elif method == "LDA":
        lda = LDA(n_components=2)
        X_train = lda.fit_transform(X_train, y_train)
        X_test = lda.transform(X_test)
        return X_train, X_test
    elif method == "Kernel PCA":
        kpca = KernelPCA(n_components=2, kernel="rbf")
        X_train = kpca.fit_transform(X_train)
        X_test = kpca.transform(X_test)
        return X_train, X_test

# create a function that fits a logistic regression model to the data and returns the accuracy score
def logistic_regression(X_train, X_test, y_train, y_test):
    classifier = LogisticRegression(random_state=0)
    classifier.fit(X_train, y_train)
    y_pred = classifier.predict(X_test)
    cm = confusion_matrix(y_test, y_pred)
    print("Confusion Matrix:")
    print(cm)
    accuracy = accuracy_score(y_test, y_pred)
    print("Accuracy:")
    print(accuracy)

# print the original data
print("Original Data:")
print(pd.DataFrame(data=np.concatenate((X, y.reshape(-1,1)), axis=1)))

# print the results of the dimensionality reduction
print("PCA:")
X_train_pca, X_test_pca, explained_variance = dimensionality_reduction(X_train, X_test, y_train, y_test, "PCA")
print("Explained Variance:")
print(explained_variance)
print("Reduced Training Data:")
print(pd.DataFrame(data=X_train_pca))
print("Reduced Testing Data:")
print(pd.DataFrame(data=X_test_pca))
logistic_regression(X_train_pca, X_test_pca, y_train, y_test)

print("LDA:")
X_train_lda, X_test_lda = dimensionality_reduction(X_train, X_test, y_train, y_test, "LDA")
print("Reduced Training Data:")
print(pd.DataFrame(data=X_train_lda))
print("Reduced Testing Data:")
print(pd.DataFrame(data=X_test_lda))
logistic_regression(X_train_lda, X_test_lda, y_train, y_test)

print("Kernel PCA:")
X_train_kpca, X_test_kpca = dimensionality_reduction(X_train, X_test, y_train, y_test, "Kernel PCA")
print("Reduced Training Data:")
print(pd.DataFrame(data=X_train_kpca))
print("Reduced Testing Data:")
print(pd.DataFrame(data=X_test_kpca))
logistic_regression(X_train_kpca, X_test_kpca, y_train, y_test)