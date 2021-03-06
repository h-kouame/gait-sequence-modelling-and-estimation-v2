function model = SDM_BuildGmmHMM(data)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
    end
    
%     selected_data = SDM_featsel(data, test_prop);  %use deterministic %     result below

    feat_out = {'magFront_cal'; 'magBack_cal'; 'magFront_cal3'; 'BackYaw'};
%     feat_out = {'magFront_cal'; 'magBack_cal'; 'magFront_cal3'};
    sel_observ = get_selected_features(data.observ, data.feat, feat_out);
    model = BuildGmmHMM(sel_observ, data.state);
end