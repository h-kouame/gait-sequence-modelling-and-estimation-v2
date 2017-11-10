function exper_motion_recognition(body_part)
    if nargin < 1
       body_part = 'front'; 
    end
    
    run_data = get_run_data(body_part);
    walk_data = get_walk_data(body_part);
    trot_data = get_trot_data(body_part);
    datas = {run_data, walk_data, trot_data};
    
    action_num = 3;
    traindata = cell(action_num);
    testdata = cell(action_num);
    test_proportion = 0.35;
    for i = 1:action_num
        [traindata{i}, testdata{i}] = splitdataset(datas{i}.observ, datas{i}.state, datas{i}.feat, test_proportion);
    end
    
    run_model = Run_BuildGmmHMM(traindata{1});
    walk_model = Walk_BuildGmmHMM(traindata{2});
    trot_model = Trot_BuildGmmHMM(traindata{3});
    models = {run_model, walk_model, trot_model};

    accuracies = zeros(action_num, action_num);
    logliks = zeros(action_num, action_num);
    paths = cell(action_num, action_num);
    for i = 1:action_num
        model = models{i};
        for j = 1:action_num
            [accuracies(i, j), paths{i}{j}, logliks(i, j)] = GmmHMMpredict(model, testdata{j});
        end
    end
    corr_coef_accuracies = corrcoef(accuracies);
    corr_coef_logliks = corrcoef(logliks);
    variable_path = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\Motion-Recogn\action-accuracies-logliks.mat';
    save(variable_path, 'accuracies', 'logliks', 'corr_coef_accuracies', 'corr_coef_logliks');
end