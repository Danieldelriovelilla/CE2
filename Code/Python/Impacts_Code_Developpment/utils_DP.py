import scipy.io
import numpy as np
import os
import pandas as pd
import h5py
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.model_selection import train_test_split



def f_Get_Impact_Database_XY( data_dir ):
    """
    Load .mat file and extract fields
    Args:
        data_dir (strign): Path to X.mat and Y.csv (also contains Y.mat).
    Return:
        X (dataframe): X matrix converted to dataframe, more easy to process data with df.
        Y (dataframe): multiple targets.
    """
    # Data
    file = h5py.File(data_dir + '/X.mat', 'r')
    X = np.transpose( file['X'][()] )  # file['X'].value
    X = pd.DataFrame( X )
    # Labels
    Y = pd.read_csv( data_dir + '/Y.csv', delimiter=';' ) 

    return X, Y

###      ------      ###

class C_Kfold_idx():
    """
        Class wich contains the index of test, training and validation samples
    """
    def __init__(self):
        self.training = []
        self.test = []
        self.validation = []
    def append_idx(self, att, idx):
        self.__dict__[att].append(idx)
    def get_idx(self, i):
        return self.training[i], self.test[i], self.validation[i]

def Split_kTTV_Dataset(df, train_per=0.5, test_per=0.25, val_per=0.25, kfolds=4):
    """
    Function that generates the row index that will be used for training, test and validation 
    Args:
        df (dataframe): Data or labels dataframe.
        x_per (real<1): Percentaje of the dataset that will be used to each task.
        kfolds (integer): Number of different splits combinations.
    Return:
        kTTV_Dataset (C_Kfold_idx obj): Object with the index.
    """
    if np.round(test_per + train_per + val_per, 3) != 1.0:
        print( "Train, test and validation percentajes don't sum 1" )
    idx_compleate = np.linspace( 0, len(df.index)-1, len(df.index) )
    kTTV_Dataset = C_Kfold_idx()
    for k in range(kfolds):
        # Generate training index
        idx_train, idx_tv = train_test_split(
            idx_compleate, 
            test_size=(1-train_per),
            random_state=1*k
            )
        # Generate test and validation index
        idx_val, idx_test = train_test_split(
            idx_tv, 
            test_size=test_per/(test_per+val_per),
            random_state=1*k
            )
        # Save the index in it's objet attributes
        kTTV_Dataset.append_idx( 'training', idx_train.tolist() )
        kTTV_Dataset.append_idx( 'test', idx_test.tolist() )
        kTTV_Dataset.append_idx( 'validation', idx_val.tolist() )

    return kTTV_Dataset