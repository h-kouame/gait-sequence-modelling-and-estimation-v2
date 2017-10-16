function [accuracy, Q, logP] = chmmpath(modelpath, testdatapath)
    if nargin < 1
        modelpath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\HMM\CHMM'; 
        testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';
    elseif nargin < 2
        testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';  
    end
        
    %Build HMM
    CHMM = load(modelpath);
    A = CHMM.A;
    B = CHMM.B;
    
    data = load(testdatapath);
    LF2str = num2str(data.LF);
    LB2str = num2str(data.LB);
    RF2str = num2str(data.RF);
    RB2str = num2str(data.RB);
    feat2observ = strcat(LF2str, RF2str, LB2str, RB2str);
    O = bin2dec(feat2observ) + 1; %sequence of observations
%     test with reverse sequence of observations
%     OS = flipud(O); 
    [Q, logP] = hmmviterbi(O, A, B);
    accuracy = 100*sum(O == Q.')/length(O)
end