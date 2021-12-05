# import matplotlib.pyplot as plt
from utils_main import *
import pandas as pd


data_dir = r'..\Data'
X, Y = f_Get_Impact_Database_XY( data_dir )


def get_low_variance_columns(df, threshold=0.0):

    condition = df.var() < threshold
    idx = condition.index[condition == True].tolist()
    return idx

idx = get_low_variance_columns(X, threshold=0.5)

print( '\nidx: ', idx, '\n' )

import matplotlib.pyplot as plt
plt.plot( X[0,:] )
plt.show()

## DATA CLEANING
import numpy as np
import pandas as pd
from numpy import arange
from pandas import read_csv
from sklearn.feature_selection import VarianceThreshold
from matplotlib import pyplot

#-> Delete columns with a single unique value
print('\nSINGLE VALUE\n')
# get number of unique values for each column
counts = X.nunique()
# record columns to delete
to_del = [i for i,v in enumerate(counts) if v == 1]
print(to_del)
# drop useless columns
X.drop(to_del, axis=1, inplace=True)
print(X.shape)

#-> Delete columns where number of unique values is less than 1% of the rows
print('\nUNIQUE VALUE LESS THAN 1%\n')
print(X.shape)
# get number of unique values for each column
counts = X.nunique()
# record columns to delete
to_del = [i for i,v in enumerate(counts) if (float(v)/X.shape[0]*100) < 1]
print(to_del)
# drop useless columns
X.drop(to_del, axis=1, inplace=True)
print(X.shape)


#-> Explore the effect of the variance thresholds on the number of selected features
print('\nVARIANCE THRESHOLDS\n')
# split data into inputs and outputs
data = X.values
x = data[:, :-1]
y = data[:, -1]
print(x.shape, y.shape)
# define thresholds to check
thresholds = arange(0.0, 0.55, 0.05)
# apply transform with each threshold
results = list()
for t in thresholds:
    # define the transform
    transform = VarianceThreshold(threshold=t)
    # transform the input data
    x_sel = transform.fit_transform(x)
    # determine the number of input features
    n_features = x_sel.shape[1]
    print('>Threshold=%.2f, Features=%d' % (t, n_features))
    # store the result
    results.append(n_features)
# plot the threshold vs the number of selected features
pyplot.plot(thresholds, results)
pyplot.show()

#-> locate rows of duplicate data
print('\nLOCATE DUPLICATE DATA\n')
# calculate duplicates
dups = X.duplicated()
# report if there are any duplicates
print(dups.any())
# list all duplicate rows
print(X[dups])

#-> delete rows of duplicate data from the dataset
print('\nREMOVE DUPLICATE DATA\n')
# dataset shape before removing rows
print(X.shape)
# delete duplicate rows
X.drop_duplicates(inplace=True)
print(X.shape)


def get_low_variance_columns(df, threshold=0.0):
    return df.columns[df.var() < threshold]

columns = get_low_variance_columns(X, threshold=0.5)

print( columns )