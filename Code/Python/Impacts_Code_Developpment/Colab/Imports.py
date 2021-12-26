import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms, utils
from __future__ import print_function, division
torch.manual_seed(0)
# device config
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(device)

import matplotlib.pyplot as plt
import pandas as pd
from skimage import io, transform
import numpy as np
from sklearn.metrics import mean_squared_error as MSE
%matplotlib inline

import time