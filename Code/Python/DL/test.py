import numpy as np
import pandas as pd
# import matplotlib.pyplot as plt
from utils import *


data_dir = r'..\Data'
X, Y = f_Get_Impact_Database_XY( data_dir )

print( np.array(Y.height) )