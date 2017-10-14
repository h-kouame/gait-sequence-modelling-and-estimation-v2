function [pdfs, means, covariances] = getpdfs(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat'; 
    end
    
    dataset = preprocess(datapath);
    N = classsizes(dataset);
    M = dataset.featsize; %number of features
    S = length(N);  %number of states
    means = zeros(S, M);
    covariances = zeros(S, M, M);
    pdfs = {};
    O = +dataset; %observations
    start = 1;
    stop = 0;
    for i = 1:S
        stop = stop + N(i);
        O_i = O(start:stop,:);
        mu = mean(O_i, 1);
        sigma = cov(O_i);
        pdf = mvnpdf(O_i, mu);
        start = stop + 1;
        means(i, :) = mu;
        covariances(i, :, :) = sigma;
        pdfs = [pdfs, pdf];
    end  
end