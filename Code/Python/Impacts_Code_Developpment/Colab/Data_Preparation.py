# Read dataset
data_dir = r'/content/drive/MyDrive/MUSE/S3/CE2/Data'
X, Y = f_Get_Impact_Database_XY( data_dir )
print("X shape: ", X.shape)

# Generate the k splits of datasets
kTTV_Dataset = Split_kTTV_Dataset(Y)

# Get the index of a single fold
idx_train, idx_test, idx_val = kTTV_Dataset.get_idx(0)


## Split the dataset into Training, Validation and Test

# Get idxs
idx_train = [int(idx) for idx in idx_train]
idx_val = [int(idx) for idx in idx_val]
idx_test = [int(idx) for idx in idx_test]

# Load data and drop rows in order to empty RAM
x_val, y_val = X.loc[idx_val].values, Y.loc[idx_val].values
X = X.drop(idx_val)
time.sleep(5)
x_test, y_test = X.loc[idx_test].values, Y.loc[idx_test].values
X = X.drop(idx_test)
time.sleep(5)
x_train, y_train = X.loc[idx_train].values, Y.loc[idx_train].values
X = X.drop(idx_train)
time.sleep(25)
del X


## DATLOADER 
class Impacts(Dataset):
    """Impacts dataset."""
    def __init__(self, x, y, target, transform=None):
        """
        Args:
            csv_file (string): Path to the csv file with annotations.
            root_dir (string): Directory with all the images.
            transform (callable, optional): Optional transform to be applied
                on a sample.
        """
        all_sensors = x
        # one_sensor = all_sensors[:,0,:].reshape((-1, 2000))
        self.x = torch.from_numpy( all_sensors ).float()
        all_targets = y
        self.y = torch.from_numpy( all_targets[:,target] ).float()
        self.N = y.shape[0]
        self.target = target

    def __len__(self):
        return self.N

    def __getitem__(self, idx):
        x = self.x[idx,:].reshape(8,2000).transpose(0,1)   # --> 2000 x 8
        # x = self.x[idx,:].reshape(8,2000)   # --> 8 X 2000
        # x = self.x[idx,0]
        return x[:,:], self.y[idx]


## DATASETS
ds_train = Impacts(x_train,
                   y_train,
                   target=target
)
ds_test = Impacts(x_test,
                  y_test,
                  target=target
)
ds_val = Impacts(x_val,
                 y_val,
                 target=target
)


## DATALOADER

dl_train = DataLoader(dataset=ds_train , batch_size=32,
                        shuffle=True)
dl_test = DataLoader(dataset=ds_test , batch_size=32,
                        shuffle=True)
dl_val = DataLoader(dataset=ds_val , batch_size=32,
                        shuffle=True)


## CHECK DATASET AND DATALOADER

# Get item
x, y = ds_val[0]
print(y)
fig = plt.figure()
plt.plot(x)
plt.title("SINGLE IMPACT")
plt.show()

# Plot batches
for i_batch, sample_batched in enumerate(dl_train):
    print(i_batch, 
          sample_batched[0].size(),
          sample_batched[1].size())

    for i in range(0, 4):
        # plt.plot(sample_batched[0][i,:])
        plt.plot(sample_batched[0][i])
        plt.title("BATCH IMPACT: " + str(i+1))
        plt.show()

    # observe 4th batch and stop.
    if i_batch == 0:
        break