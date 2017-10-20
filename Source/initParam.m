function [pi, A, B] = initParam(observ_seq, state_seq)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        [observ_seq, state_seq] = getfrontdata(datapath);   
    end
    
    O1 = [];
    O2 = [];
    O3 = [];
    O4 = [];
    for i = 1:length(state_seq)
        state = state_seq(i);
        observ = observ_seq(i, :);
        switch state
            case 1
                O1 = [O1; observ];
            case 2
                O2 = [O2; observ];
            case 3
                O3 = [O3; observ];
            case 4
                O4 = [O4; observ];
        end
    end
    
    pi = [size(O1, 1) size(O2, 1) size(O3, 1) size(O4, 1)]/size(observ_seq, 1); 
    state_num = 4;
    PSEUDOTR = ones(state_num, state_num)*1;
    A = hmmestimate(state_seq, state_seq, 'PSEUDOTRANSITIONS',PSEUDOTR);
    feat_num = size(observ_seq, 2);

    covariance = zeros(feat_num, feat_num, state_num);
    means = zeros(feat_num, state_num);
    
    if isempty(O1) 
        means(:, 1) = zeros(feat_num, 1);
        covariance(:, :, 1) = ones(feat_num, feat_num)/2;
    else
        means(:, 1) = mean(O1);
        covariance(:, :, 1) = cov(O1);
    end
    
    if isempty(O2) 
        means(:, 2) = zeros(feat_num, 1);
        covariance(:, :, 2) = ones(feat_num, feat_num)/2;
    else
        means(:, 2) = mean(O2);
        covariance(:, :, 2) = cov(O2);
    end
    
    if isempty(O3) 
        means(:, 3) = zeros(feat_num, 1);
        covariance(:, :, 3) = ones(feat_num, feat_num)/2;
    else
        means(:, 3) = mean(O3);
        covariance(:, :, 3) = cov(O3);
    end
    
    if isempty(O4) 
        means(:, 4) = zeros(feat_num, 1);
        covariance(:, :, 4) = ones(feat_num, feat_num)/2;  
    else
        means(:, 4) = mean(O4);
        covariance(:, :, 4) = cov(O4);  
    end
    
    B.mu = means;
    B.Sigma = covariance;
end