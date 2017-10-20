function [p_start, A, phi, loglik] = backChmm(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';   
    end
    
    delfigs;
    
    [observ_seq, state_seq] = getbackdata(datapath);
    data{1} = observ_seq;
    state_num = 4;
    [p_start, A, phi] = initParam(observ_seq, state_seq);
    [p_start, A, phi, loglik] = ChmmGauss(data, state_num, 'p_start', p_start, 'A', A, 'phi', phi, 'cov_type', 'full' , 'cov_thresh', 1e-1);
   
    %evaluate
    testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';    
    [test_observ_seq, test_state_seq] = getbackdata(testdatapath);
    test_data{1} = test_observ_seq; 
    logp_xn_given_zn = Gauss_logp_xn_given_zn(test_data{1}, phi);
    [~,~, loglik] = LogForwardBackward(logp_xn_given_zn, p_start, A);
    path = LogViterbiDecode(logp_xn_given_zn, p_start, A);
    
    accuracy = 100*mean(path == test_state_seq)
end