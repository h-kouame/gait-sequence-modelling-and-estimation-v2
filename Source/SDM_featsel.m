function selected_data = SDM_featsel(data, test_prop) 
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        test_prop = 0.2;
    end

    rng(8000, 'twister');

    % Sort features by separability degree 
    G = SDM(data);
    [~, featureIdxSortbySD] = sort(G, 2, 'descend'); % sort the features
    
    % Vary number of feature from 1 to num of features
    feat_num = size(data.observ, 2);
    nfs = 1:1:feat_num;

    testMCE = zeros(1, 14);
    trainMCE = zeros(1,14);
    for i = 1:18
       fs = featureIdxSortbySD(1:nfs(i));
       [testMCE(i), trainMCE(i)] = CKNN(make_data(observ_seq(:, fs), state_seq, feat_names(fs,:)), 1 - test_prop);
    end
    [min_MCE, min_best_feat_num] = min(testMCE);
    min_MCE 
    min_best_feat_num
    fs = featureIdxSortbySD(1:nfs(min_best_feat_num));
    selected_data.observ = observ_seq(:, fs);
    selected_data.state = data.state;
    selected_data.feat = feat_names(fs,:);
end