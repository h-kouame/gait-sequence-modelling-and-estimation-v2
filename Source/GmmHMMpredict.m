function [accuracy, path, loglik] = GmmHMMpredict(model, testdata)
    if nargin < 1
        [model.pi, model.A, model.phi] = BuildGmmHMM();
        [observ_seq, state_seq, feat_names] = get_all_data();
        testdata = make_data(observ_seq, state_seq, feat_names);
    end
        
    %Build HMM
    p_start = model.pi;
    A = model.A;
    phi = model.phi;

    logp_xn_given_zn = Gmm_logp_xn_given_zn(testdata.observ, phi);
    %
    [~,~, loglik] = LogForwardBackward(logp_xn_given_zn, p_start, A);
    [path, post] = LogViterbiDecode(logp_xn_given_zn, p_start, A);
    
    accuracy = evaluate(testdata.state, path)
    loglik
end