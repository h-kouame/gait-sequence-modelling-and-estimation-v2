function [A, B] = chmm(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';  
    end
    
    [A1, B1] = foothmm(datapath, 'LF');
    [A2, B2] = foothmm(datapath, 'RF');
    [A3, B3] = foothmm(datapath, 'LB');
    [A4, B4] = foothmm(datapath, 'RB');
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
end