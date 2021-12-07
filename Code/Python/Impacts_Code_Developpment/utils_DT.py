from sklearn.preprocessing import MinMaxScaler
from pickle import dump, load
import pandas as pd
import numpy as np


class MinMaxScaleAll:
    def __init__(self) -> None:
        self.min = []
        self.min = []
        pass

    def Fit(self, df):
        val = df.values
        self.min = np.min(val)
        self.max = np.max(val)

    def Scale(self, df):
        val = df.values
        valnorm = ( val - self.min )/( self.max - self.min )
        return pd.DataFrame(valnorm)

    def Inverse(self, df):
        valnorm = df.values
        val = valnorm*( self.max - self.min )  + self.min
        return pd.DataFrame(val)

def Normalize(X, Y, idx_train, idx_test, idx_val):

    X_train = X.loc[idx_train]
    Y_train = Y.loc[idx_train]
    X_test = X.loc[idx_test]
    Y_test = Y.loc[idx_test]
    X_val = X.loc[idx_val]
    Y_val = Y.loc[idx_val]

    # Transform data
    transX = MinMaxScaleAll()
    transX.Fit(X_train)
    x_train = transX.Scale(X_train)
    x_test = transX.Scale(X_test)
    x_val = transX.Scale(X_val)

    # Normalization of targets
    transY = MinMaxScaler( feature_range=(0,1) )
    transY.fit( Y_train )
    y_train = pd.DataFrame(
        transY.transform( Y_train )
        )
    y_test = pd.DataFrame(
        transY.transform( Y_test )
        )
    y_val = pd.DataFrame(
        transY.transform( Y_val )
        )

    # Save transforms
    dump(transX, open('Transforms/transX.pkl', 'wb'))
    dump(transY, open('Transforms/transY.pkl', 'wb'))
    # Load transform
    # transY = load(open('Transforms/transY.pkl', 'rb'))
    return x_train, x_test, x_val, y_train, y_test, y_val