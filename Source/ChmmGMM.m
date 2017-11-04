function [p_start, A, phi, loglik] = ChmmGMM(body_part)
    if nargin < 1
        body_part = 'front';  
    end
    
    delfigs;
    
%     get sequence of data
    chosen_feat_dim = 0; % 0 to select the optimal feature subset
%     [observ_seq, state_seq] = featselect(body_part, chosen_feat_dim);
    [observ_seq, state_seq] = get_all_data(body_part);
%     observ_seq = [observ_seq(:, 3), observ_seq(:, 5), observ_seq(:, 6), observ_seq(:, 9), observ_seq(:, 13),...
%         observ_seq(:, 14), observ_seq(:, 15), observ_seq(:, 16), observ_seq(:, 18)];
%     observ_seq = [observ_seq(:, 15), observ_seq(:, 18)];
    data{1} = observ_seq(: , :);
%     iter_num = 1000;
    
%     estimate initial parameters based on data
    model = BuildGmmHMM(observ_seq, state_seq);
%     mu = phi.mu;
%     state_num = size(mu, 3);
%     mixture_num = size(mu, 2);
%     
%     apply EM algorithm
%     [p_start1, A1, phi1, loglik] = ChmmGmm(data, state_num, mixture_num, 'p_start0', p_start, 'A0', A, 'phi0', phi, 'iter_num', iter_num, 'cov_type', 'diag', 'cov_thresh', 1e-4);
    
    
    logp_xn_given_zn = Gmm_logp_xn_given_zn(data{1}, model.phi);
    [~,~, loglik] = LogForwardBackward(logp_xn_given_zn, model.pi, model.A);
    path = LogViterbiDecode(logp_xn_given_zn, model.pi, model.A);
    
    accuracy = evaluate(state_seq, path)
    loglik
end
    