clc;clear;
%% Specify Basic information of different groups     Save the cdt file2set,downsample to 500,delete the unuseful eeg channels and save the data.
group_dir = 'D:\demo';     % the raw eeg data filepath.
group_files = dir([group_dir, filesep, '*.cdt']);
for i=1:length(group_files)
    subj_fn = group_files(i).name;
    EEG = loadcurry(strcat(group_dir, filesep, subj_fn), 'CurryLocations', 'False');    %load the rawdata
    EEG = pop_resample( EEG, 500);   %downsampling
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',80);   %band filtering
    EEG = pop_eegfiltnew(EEG, 'locutoff',48,'hicutoff',52,'revfilt',1);    %
    EEG = pop_select(EEG, 'rmchannel',{'M1','M2','HEO','VEO','TRIGGER'});  %delete channels  
    EEG = pop_saveset(EEG, 'filename',strcat(group_files(i).name(1:end-4), '.set'), 'filepath',strcat(group_dir, filesep, '_step1'));   % _step1 is for your own datapath which you want to create
end

%%   run ICA
group1_dir = 'D:\demo';     % the raw data path
group1_dir1 = 'D:\demo\_preica';     % the data for ICA prep
group1_files = dir([group1_dir1, filesep, '*.set']); 
for i=1:length(group1_files)
    subj_fn = group1_files(i).name;
    EEG = pop_loadset('filename',strcat(subj_fn(1:end-4), '.set'), 'filepath', strcat(group1_dir, filesep, '_preica')); %load the data
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');   % run ICA
    EEG = pop_saveset( EEG, 'filename',strcat(group1_files(i).name(1:end-4), '.set'), 'filepath',strcat(group1_dir, filesep, '_ica'));  %load the data, _ica is for your own datapath which you want to create 
end
%% use the ICLabel to remove ICA components automatically
group1_dir = 'D:\demo';     
group1_dir2 = 'D:\demo\_ica'; 
group1_files = dir([group1_dir2, filesep, '*.set']); 
for i=1:length(group1_files)
    subj_fn = group1_files(i).name;
    EEG = pop_loadset('filename',strcat(subj_fn(1:end-4), '.set'), 'filepath', group1_dir2);
    EEG = pop_iclabel(EEG, 'default');
    EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;NaN NaN;NaN NaN;NaN NaN;NaN NaN]); % Mark artifact components. Here you can customize the threshold, followed by Brain, Muscle, Eye, Heart, Line Noise, Channel Noise, Other.
    EEG = pop_subcomp( EEG, [], 0)   %Remove the aforementioned artifacts
    EEG = pop_reref( EEG, []);    %Whole Brain Average Weight Reference
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(group1_files(i).name(1:end-4), '.set'), 'filepath',strcat(group1_dir, filesep, '_rm_ica')); %_rm_ica is for your own datapath which you want to create
end
