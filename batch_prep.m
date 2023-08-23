clc;clear;
%% Specify Basic information of different groups     将cdt文件转换成set文件，降采样为500，去除无用电极，保存。
group_dir = 'D:\demo';     % 此处路径需要设置为自己的文件目录
group_files = dir([group_dir, filesep, '*.cdt']);  %filesep是\的意思
for i=1:length(group_files)
    subj_fn = group_files(i).name;
    EEG = loadcurry(strcat(group_dir, filesep, subj_fn), 'CurryLocations', 'False');    %导入原始数据
    EEG = pop_resample( EEG, 500);   %降采样
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',80);   %带通滤波
    EEG = pop_eegfiltnew(EEG, 'locutoff',48,'hicutoff',52,'revfilt',1);    %陷波滤波
    EEG = pop_select( EEG, 'rmchannel',{'M1','M2','HEO','VEO','TRIGGER'});  %去除无关电极  
    EEG = pop_saveset( EEG, 'filename',strcat(group_files(i).name(1:end-4), '.set'), 'filepath',strcat(group_dir, filesep, '_step1'));   %注意需要在运行代码之前，文件目录下建一个_resam_remch的文件夹，以下雷同
end
