function MinBiasMinVar(data, run_num, train_prop)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        run_num = 10;
        train_prop = 0.5;
    end
    
    obs = data.observ;
    states = data.state;
    

    accuracies = zeros(3, run_num);
    logliks = zeros(3, run_num);
    
    test_acc = zeros(3, run_num);
    test_loglik = zeros(3, run_num);
    for i = 1:run_num 
        [traindata, testdata] = splitdataset(obs, states, 1 - train_prop);
        
%         No reduction
        [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
        model.A = A; model.pi = pi; model.phi = phi;
        [accuracies(1, i), ~, logliks(1, i)] = GmmHMMpredict(model, traindata); % test with training data to estimate bias
        [test_acc(1, i), ~, test_loglik(1, i)] = GmmHMMpredict(model, testdata);
        
%         Reduc with SDM
        SDM_model = SDM_BuildGmmHMM(traindata.observ, traindata.state);
        [accuracies(2, i), ~, logliks(2, i)] = SDM_GmmHMMpredict(SDM_model, traindata); % test with training data to estimate bias
        [test_acc(2, i), ~, test_loglik(2, i)] = SDM_GmmHMMpredict(SDM_model, testdata);
        
%         Reduc with SDM
        KNN_model = KNN_BuildGmmHMM(traindata.observ, traindata.state);
        [accuracies(3, i), ~, logliks(3, i)] = KNN_GmmHMMpredict(KNN_model, traindata); % test with training data to estimate bias
        [test_acc(3, i), ~, test_loglik(3, i)] = KNN_GmmHMMpredict(KNN_model, testdata);
    end
    
    errors = 1 - accuracies./100;
    bias_err = mean(errors, 2);
    var_err = var(errors, 1, 2); % Use normalization N not default N - 1
    
    bias_var_err = bias + var_err;

    test_errs = 1 - accuracies./100;
    test_err = mean(test_errs);
    
    figure;
    
    plot(1:run_num, bias_err, 1:run_num, var_err, 1:run_num, bias_var_err, 1:run_num, test_err);
    legend({'Bias error', 'Variance error', 'Bias + Var Error ', 'Test error'}, 'Location','NE');
    xlabel('Sample');
    ylabel('Percentage ');
    figtitle = 'Bias - variance tradeoff';
    title(figtitle);
end