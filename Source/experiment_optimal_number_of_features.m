% Investigate best feature number for filters
function experiment_optimal_number_of_features(body_part, test_prop)
    if nargin < 1
        body_part = 'front';
        test_prop = 0.1;
    end

    rng(8000,'twister');

    % Sort features by separability degree 
    [observ_seq, state_seq] = get_all_data(body_part);
    G = SDM(make_data(observ_seq, state_seq, feat_names));
    [~, featureIdxSortbySD] = sort(G, 2, 'descend'); % sort the features
    
    % Vary number of feature from 1 to 18
    nfs = 1:1:18;

    varianceMCE = zeros(1,14);
    biasMCE = zeros(1,14);
    for i = 1:18
       fs = featureIdxSortbySD(1:nfs(i));
       [varianceMCE(i), biasMCE(i)] = CKNN(make_data(observ_seq(:, fs), state_seq, feat_names), 1 - test_prop);
    end

     plot(nfs, 100*varianceMCE, nfs, 100*biasMCE);
     xlabel('Number of Features');
     ylabel('Percentage MCE (%)'); 
     figtitle = 'Misclassification Error (MCE) vs Number of Features';
     title(figtitle);
     legend({'MCE on the new data set' 'MCE on training data set'},'location', 'NE');

     figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
     print(figpath, '-depsc');
end