function model = KNN_BuildGmmHMM(data)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
    end
%     best_feat_num = 4; use experiment
%     [selected_observ, feat_out] = featselect(data, best_feat_num); %     result below
    
    feat_out = {'FrontYaw'; 'BackPitch'; 'BackRoll'; 'BackYaw'};
    sel_observ = get_selected_features(data.observ, data.feat, feat_out);
    [pi, A, phi] = BuildGmmHMM(sel_observ, data.state);
    model.pi = pi; model.A = A; model.phi = phi;
end