function selected_obs = get_selected_features(obs, feat_in, feat_out)
    selected_obs = zeros(size(obs, 1), size(feat_out, 1)); 
    obs_idx = 1;
    for i = 1:size(feat_in, 1)
        feat_name = feat_in(i);
        if ismember(feat_name, feat_out)
            selected_obs(:, obs_idx) = obs(:, i);
            obs_idx = obs_idx + 1;
        end
    end 
end