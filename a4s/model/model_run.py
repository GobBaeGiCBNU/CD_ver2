# from tensorflow.python.client import device_lib
# device_lib.list_local_devices()

import torch
from torch import nn
print(torch.__version__)

device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
torch.cuda.is_available()
print('학습을 진행하는 기기:',device)

import os
import copy
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import model

import mne
from mne.datasets.sleep_physionet.age import fetch_data
import model_utils as mu

from torch.utils.data import DataLoader
from torch.nn import CrossEntropyLoss
from torch.optim import Adam

from sklearn.metrics import cohen_kappa_score
from sklearn.metrics import balanced_accuracy_score

mne.set_log_level('ERROR')  # To avoid flooding the cell outputs with messages

subjects = range(30)
recordings = [1]

# # To load all subjects and recordings, uncomment the next line
# subjects, recordings = range(83), [1, 2]

fnames = fetch_data(subjects=subjects, recording=recordings, on_missing='warn')

# Load recordings
raws = [mu.load_sleep_physionet_raw(f[0], f[1]) for f in fnames]

# Plot a recording as a sanity check
# raws[0].plot();

l_freq, h_freq = None, 30

for raw in raws:
    raw.load_data().filter(l_freq, h_freq)  # filtering happens in-place

# # Plot the power spectrum of a recording as sanity check
# raws[0].plot_psd();

global event_id

event_id = {
        'Sleep stage W': 1,
        'Sleep stage Light': 2,
        'Sleep stage Deep': 3,
        'Sleep stage R': 4}

# Apply windowing and move to pytorch dataset
all_datasets = [mu.EpochsDataset(*mu.extract_epochs(raw), subj_nb=raw.info['subject_info']['id'], 
                              rec_nb=raw.info['subject_info']['rec_id'], transform=mu.scale) 
                for raw in raws]

# Concatenate into a single dataset
dataset = mu.ConcatDataset(all_datasets)

np.shape(dataset)

# We seed the random number generators to make our splits reproducible
torch.manual_seed(87)
np.random.seed(87)

# Use recording 1 of subjects 0-9 as test set
test_recs = [(subj_nb, rec_nb)  # DO NOT CHANGE! This is a fixed set.
             for subj_nb, rec_nb in zip(range(10), [1] * 10)]
test_ds, train_ds = mu.pick_recordings(dataset, test_recs)

# Split remaining recordings into training and validation sets
n_subjects_valid = max(1, int(len(train_ds.datasets) * 0.2))
train_ds, valid_ds = mu.train_test_split(train_ds, n_subjects_valid, split_by='subj_nb')

print('Number of examples in each set:')
print(f'Training: {len(train_ds)}')
print(f'Validation: {len(valid_ds)}')
print(f'Test: {len(test_ds)}')

classes_mapping = {0: 'W', 1: 'Light', 2:'Deep', 3:'REM'}

# Computing class weight
from sklearn.utils.class_weight import compute_class_weight

train_y = np.concatenate([ds.epochs_labels for ds in train_ds.datasets])
class_weights = compute_class_weight('balanced', classes=np.unique(train_y), y=train_y)
print(class_weights)

sfreq = raws[0].info['sfreq']  # Sampling frequency
n_channels = raws[0].info['nchan']  # Number of channels

model = model.SleepStagerChambon2018(n_channels, sfreq, n_classes=4)

# Create dataloaders
train_batch_size = 128  # Important hyperparameter
valid_batch_size = 256  # Can be made as large as what fits in memory; won't impact performance
num_workers = 0  # Number of processes to use for the data loading process; 0 is the main Python process

loader_train = DataLoader(
    train_ds, batch_size=train_batch_size, shuffle=True, num_workers=num_workers)
loader_valid = DataLoader(
    valid_ds, batch_size=valid_batch_size, shuffle=False, num_workers=num_workers)
loader_test = DataLoader(
    test_ds, batch_size=valid_batch_size, shuffle=False, num_workers=num_workers)

optimizer = Adam(model.parameters(), lr=1e-3, weight_decay=0)
criterion = CrossEntropyLoss(weight=torch.Tensor(class_weights).to(device))

n_epochs = 50
patience = 10

best_model, history = mu.train(
    model, loader_train, loader_valid, optimizer, criterion, n_epochs, patience, 
    device, metric=cohen_kappa_score)

# Compute test performance

best_model.eval()

y_pred_all, y_true_all = list(), list()
for batch_x, batch_y in loader_test:
    batch_x = batch_x.to(device=device, dtype=torch.float32)
    batch_y = batch_y.to(device=device, dtype=torch.int64)
    output = model.forward(batch_x)
    y_pred_all.append(torch.argmax(output, axis=1).cpu().numpy())
    y_true_all.append(batch_y.cpu().numpy())
    
y_pred = np.concatenate(y_pred_all)
y_true = np.concatenate(y_true_all)
rec_ids = np.concatenate(  # indicates which recording each example comes from
    [[i] * len(ds) for i, ds in enumerate(test_ds.datasets)])

test_bal_acc = balanced_accuracy_score(y_true, y_pred)
test_kappa = cohen_kappa_score(y_true, y_pred)

print(f'Test balanced accuracy: {test_bal_acc:0.3f}')
print(f'Test Cohen\'s kappa: {test_kappa:0.3f}')