import numpy as np
from scipy import signal

def apply_filter(data, lowcut, highcut, fs):
  nyquist = 0.5 * fs
  low = lowcut / nyquist
  high = highcut / nyquist
  b, a = signal.butter(5, [low, high], btype = 'band')
  filter_data = signal.filtfilt(n, a, data)
  return filter_data

divided_data = {}
#put all bands (1-160Hz) into the All band
all_filtered_data = apply_filter(eeg_data, 1, 160, fs)
divided_data['All'] = all_filtered_data
