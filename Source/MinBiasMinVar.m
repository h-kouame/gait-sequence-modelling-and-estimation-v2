function MinBiasMinVar(data, run_num, train_prop)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        run_num = 100;
        train_prop = 0.5;
    end
    
    obs = data.observ;
    states = data.state;
    
    num_models = 3;
    accuracies = zeros(num_models, run_num);
    logliks = zeros(num_models, run_num);
    test_acc = zeros(num_models, run_num);
    test_loglik = zeros(num_models, run_num);
    for i = 1:run_num 
        [traindata, testdata] = splitdataset(obs, states, 1 - train_prop);
        traindata.feat = feat_names; testdata.feat = feat_names;
        
%         No reduction
        [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
        model.A = A; model.pi = pi; model.phi = phi;
        [accuracies(1, i), ~, logliks(1, i)] = GmmHMMpredict(model, traindata); % test with training data to estimate bias
        [test_acc(1, i), ~, test_loglik(1, i)] = GmmHMMpredict(model, testdata);
        
%         Reduc with SDM
        SDM_model = SDM_BuildGmmHMM(traindata);
        [accuracies(2, i), ~, logliks(2, i)] = SDM_GmmHMMpredict(SDM_model, traindata); % test with training data to estimate bias
        [test_acc(2, i), ~, test_loglik(2, i)] = SDM_GmmHMMpredict(SDM_model, testdata);
        
%         Reduc with KNN
        KNN_model = KNN_BuildGmmHMM(traindata);
        [accuracies(3, i), ~, logliks(3, i)] = KNN_GmmHMMpredict(KNN_model, traindata); % test with training data to estimate bias
        [test_acc(3, i), ~, test_loglik(3, i)] = KNN_GmmHMMpredict(KNN_model, testdata);
    end
    
    errors = 1 - accuracies./100;
    bias_err = mean(errors, 2);
    var_err = var(errors, 1, 2); % Use normalization N not default N - 1
    
    bias_var_err = bias_err + var_err;

    test_errs = 1 - test_acc./100;
    test_err = mean(test_errs, 2);
    
    figure;
    plot([1, 2, 3], bias_err.', 'x', ...
         [1, 2, 3], var_err.', 'o', ...
         [1, 2, 3], bias_var_err.', 's',...
         [1, 2, 3], test_err.', 'd', ...
         'LineWidth',2, 'MarkerSize',10);
    legend({'Bias error', 'Variance error', 'Bias + Var Error ', 'Test error'}, 'Location','NE');
    xlabel('Sample');
    ylabel('Percentage ');
    figtitle = 'Bias - variance tradeoff';
    title(figtitle);
end