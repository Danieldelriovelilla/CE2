import numpy as np
import matplotlib.pyplot as plt
from sklearn.neighbors import LocalOutlierFactor
from numpy import nan

## BASIC DATA CELANING
def Single_Value_Column(df):
    """
    Function that removes columns with an unique value.
    Args:
        df (dataframe): Data dataframe.
    Return:
        df (dataframe): Clean dataframe.
    """
    # Pre delete shape
    print(df.shape)
    # Get number of unique values for each column
    counts = df.nunique()
    to_del = [i for i,v in enumerate(counts) if v == 1]
    print(to_del)
    # Drop useless columns
    df.drop(to_del, axis=1, inplace=True)
    print(df.shape)

    return df


def Few_Value_Column(df, value):
    """
    Function that removes columns with few values.
    Args:
        df (dataframe): Data dataframe.
        valeue (real): Percentaje of different values.
    Return:
        df (dataframe): Clean dataframe.
    """
    # delete columns where number of unique values is less than 1% of the rows
    print(df.shape)
    # get number of unique values for each column
    counts = df.nunique()
    # record columns to delete
    to_del = [i for i,v in enumerate(counts) if (float(v)/df.shape[0]*100) < value]
    print(to_del)
    # drop useless columns
    df.drop(to_del, axis=1, inplace=True)
    print(df.shape)

    return df


def Variance_Study(df, var_min=0.0, var_max=1.55, var_step=0.05):
    """
    Function that performs a variance study.
    Args:
        df (dataframe): Data dataframe.
        var_min (real): First variance value. 
        var_max (real): Last variance value.
        var_step (real): Distance between variances.
    Return:
        df (dataframe): Clean dataframe.
    """
    var_values = df.var().to_numpy()
    # define thresholds to check
    thresholds = np.arange(var_min, var_max, var_step)
    f_idx = list()
    n_features = list()
    for i, t in enumerate(thresholds):
        features = np.where( var_values<t )[0]
        f_idx.append( features )
        n_features.append( len( features ) ) 
        # print('> Threshold = %.2f, Features = %d' % (t, n_features[i]))

    # VARIANCE STUDY
    plt.plot(thresholds, n_features)
    plt.title('N features under a certain variance')
    plt.xlabel('N features')
    plt.ylabel('variance')
    plt.show()

    idx_max = np.argmax(var_values)
    idx_min = np.argmin(var_values)
    col_m = df.iloc[:,idx_min].to_numpy()
    col_x = df.iloc[:,idx_max].to_numpy()

    fig, axs = plt.subplots(1, 2, sharey=True, tight_layout=True)
    axs[0].hist(col_m, bins=20)
    plt.ylabel('N features')
    plt.xlabel('signal [V]')
    axs[1].hist(col_x, bins=20)
    plt.title('Histogram of minimum and maximum variance features')
    plt.show()

    plt.plot(var_values)
    plt.title('Variance of each feature')
    plt.xlabel('Feature idx')
    plt.ylabel('variance')
    plt.show()

    plt.hist(var_values, 50)
    plt.title('Variance of each feature')
    plt.xlabel('variance')
    plt.ylabel('N features')
    plt.show()


## OUTLIER IDENTIFICATION
def Remove_Outliers(df, y_df):
    """
    Function that removes samples with outliers.
    Args:
        df (dataframe): Data dataframe.
        y_df (dataframe): Labels dataframe.
    Return:
        df (dataframe): Clean dataframe.
        y_df (dataframe): Clean dataframe.
    """
    # summarize the shape of the training dataset
    print(df.shape)
    data = df.values
    # identify outliers in the training dataset
    lof = LocalOutlierFactor()
    yhat = lof.fit_predict(data)
    # select all rows that are outliers
    mask = yhat == -1
    idx_outlier = np.where(mask)[0]
    for outlier in idx_outlier:
        print('Outlier label: ', y_df.iloc[outlier])
    # Remove outliers
    df = df.drop(df.index[idx_outlier])
    y_df = y_df.drop(y_df.index[idx_outlier])
    print(df.shape)

    return df, y_df

## REMOVE MISSING VALUES
def Remove_Missing_Values(df, y_df):
    """
    Function that removes rows with empty values.
    Args:
        df (dataframe): Data dataframe.
        y_df (dataframe): Labels dataframe.
    Return:
        df (dataframe): Clean dataframe.
        y_df (dataframe): Clean dataframe.
    """
    # summarize the shape of the raw data
    print('Pre missing values: ', df.shape)
    # replace '0' values with 'nan'
    df = df.replace(0, nan)
    # drop rows with missing values
    is_NaN = df.isnull()
    row_NaN = is_NaN.any(axis=1)
    row_NaN = row_NaN.index[row_NaN.iloc[:] == True].tolist()
    df = df.drop(df.index[row_NaN])
    y_df = y_df.drop(y_df.index[row_NaN])
    # summarize the shape of the data with missing rows removed
    print('Post missing values: ', df.shape)
    
    return df, y_df


"""
    Al no haber missing values, no se prosigue con los puntos 8, 9 y 10.
"""