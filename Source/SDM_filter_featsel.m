function [selected_observ_seq, out_feat_labels] = SDM_filter_featsel(data, num_feat_out) 
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        num_feat_out = 4;
    end

    rng('shuffle','twister');

%     Remove G with classification degree equal to 0 
    rel_data = get_relevant_feats(data);
    
%      Up to now, dimension has been reduced to features with classification degree different from zero
    
%   Now, use forward feature selection
    [selected_observ_seq, out_feat_labels] = featselect(rel_data, num_feat_out);  
end