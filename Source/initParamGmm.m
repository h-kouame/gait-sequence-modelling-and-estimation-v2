function [pi, A, B] = initParamGmm(observ_seq, state_seq)
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
    
%     state transition probabilities estimation
    PSEUDOTR = ones(state_num, state_num)*1;
    A = hmmestimate(state_seq, state_seq, 'PSEUDOTRANSITIONS',PSEUDOTR);
    
    feat_num = size(observ_seq, 2); %feature size
    %optimal mixture number
    mix_num = optimal_mixture_component(O3);
%     GMM optimisation parameters
    iter_num = 1;
    options = statset('Display','off','MaxIter',100,'TolFun',1e-5);
    
    covariance = zeros(feat_num, feat_num, mix_num, state_num);
    means = zeros(feat_num, mix_num, state_num);
    mix_prob = ones(mix_num, state_num)/mix_num; % equal probability of mixture m given a state k.
      
    if isempty(O1) 
        means(:,:, 1) = zeros(feat_num, mix_num);
        covariance(:, :, :, 1) = ones(feat_num, feat_num, mix_num)/2;
    else
        gmm1 = fitgmdist(O1, mix_num, 'Replicates',iter_num, 'Options',options);
        means(:, :, 1) = gmm1.mu.';
        covariance(:, :, :, 1) = gmm1.Sigma;
    end
    
    if isempty(O2) 
        means(:, :, 2) = zeros(feat_num, mix_num);
        covariance(:, :, :, 2) = ones(feat_num, feat_num, mix_num)/2;
    else
        gmm2 = fitgmdist(O2, mix_num, 'Replicates',iter_num, 'Options',options);
        means(:, :, 2) = gmm2.mu.';
        covariance(:, :, :, 2) = gmm2.Sigma;
    end
    
    if isempty(O3) 
        means(:, 3) = zeros(feat_num, mix_num);
        covariance(:, :, 3) = ones(feat_num, feat_num, mix_num)/2;
    else
        gmm3 = fitgmdist(O3, mix_num, 'Replicates',iter_num, 'Options',options);
        means(:, :, 3) = gmm3.mu.';
        covariance(:, :, :, 3) = gmm3.Sigma;
    end
    
    if isempty(O4) 
        means(:, :, 4) = zeros(feat_num, mix_num);
        covariance(:, :, :, 4) = ones(feat_num, feat_num, mix_num)/2;  
    else
        gmm4 = fitgmdist(O4, mix_num, 'Replicates',iter_num, 'Options',options);
        means(:, :, 4) = gmm4.mu.';
        covariance(:, :, :, 4) = gmm4.Sigma;  
    end
    
    B.mu = means;
    B.Sigma = covariance;
    B.B = mix_prob;
end