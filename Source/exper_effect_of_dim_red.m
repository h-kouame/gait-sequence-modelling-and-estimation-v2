function [accuracies, logliks] = exper_effect_of_dim_red(traindata, testdata)
    rng('shuffle', 'twister');    
    if nargin < 1
        %     get common training and test data
        proportion = 0.9; % Test data proportion
        [observ_seq, state_seq, feat_names] = get_all_data();
        [traindata, testdata] = splitdataset(observ_seq, state_seq, feat_names, proportion);
    end

    best_feat_num = 4; %experiment_optimal_number_of_features;
    
%     build model without dimensionality reduction
    [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
    no_reduc_model.A = A;
    no_reduc_model.phi = phi;
    no_reduc_model.pi = pi;

%     build model with PCA
    pca_model = PCA_BuildGmmHMM(traindata, best_feat_num);

%     Build model with LDA
    lda_model = LDA_BuildGmmHMM(traindata, best_feat_num - 1);

%     Build model with Filter methods: NN, SIM
    sdm_model = SDM_BuildGmmHMM(traindata); %SDM
    for_filter_model = SDM_filter_BuildGmmHMM(traindata); %SDM and forward selection

    meth_num = 5;
    accuracies = zeros(1, meth_num);
    logliks = zeros(1, meth_num);
    reduc_data = cell(1, meth_num);
    estimated_paths = zeros(size(testdata.state, 1), meth_num);

%     Perform predictions
    disp('No reduction');
    [accuracies(1), estimated_paths(:, 1), logliks(:, 1)] = GmmHMMpredict(no_reduc_model, testdata);
    disp('PCA');
    [accuracies(2), estimated_paths(:, 2), logliks(:, 2)] = PCA_GmmHMMpredict(pca_model, testdata, best_feat_num);
    disp('LDA');
    [accuracies(3), estimated_paths(:, 3), logliks(:, 3)] = LDA_GmmHMMpredict(lda_model, testdata, best_feat_num - 1);
    disp('SDM');
    [accuracies(4), estimated_paths(:, 4), logliks(:, 4)] = SDM_GmmHMMpredict(sdm_model, testdata);
    disp('Forward feature selection');
    [accuracies(5), estimated_paths(:, 5), logliks(:, 5)] = SDM_filter_GmmHMMpredict(for_filter_model, testdata);

%   Plot the accuracy of the different runs
    figure;
    bar(accuracies);
    figtitle = 'Effect of dimensionality reduction on prediction accuracy';
    title(figtitle);
    mod_labels = {'No reduction', 'LCA', 'LDA', 'SI Ranking', 'SI-forward'};
    set(gca, 'xticklabel', mod_labels)
    ylabel('Prediction accuracy (%)');
    
    figure;
    bar(logliks);
    figtitle = 'Effect of dimensionality reduction on log-likelihood';
    title(figtitle);
    mod_labels = {'No reduction', 'PCA', 'LDA', 'SI Ranking', 'SI-forward'};
    set(gca, 'xticklabel', mod_labels)
    ylabel('Prediction accuracy (%)');
    figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
    print(figpath, '-depsc');
end

% function red_scatter()
% 
% end