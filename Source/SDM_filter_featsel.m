function [selected_observ_seq, out_feat_labels] = SDM_filter_featsel(data, num_feat_out) 
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        num_feat_out = 0;
    end

    rng(8000, 'twister');

    % Remove G with classification degree equal to 0 
    G = SDM(data);
    num_non_0_G = size( G(G~= 0), 2);
     % Sort features by separability degree 
    [~, featureIdxSortbySD] = sort(G, 2, 'descend'); % sort the features
    non_0_G_feat_idx = featureIdxSortbySD(1:num_non_0_G);
    non_0_G_observ = data.observ(:, non_0_G_feat_idx); 
    non_0_G_feat = data.feat(non_0_G_feat_idx); 
%     Up to now, dimension has been reduced to features with classification degree different from zero
    
%   Now, use forward feature selection
    SDM_reduc_data = data;
    SDM_reduc_data.observ = non_0_G_observ;
    SDM_reduc_data.feat = non_0_G_feat;
    [selected_observ_seq, out_feat_labels] = featselect(SDM_reduc_data, num_feat_out);  
end