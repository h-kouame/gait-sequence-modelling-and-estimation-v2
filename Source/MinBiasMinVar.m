function MinBiasMinVar(data, run_num, train_prop)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        run_num = 100;
        train_prop = 0.1;
    end
    
    obs = data.observ;
    states = data.state;
    feat_names = data.feat;
    
    num_models = 5;
    accuracies = zeros(num_models, run_num);
    logliks = zeros(num_models, run_num);
    test_acc = zeros(num_models, run_num);
    test_loglik = zeros(num_models, run_num);
    for i = 1:run_num 
        [traindata, testdata] = splitdataset(obs, states, feat_names, 1 - train_prop);
        traindata.feat = feat_names; testdata.feat = feat_names;
        
        [accuracies(:, i), logliks(:, i)] = exper_effect_of_dim_red(traindata, traindata); % test with training data to estimate bias
        [test_acc(:, i), test_loglik(:, i)] = exper_effect_of_dim_red(traindata, testdata);
    end
    
    errors = 1 - accuracies./100;
    bias_err = mean(errors, 2);
    var_err = var(errors, 1, 2); % Use normalization N not default N - 1
    
    bias_var_err = bias_err + var_err;

    test_errs = 1 - test_acc./100;
    test_err = mean(test_errs, 2);
    
    figure;
    plot(bias_err.', 'x', ...
         var_err.', 'o', ...
         bias_var_err.', 's',...
         test_err.', 'd');
    legend({'Bias error', 'Variance error', 'Bias + Var Error ', 'Test error'}, 'Location','NE');
    xlabel('CHMM model');
    mod_labels = {'No reduction', 'PCA', 'LDA', 'SI Ranking', 'SI-forward'};
    set(gca, 'xticklabel', mod_labels)
    ylabel('Prediction Error');
    figtitle = 'Bias - variance tradeoff';
    title(figtitle);
end