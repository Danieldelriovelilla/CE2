## https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.RepeatedStratifiedKFold.html

import matplotlib.pyplot as plt
import time

## Load data from directory
from utils import *
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.preprocessing import StandardScaler

# Data
data_dir = r'..\Data'
X, y = f_Get_Impact_Database_XY( data_dir )
X = X[:,0:-1:1]
# Labels 
y = np.array( y.height )
# Standarize data
fig = plt.figure()
plt.xlim( 0, X.shape[1] )
plt.ylim( np.min( X[0,:] ), np.max( X[0,:] ) )
plt.plot( X[0,:], linewidth=0.75 )
sc = StandardScaler()
X = sc.fit_transform(X)
plt.plot( X[0,:], linewidth=0.75 )

plt.grid()
# plt.show()

# Number of splits
Ns = 5

## Beggin process
start_time = time.time()

## evaluate logistic regression model on raw data
from numpy import mean
from numpy import std
from sklearn.datasets import make_classification
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.linear_model import LogisticRegression

## LOGISTIC REGRESSION
model = LogisticRegression()
# evaluate model
cv = RepeatedStratifiedKFold(n_splits=Ns, n_repeats=3, random_state=1)
n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
# report performance
print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))


## PCA
from sklearn.pipeline import Pipeline
from sklearn.decomposition import PCA

# define the model
steps = [('pca', PCA(n_components=10)), ('m', LogisticRegression())]
model = Pipeline(steps=steps)
# evaluate model
cv = RepeatedStratifiedKFold(n_splits=Ns, n_repeats=3, random_state=1)
n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
# report performance
print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))


# SVD logistic regression algorithm for classification
from sklearn.decomposition import TruncatedSVD


# define the pipeline
steps = [('svd', TruncatedSVD(n_components=10)), ('m', LogisticRegression())]
model = Pipeline(steps=steps)
# evaluate model
cv = RepeatedStratifiedKFold(n_splits=Ns, n_repeats=3, random_state=1)
n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
# report performance
print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))


# evaluate isomap with logistic regression algorithm for classification
from sklearn.manifold import Isomap

# define the pipeline
steps = [('iso', Isomap(n_components=10)), ('m', LogisticRegression())]
model = Pipeline(steps=steps)
# evaluate model
cv = RepeatedStratifiedKFold(n_splits=Ns, n_repeats=3, random_state=1)
n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
# report performance
print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))


# evaluate lle and logistic regression for classification
from sklearn.manifold import LocallyLinearEmbedding

# define the pipeline
steps = [('lle', LocallyLinearEmbedding(n_components=10)), ('m', LogisticRegression())]
model = Pipeline(steps=steps)
# evaluate model
cv = RepeatedStratifiedKFold(n_splits=Ns, n_repeats=3, random_state=1)
n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
# report performance
print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))



# evaluate modified lle and logistic regression for classification
from sklearn.manifold import LocallyLinearEmbedding

# define the pipeline
steps = [('lle', LocallyLinearEmbedding(n_components=5, method='modified', n_neighbors=10)), ('m', LogisticRegression())]
model = Pipeline(steps=steps)
# evaluate model
cv = RepeatedStratifiedKFold(n_splits=Ns, n_repeats=3, random_state=1)
n_scores = cross_val_score(model, X, y, scoring='accuracy', cv=cv, n_jobs=-1)
# report performance
print('Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

## END PROCESS
print("--- %s seconds ---" % (time.time() - start_time))