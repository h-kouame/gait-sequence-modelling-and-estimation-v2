function model = SDM_filter_BuildGmmHMM(data)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
    end
%     best_feat_num = 4; use experiment
%     [selected_observ, feat_out] = sdm_filterselect(data, best_feat_num); %     result below
    
        feat_out = {'magFront_cal'; 'magBack_cal'; 'magFront_cal3'; 'FrontYaw'};
    sel_observ = get_selected_features(data.observ, data.feat, feat_out);
    model = BuildGmmHMM(sel_observ, data.state);
end