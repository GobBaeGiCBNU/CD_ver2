from tensorflow.python.client import device_lib
device_lib.list_local_devices()

import torch
print(torch.__version__)

device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
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
import model_utils

mne.set_log_level('ERROR')  # To avoid flooding the cell outputs with messages

subjects = range(30)
recordings = [1]

# # To load all subjects and recordings, uncomment the next line
# subjects, recordings = range(83), [1, 2]

fnames = fetch_data(subjects=subjects, recording=recordings, on_missing='warn')

# Load recordings
raws = [model_utils.load_sleep_physionet_raw(f[0], f[1]) for f in fnames]

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