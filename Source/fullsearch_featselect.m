function outdata = fullsearch_featselect(indata)
    if nargin < 1
        [indata.observ, indata.state, indata.feat] = get_all_data('front');
    end
    
    rel_data = get_relevant_feats(indata);
    rel_feat_num = size(rel_data.observ, 2);
    optimal_feat_num = 4;
    comb_feat_idx = combnk(1:rel_feat_num, optimal_feat_num);
    num_comb = size(comb_feat_idx, 1);
    accs = zeros(1, num_comb);
    logliks = zeros(1, num_comb);
    trainprop = 0.9; 
    
    [traindata, testdata] = splitdataset(rel_data.observ, rel_data.state, rel_data.feat, 1 - trainprop);
    for i = 1:num_comb
        feat_idx = comb_feat_idx(i, :);
        observ = traindata.observ(:, feat_idx);
        temptest = testdata;
        temptest.observ = testdata.observ(:, feat_idx);
        model = BuildGmmHMM(observ, traindata.state);
        [accs(i), ~ , logliks(i)] = GmmHMMpredict(model, temptest);
    end
    
    [best_acc, best_idx] = max(accs)
    best_feats_idx = comb_feat_idx(best_idx, :);
    outdata.observ = rel_data.observ(:, best_feats_idx);
    best_feats = rel_data.feat(best_feats_idx)
    outdata.feat = best_feats;
    outdata.state = rel_data.state;
    
end