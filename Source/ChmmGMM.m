function [p_start, A, phi, loglik] = ChmmGMM(body_part)
    if nargin < 1
        body_part = 'front';  
    end
    
    delfigs;
    
%     get sequence of data
    if strcmp(body_part, 'front')
        [observ_seq, state_seq] = get_all_frontdata();
    else
        [observ_seq, state_seq] = get_all_backdata();
    end
    
    data{1} = observ_seq(: , :);
    iter_num = 100;
    
%     estimate initial parameters based on data
    [p_start, A, phi] = initParamGmm(observ_seq, state_seq);
    mu = phi.mu;
    state_num = size(mu, 3);
    mixture_num = size(mu, 2);
    
%     apply EM algorithm
    [p_start, A, phi, loglik] = ChmmGmm(data, state_num, mixture_num, 'p_start0', p_start, 'A0', A, 'phi0', phi, 'iter_num', iter_num, 'cov_type', 'diag', 'cov_thresh', 1e-2);
    
    logp_xn_given_zn = Gmm_logp_xn_given_zn(flipud(data{1}), phi);
    [~,~, loglik] = LogForwardBackward(logp_xn_given_zn, p_start, A);
    path = LogViterbiDecode(logp_xn_given_zn, p_start, A);
    
    accuracy = 100*mean(path == state_seq)
    loglik
end
    