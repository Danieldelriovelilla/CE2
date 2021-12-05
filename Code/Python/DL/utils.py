import scipy.io
import numpy as np
import os
import matplotlib.pyplot as plt
import pandas as pd
import h5py



def f_Get_Impact_Database_XY( data_dir ):
    """
    Load .mat file and extract fields
    Args:
        data_dir (strign): Path to X.mat and Y.csv (also contains Y.mat).
    """
    # Data
    file = h5py.File(data_dir + '/X.mat', 'r')
    X = np.transpose( file['X'][()] )  # file['X'].value
    # Labels
    Y = pd.read_csv( data_dir + '/Y.csv', delimiter=';' ) 

    return X, Y


def f_Dataset_Mat2Py( matlab_dir, python_dir ):
    """
    Find MATLAB file with impact data and save everithing the dataset to a csv file
    Args:
        matlab_dir (strign): Path to .mat files directory.
    """
    entries = os.listdir( matlab_dir )      # Get .mat names

    data_fields = ['Impact']
    label_fields = ['x', 'y', 'm', 'h', 'E']
    label_df = pd.DataFrame( columns = label_fields)

    for i, entity in enumerate( entries ):
        mat_file = matlab_dir + '/' + entity
        data, x, y, m, h, E = f_Read_Impact_Mat2Py( mat_file )

        if i == 0:
            data_array = data
            label_array = np.array([x, y, m, h, E]).reshape(1,-1)
        else:
            data_array = np.concatenate( 
                (data_array, data), 
                axis=0
                )
            label_array = np.concatenate( 
                ( label_array, np.array([x, y, m, h, E]).reshape(1,-1) ), 
                axis=0
                )

        if i == 50:
            break


    np.savetxt( python_dir + '/' + 'Impact_Data.csv' , 
            data_array,
            delimiter =", ",
            fmt ='% s')

    np.savetxt( python_dir + '/' + 'Impact_Labels.csv' , 
            label_array,
            delimiter =", ", 
            fmt ='% s')

    return


def f_Read_Impact_Mat2Py( file_dir ):
    """
    Load .mat file and extract fields
    Args:
        file_dir (strign): Path to .mat file.
    """
    # Open matlab file
    mat_file = scipy.io.loadmat( file_dir )
    impact = mat_file['impact'] # data.impact
    
    # Extract all field to variables
    data = np.reshape( impact['data'][0][0], (1,-1) )
    x = impact['x'][0][0][0]
    y = impact['y'][0][0][0]
    m = impact['mass'][0][0][0]
    h = impact['height'][0][0][0]
    E = impact['energy'][0][0][0]

    return data, x, y, m, h, E



