function [accuracy, Q, logP] = chmmpath(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';  
    end
    %Build HMM
    [A, B] = chmm(datapath);
    
    data = load(datapath);
    LF2str = num2str(data.LF);
    LB2str = num2str(data.LB);
    RF2str = num2str(data.RF);
    RB2str = num2str(data.RB);
    feat2observ = strcat(LF2str, LB2str, RF2str, RB2str);
    O = bin2dec(feat2observ) + 1; %sequence of observations
    %test with reverse sequence of observations
    OS = flipud(O); 
    [Q, logP] = hmmviterbi(OS, A, B);
    accuracy = 100*sum(OS == Q.')/length(OS);
end