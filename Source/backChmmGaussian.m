function [p_start, A, phi, loglik] = backChmmGaussian(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';   
    end
    
    delfigs;
    
    [observ_seq, state_seq] = get_all_data('back');
    data{1} = observ_seq(: , :);
    state_num = 4;
    iter_num = 100;
    
    [p_start, A, phi] = initParamGaussian(observ_seq, state_seq);
    [p_start, A, phi, loglik] = ChmmGauss(data, state_num, 'p_start0', p_start, 'A0', A, 'phi0', phi, 'cov_type', 'diag', 'cov_thresh', 1e-2);
    
%     testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';    
%     [test_observ_seq, test_state_seq] = getfrontdata(testdatapath);
%     
%     test_data{1} = test_observ_seq; 
    
    logp_xn_given_zn = Gauss_logp_xn_given_zn(flipud(data{1}), phi);
    [~,~, loglik] = LogForwardBackward(logp_xn_given_zn, p_start, A);
    path = LogViterbiDecode(logp_xn_given_zn, p_start, A);
    
    accuracy = 100*mean(path == state_seq)
    loglik
end
    