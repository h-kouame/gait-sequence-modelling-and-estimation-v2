function outdata = get_relevant_feats(indata)
    G = SDM(indata);
    num_non_0_G = size( G(G~= 0), 2);
     % Sort features by separability degree 
    [~, featureIdxSortbySD] = sort(G, 2, 'descend'); % sort the features
    non_0_G_feat_idx = featureIdxSortbySD(1:num_non_0_G);
    non_0_G_observ = indata.observ(:, non_0_G_feat_idx); 
    non_0_G_feat = indata.feat(non_0_G_feat_idx); 
    
    outdata.observ = non_0_G_observ;
    outdata.feat = non_0_G_feat;
    outdata.state = indata.state;
end