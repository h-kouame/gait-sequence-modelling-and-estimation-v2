function all_feethmm(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';    
    end
%     Build and save HMM sub-models
    foothmm(datapath, 'LF');
    foothmm(datapath, 'RF');
    foothmm(datapath, 'LB');
    foothmm(datapath, 'RB');