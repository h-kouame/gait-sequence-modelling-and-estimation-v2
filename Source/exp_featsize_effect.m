function exp_featsize_effect(data)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
    end

    rng('shuffle','twister');

    % Sort features by separability degree 
    G = SDM(data);
    [~, featureIdxSortbySD] = sort(G, 2, 'descend'); % sort the features
    
    % Vary number of feature from 1 to num of features
    feat_num = size(data.observ, 2);
    nfs = 1:1:feat_num;

    accuracies = zeros(1, feat_num);
    logliks = zeros(1, feat_num);
    testprop = 0.2;
    [traindata, testdata] = splitdataset(data.observ, data.state, feat_names, testprop);
    for i = 1:feat_num
       fs = featureIdxSortbySD(1:nfs(i));
       [model.pi, model.A, model.phi] = BuildGmmHMM(traindata.observ(:, fs), traindata.state);
       tempdata = testdata;
       tempdata.observ = testdata.observ(:, fs);
       [accuracies(i), ~ , logliks(i)] = GmmHMMpredict(model, tempdata);
    end
    
    figure;
    plot(1:feat_num, accuracies, 'LineWidth',2, 'MarkerSize',10);
%     legend({'Sequence recognition accuracy'}, 'Location','SE');
    xlabel('Number of features');
    ylabel('Percentage (%) accuracy');
    figtitle = 'Effect of feature size on model accuracy';
    title(figtitle);
    figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
    print(figpath, '-depsc');
    
    figure;
    plot(1:feat_num, logliks, 'LineWidth',2, 'MarkerSize',10);
%     legend({'Sequence log-likelihood'}, 'Location','NE');
    xlabel('Number of features');
    ylabel('Log-likelihood');
    figtitle = 'Effect of feature size on log-likelihood';
    title(figtitle);
    figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
    print(figpath, '-depsc');
end