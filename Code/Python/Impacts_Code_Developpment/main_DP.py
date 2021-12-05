from utils_DP import *
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Read dataset
data_dir = r'C:\Users\Usuario\OneDrive - Universidad Politécnica de Madrid\MUSE\S3\CE2\Code\Python\Data'
X, Y = f_Get_Impact_Database_XY( data_dir )
# Check if the dataframe has the correct form
plt.plot( X.iloc[0].to_numpy() )
plt.show()
# Tranform datatype
# X = X.to_numpy()
#y = Y.height






# Validation f the function
kTTV_Dataset = Split_kTTV_Dataset(Y, train_per=0.5, test_per=0.25, val_per=0.25, kfolds=4)
train, test, val = kTTV_Dataset.get_idx(0)

print( len(test) )





    
    

#for train_index, test_index in rskf.split(X, y):
    #print("TRAIN:", len(train_index), "TEST:", len(test_index))
    #print("TRAIN:", train_index, "TEST:", test_index)
    #print( 'Relacion', len(train_index)/len(test_index) )
    
    #X_train, y_train = X.loc[train_index], y[train_index]
    #X_tv, y_tv = X.loc[test_index], y[test_index]
    
    #X_test, X_validation, y_test, y_validation = train_test_split(X_tv y_tv, test_size=0.5, random_state=1)