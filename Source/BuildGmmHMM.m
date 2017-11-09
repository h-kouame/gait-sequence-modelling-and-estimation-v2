function model = BuildGmmHMM(observ_seq, state_seq)
    if nargin < 1
        [observ_seq, state_seq] = get_all_data('front');  
    end
    
    %delfigs;
    
    O = getstatesdata(observ_seq, state_seq);
    O1 = O{1};
    O2 = O{2};
    O3 = O{3};
    O4 = O{4};
    
    C = 1;
    state_distr = [size(O1, 1) size(O2, 1) size(O3, 1) size(O4, 1)] + C; 
    model.pi = state_distr/(C + size(observ_seq, 1));
    
    state_num = 4;
    
%     state transition probabilities estimation
    PSEUDOTR = ones(state_num, state_num)*1 + state_distr;
    model.A = hmmestimate(state_seq, state_seq, 'PSEUDOTRANSITIONS',PSEUDOTR);
    
    feat_num = size(observ_seq, 2); %feature size
    %optimal mixture number
    data.observ = observ_seq;
    data.state = state_seq;
    mix_num = optimal_mixture_component(data); %optimal_mixture_component(O3, feat_num);
%     GMM optimisation parameters
    iter_num = 10;
    options = statset('Display','off', 'MaxIter',1000, 'TolFun',1e-10);
%     Do not restrict covariance matrices to be the same
    sharedCov = false;
    
    covariance = zeros(feat_num, feat_num, mix_num, state_num);
    means = zeros(feat_num, mix_num, state_num);
    mix_prob = zeros(mix_num, state_num); %probability of mixture m given a state k.
    regularization = 1e-10;
%     ProbabilityTolerance for posterior probabilities not larger than zero
%     Used default ProbabilityTolerance = 1e-8; 
    rng('shuffle', 'twister');
    if isempty(O1) 
        O1 = (-10 + (10+10))*rand(mix_num + C, feat_num);
    end
    gmm1 = fitgmdist(O1, mix_num, 'Replicates',iter_num, 'Options',options, 'SharedCovariance',sharedCov, 'Regularize', regularization);
    means(:, :, 1) = gmm1.mu.';
    covariance(:, :, :, 1) = gmm1.Sigma;
    mix_prob(:, 1) = gmm1.ComponentProportion;
    
    if isempty(O2) 
        O2 = (-10 + (10+10))*rand(mix_num + C, feat_num);
    end
    gmm2 = fitgmdist(O2, mix_num, 'Replicates',iter_num, 'Options',options, 'SharedCovariance',sharedCov, 'Regularize', regularization);
    means(:, :, 2) = gmm2.mu.';
    covariance(:, :, :, 2) = gmm2.Sigma;
    mix_prob(:, 2) = gmm2.ComponentProportion;
    
    if isempty(O3) 
        O3 = (-10 + (10+10))*rand(mix_num + C, feat_num);
    end
    gmm3 = fitgmdist(O3, mix_num, 'Replicates',iter_num, 'Options',options, 'SharedCovariance',sharedCov, 'Regularize', regularization);
    means(:, :, 3) = gmm3.mu.';
    covariance(:, :, :, 3) = gmm3.Sigma;
    mix_prob(:, 3) = gmm3.ComponentProportion;
    
    if isempty(O4) 
        O4 = (-10 + (10+10))*rand(mix_num + C, feat_num); 
    end
    gmm4 = fitgmdist(O4, mix_num, 'Replicates',iter_num, 'Options',options, 'SharedCovariance',sharedCov, 'Regularize', regularization);
    means(:, :, 4) = gmm4.mu.';
    covariance(:, :, :, 4) = gmm4.Sigma; 
    mix_prob(:, 4) = gmm4.ComponentProportion;
    
    B.mu = means;
    B.Sigma = covariance;
    B.B = mix_prob;
    model.phi = B;
end