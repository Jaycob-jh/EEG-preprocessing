# EEG-preprocessing
This file contains a simple MI-EEG preprocessing step(python-mne). Include:
step1. re-referencing
step2. perform notch filtering (50Hz and 100Hz) and bandpass filtering (4-40Hz)
step3. run ICA
step4. interpolate bad channels (if any, after visual inspection)
step5. extract epochs
