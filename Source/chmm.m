function [A, B] = chmm(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\HMM\';  
    end
    
    LF_HMM = load(strcat(datapath, 'LF.mat'));
    RF_HMM = load(strcat(datapath, 'RF.mat'));
    LB_HMM = load(strcat(datapath, 'RB.mat'));
    RB_HMM = load(strcat(datapath, 'LB.mat'));
    
    A1 = LF_HMM.A;
    B1 = LF_HMM.B;
    
    A2 = RF_HMM.A;
    B2 = RF_HMM.B;
    
    A3 = LB_HMM.A;
    B3 = LB_HMM.B;
    
    A4 = RB_HMM.A;
    B4 = RB_HMM.B;
    
    tempA = {A1, A2, A3, A4};
    tempB = {B1, B2, B3, B4};
    
    feat_num = 4;
    N = 2^feat_num; 
    A = zeros(N);
    B = zeros(N);
    for i = 1:N
        for j = 1:N
            A(i, j) = combined_prob(i, j, tempA); 
            B(i, j) = combined_prob(i, j, tempB);
        end
    end
    
%  Save HMM parameters
   filepath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\HMM\';
%    datestamp = string(datetime('now','TimeZone','local','Format','yyyyMMdd_HHmmss'));
%    filename = strcat(filepath ,'CHMM_' , datestamp, '.mat');
   filename = strcat(filepath ,'CHMM', '.mat');
   save(filename, 'A', 'B');
end