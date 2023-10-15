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

from keras.layers import Input, Conv1D, BatchNormalization
from keras.layers import Activation, MaxPool1D, GlobalAveragePooling1D
from keras.layers import Dense, GaussianDropout, TimeDistributed
from keras.models import Model

import mne
from mne.datasets.sleep_physionet.age import fetch_data
import model_utils as mu

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