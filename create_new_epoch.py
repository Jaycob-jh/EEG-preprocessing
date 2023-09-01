# -*- coding: utf-8 -*-
# @Time : 2023/9/1 21:52
# @Email : Hai Jia
# @Author : jh_jiahai@163.com

import numpy as np
import mne

path = '/Users/cuilab/Desktop/matlabworkspace/Brainproject/original_raw_data/'
rawdata = mne.io.read_raw_eeglab(path + 'sub03.set', preload=True)
# print(rawdata.info['ch_names'])

#create the new eeg epoch for adding the channel informations

data = rawdata.get_data()
exclude_rows = [60, 62, 63]
data = [row for index, row in enumerate(data) if index + 1 not in exclude_rows]

exclude_channel = ['CB1', 'CB2', 'TRIGGER']
channel_dict = {value: index + 1 for index, value in enumerate(rawdata.info['ch_names']) if index + 1 not in exclude_channel}
channel_type = ['eeg'] * 63
channel_names = list(channel_dict.keys())
channel_index = list(channel_dict.values())
n_channel = len(channel_index)
info = mne.create_info(sfreq=1000, ch_names=channel_names, ch_types=channel_type)
info.set_montage("standard_1005")
raw = mne.io.RawArray(data, info)
