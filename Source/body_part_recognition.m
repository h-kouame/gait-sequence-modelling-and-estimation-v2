function body_part_recognition()

    front_run_data = get_run_data('front');
    front_walk_data = get_walk_data('front');
    front_trot_data = get_trot_data('front');
    front_datas = {front_run_data, front_walk_data, front_trot_data};
    
    back_walk_data = get_walk_data('back');
    back_run_data = get_run_data('back');
    back_trot_data = get_trot_data('back');
    back_datas = {back_run_data, back_walk_data, back_trot_data};
    
    datas = {front_datas, back_datas};
    
    front_run_model = Run_BuildGmmHMM(front_run_data);
    front_walk_model = Walk_BuildGmmHMM(front_walk_data);
    front_trot_model = Trot_BuildGmmHMM(front_trot_data);
    front_models = {front_run_model, front_walk_model, front_trot_model};
    
    back_run_model = Run_BuildGmmHMM(back_run_data);
    back_walk_model = Walk_BuildGmmHMM(back_walk_data);
    back_trot_model = Trot_BuildGmmHMM(back_trot_data);
    back_models = {back_run_model, back_walk_model, back_trot_model};
    
    models = {front_models, back_models};

    body_part_num = 2;
    action_num = 3;
    accuracies = zeros(body_part_num, body_part_num, action_num);
    logliks = zeros(body_part_num, body_part_num, action_num);
    for action = 1:action_num  
        for body_part_model = 1:body_part_num  
            model = models{body_part_model}{action};
            for body_part_testdata = 1:body_part_num 
                testdata = datas{body_part_testdata}{action};
                [accuracies(body_part_model, body_part_testdata, action), ~, ...
                 logliks(body_part_model, body_part_testdata, action)] = GmmHMMpredict(model, testdata);
            end
        end
    end
    corr_coef_accuracies = zeros(body_part_num, body_part_num, action_num);
    corr_coef_logliks = zeros(body_part_num, body_part_num, action_num);
    for i = 1:action_num
        corr_coef_accuracies(:,:,i) = corrcoef(accuracies(:,:,i));
        corr_coef_logliks(:,:,i) = corrcoef(logliks(:,:,i));
    end
    variable_path = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\Motion-Recogn\body-part-accuracies-logliks.mat';
    save(variable_path, 'accuracies', 'logliks', 'corr_coef_accuracies', 'corr_coef_logliks');
end