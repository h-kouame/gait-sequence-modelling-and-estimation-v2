function [A, B, accuracy] = foothmm(datapath, foot)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';  
        foot = 'LF';
    elseif nargin < 2
        foot = 'LF';   
    end
    
    data = load(datapath);
    ST = data.LF + 1;
    switch foot
        case 'RF'
            ST = data.RF + 1;
        case 'LB'
            ST = data.LB + 1;
        case 'RB'  
            ST = data.RB + 1;
    end
    
    OT = ST;
    M = length(unique(ST));
    N = M;
    PSEUDOE = ones(M, N);
    PSEUDOTR = PSEUDOE;
    %evaluate
    [A, B] = hmmestimate(OT, ST, 'PSEUDOEMISSIONS',PSEUDOE, 'PSEUDOTRANSITIONS',PSEUDOTR);
    
   %  Save HMM parameters
   filepath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\HMM\';
%    datestamp = string(datetime('now','TimeZone','local','Format','yyyyMMdd_HHmmss'));
%    filename = strcat(filepath , foot, '_', datestamp, '.mat');
   filename = strcat(filepath , foot, '.mat');
   save(filename, 'A', 'B');
    
    %decode
%     SS = flipud(ST);
%     OS = SS;
%     [pStates, pSeq, fs, bs, s] = hmmdecode_(OS, A, B);
%     SE = hmmviterbi(OS, A, B); %estimated state sequence
%     accuracy = 100*(sum(SE.'== SS)/length(SS));
end