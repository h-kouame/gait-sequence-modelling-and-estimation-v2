function [p_start, A, phi, loglik] = footChmm(datapath, foot)
    if nargin < 1
        knnpath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\KNN\KNN.mat';
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';   
        foot = 'LF';
    elseif nargin < 2
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        foot = 'LF'; 
    elseif nargin < 3
        foot = 'LF';
    end
    
    delfigs;
    [observ_seq, states] = getseqs(datapath, foot); 
    data{1} = observ_seq(:, :);
    state_num = 2;
    [p_start, A, phi, loglik] = ChmmGauss(data, state_num);  
    
    logp_xn_given_zn = Gauss_logp_xn_given_zn(data{1}, phi);
    [~,~, loglik] = LogForwardBackward(logp_xn_given_zn, p_start, A);
    path = LogViterbiDecode(logp_xn_given_zn, p_start, A);
    
    state_seq = states + 1;
    accuracy = 100*mean(path == state_seq)
end
