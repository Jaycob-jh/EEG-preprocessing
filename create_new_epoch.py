# -*- coding: utf-8 -*-
# @Time : 2023/9/1 21:52
# @Email : Hai Jia
# @Author : jh_jiahai@163.com

import numpy as np
import mne

path = '/Users/cuilab/Desktop/matlabworkspace/Brainproject/original_raw_data/'
rawdata = mne.io.read_raw_eeglab(path + 'sub03.set', preload=True)
rawdata.drop_channels(['CB1', 'CB2', 'TRIGGER'])

montage = mne.channels.make_standard_montage("standard_1005")
"""
The neuroscan montage is not standard! We should change them!
"""
UM_rename_dict = {"FP1": "Fp1",
                  "FP2": "Fp2",
                  "FPZ": "Fpz",
                  "FZ": "Fz",
                  "FCZ": "FCz",
                  "CZ": "Cz",
                  "CPZ": "CPz",
                  "OZ": "Oz",
                  "PZ": "Pz",
                  "POZ": "POz"}
rawdata.rename_channels(UM_rename_dict)
rawdata.set_montage("standard_1005")

channel_type = ['eeg'] * 60
channel_dict = {value: index + 1 for index, value in enumerate(rawdata.info['ch_names'])}
channel_names = list(channel_dict.keys())
channel_index = list(channel_dict.values())
n_channel = len(channel_index)
info = mne.create_info(sfreq=1000, ch_names=channel_names, ch_types=channel_type)
info.set_montage("standard_1005")
data = rawdata.get_data()
raw = mne.io.RawArray(data, info)
