# -*- coding: utf-8 -*-
# @Author  : Jaycob
# @Time    : 2023/3/22 9:36
# @Email   : jh_jiahai@163.com
"""
General data preprocessing pipeline:
    step1. re-referencing
    step2. perform notch filtering (50Hz and 100Hz) and bandpass filtering (4-40Hz)
    step3. run ICA (visual inspection of both time signals and their associated topographies)
    step4. interpolate bad channels (if any, after visual inspection)
    step5. extract epochs
"""

import scipy.io as sio
from scipy.io import savemat
import numpy as np
from math import ceil
import matplotlib.pyplot as plt
import mne

## set parameters
fs = 500            # sampling rate
ch_names = ['P8', 'T8', 'CP6', 'FC6', 'F8', 'F4', 'C4', 'P4', 'AF4', 'Fp2', 'Fp1', 'AF3', 'Fz', 'FC2',
            'Cz', 'CP2', 'PO3', 'O1', 'Oz', 'O2', 'PO4', 'Pz', 'CP1', 'FC1', 'P3', 'C3', 'F3', 'F7',
            'FC5', 'CP5', 'T7', 'P7']
ch_types = ['eeg']*32

##--------- nested functions -----------##
def filtering(data, notchfre, passband):
    # Notch filtering
    data = data.notch_filter(freqs=notchfre)
    # Bandpass filtering
    data.filter(passband[0], passband[1], fir_design='firwin', skip_by_annotation='edge')
    return data

def extract_epochs(data, events, task_dur):
    eeg = data.get_data()
    Ntrial = events.shape[0]
    epoches = []
    for i in range(Ntrial):
         epoches.append(eeg[:, ceil(events[i, 0]*fs):ceil(events[i, 0]*fs)+task_dur*fs])
    return np.array(epoches)

def data_cleaning(data, events):
    # step1. re-referencing
    data = data.set_eeg_reference(ref_channels='average')

    # step2. filtering
    data = filtering(data, (50, 100), (4, 40))

    # step3. run ica
    ica = mne.preprocessing.ICA(n_components=15, random_state=97, method='fastica', max_iter='auto')
    ica.fit(data)
    # ica.plot_sources(data)
    # ica.plot_properties(data, picks=list(range(0, 15, 1)))
    muscle_idx_auto, scores = ica.find_bads_muscle(data)
    ica.exclude = muscle_idx_auto
    ica.apply(data)

    # step4. bad channels
    # Here, every channel works well
    # Define your own bad channels
    # my_bad_channels = ['Fp1', 'Fp2']
    # data.info['bads'] += my_bad_channels
    # data.interpolate_bads(reset_bads=True)

    # step5. extract epoches
    cleanedData = extract_epochs(data, events, 5)
    return cleanedData

##--------- start processing now! -------------##
rawDataPath = './'
cleanedDataPath = ./'

# change the name according to the task, see follows

task_name = ''

if task_name == '':
    load_data_name = ''
    load_event_name = ''
    save_file_name = cleanedDataPath + ''
elif task_name == '':
    load_data_name = ''
    load_event_name = ''
    save_file_name = cleanedDataPath + ''
elif task_name == '':
    load_data_name = ''
    load_event_name = ''
    save_file_name = cleanedDataPath + ''
elif task_name == '':
    load_data_name = ''
    load_event_name = ''
    save_file_name = cleanedDataPath + ''

rawData = sio.loadmat(rawDataPath + load_data_name)
details = sio.loadmat(rawDataPath + load_event_name)

events = details['stimevent'][0, 0]['toc']
info = mne.create_info(ch_names, fs, ch_types)
rawDataArray = mne.io.RawArray(0.000001 * rawData['EEG_Data'], info)

montage_32 = mne.channels.make_standard_montage('biosemi32')
rawDataArray.set_montage(montage_32)

cleanedData = data_cleaning(rawDataArray, events)

savemat(save_file_name, {'eeg': cleanedData})
