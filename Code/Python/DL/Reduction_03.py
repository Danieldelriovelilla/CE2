"""
    1. Load data from directory, this data contains a data matrix and a table with the data labels
    2. create a function that performs a dimensionality reduction with various methods and returns the reduced matrix
    3. compare the accuracy of the domensionality reduction matrix with the original
"""



## Load data from directory
from utils import *
import pandas as pd
import matplotlib.pyplot as plt

# Data
data_dir = r'..\Data'
X, Y = f_Get_Impact_Database_XY( data_dir )
# Labels 
Y = np.array(Y.height)


## Function that reduces dimensionality with 5 algorithms
from sklearn.decomposition import PCA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.manifold import TSNE
from sklearn.manifold import Isomap
from sklearn.manifold import MDS
from sklearn.manifold import LocallyLinearEmbedding

def reduce_dim(data, labels, method):
    """
    input: data and labels, method name
    output: reduced data and the explained variance ratio
    """
    print( "You are reducing data with: ", method )
    if method == "PCA":
        pca = PCA(n_components=2)
        pca.fit(data)
        return pca.transform(data), pca.explained_variance_ratio_
    elif method == "LDA":
        lda = LinearDiscriminantAnalysis(n_components=2)
        lda.fit(data,labels)
        return lda.transform(data), lda.explained_variance_ratio_
    elif method == "tSNE":
        tsne = TSNE(n_components=2)
        return tsne.fit_transform(data)#, tsne.explained_variance_ratio_
    elif method == "Isomap":
        isomap = Isomap(n_components=2)
        return isomap.fit_transform(data)#, isomap.explained_variance_ratio_
    elif method == "MDS":
        mds = MDS(n_components=2)
        return mds.fit_transform(data), mds.explained_variance_ratio_
    elif method == "LLE":
        lle = LocallyLinearEmbedding(n_components=2)
        return lle.fit_transform(data)#, lle.explained_variance_ratio_
    else:
        print("Method not found.")
        return

## Compare the accuracy of the reduced dimensionality matrix with the original
from sklearn.metrics import accuracy_score

# PCA
reduced_data, explained_variance = reduce_dim(X,Y,"PCA")
plt.scatter( reduced_data[:,0], reduced_data[:,1],  c=Y, cmap='jet' )
plt.title("PCA Reduced data")
plt.show()
# accuracy_pca = accuracy_score(Y, reduced_data[:,1])

# LDA
reduced_data, explained_variance = reduce_dim(X,Y,"LDA")
plt.scatter( reduced_data[:,0], reduced_data[:,1],  c=Y, cmap='jet' )
plt.title("LDA Reduced data")
plt.show()
# accuracy_lda = accuracy_score(Y, reduced_data[:,1])

# tSNE
reduced_data = reduce_dim(X,Y,"tSNE")
plt.scatter( reduced_data[:,0], reduced_data[:,1],  c=Y, cmap='jet' )
plt.title("tSNE Reduced data")
plt.show()
# accuracy_tsne = accuracy_score(Y, reduced_data[:,1])

# Isomap
reduced_data = reduce_dim(X,Y,"Isomap")
plt.scatter( reduced_data[:,0], reduced_data[:,1],  c=Y, cmap='jet' )
plt.title("Isomap Reduced data")
plt.show()
# accuracy_isomap = accuracy_score(Y, reduced_data[:,1])

# MDS
reduced_data, explained_variance = reduce_dim(X,Y,"MDS")
plt.scatter( reduced_data[:,0], reduced_data[:,1],  c=Y, cmap='jet' )
plt.title("MDS Reduced data")
plt.show()
# accuracy_mds = accuracy_score(Y, reduced_data[:,1])

# LLE
reduced_data = reduce_dim(X,Y,"LLE")
plt.scatter( reduced_data[:,0], reduced_data[:,1],  c=Y, cmap='jet' )
plt.title("LLE Reduced data")
plt.show()
# accuracy_lle = accuracy_score(Y, reduced_data[:,1])

# print("Accuracy of PCA:", accuracy_pca)
# print("Accuracy of LDA:", accuracy_lda)
# print("Accuracy of tSNE:", accuracy_tsne)
# print("Accuracy of Isomap:", accuracy_isomap)
# print("Accuracy of MDS:", accuracy_mds)
# print("Accuracy of LLE:", accuracy_lle)