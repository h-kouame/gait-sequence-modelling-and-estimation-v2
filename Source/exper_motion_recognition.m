function exper_motion_recognition(body_part)
    if nargin < 1
       body_part = 'front'; 
    end
    
    run_data = get_run_data(body_part);
    walk_data = get_walk_data(body_part);
    trot_data = get_trot_data(body_part);
    datas = {run_data, walk_data, trot_data};
    
    run_model = Run_BuildGmmHMM(run_data);
    walk_model = Walk_BuildGmmHMM(walk_data);
    trot_model = Trot_BuildGmmHMM(trot_data);
    models = {run_model, walk_model, trot_model};

    action_num = 3;
    accuracies = zeros(action_num, action_num);
    logliks = zeros(action_num, action_num);
    for i = 1:action_num
        model = models{i};
        for j = 1:action_num
            testdata = datas{j};
            [accuracies(i, j), ~, logliks(i, j)] = GmmHMMpredict(model, testdata);
        end
    end
    corr_coef_accuracies = corrcoef(accuracies);
    corr_coef_logliks = corrcoef(logliks);
    variable_path = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\Motion-Recogn\accuracies-logliks.mat';
    save(variable_path, 'accuracies', 'logliks', 'corr_coef_accuracies', 'corr_coef_logliks');
end