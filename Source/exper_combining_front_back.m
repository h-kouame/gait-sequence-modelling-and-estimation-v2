function [accuracies, logliks] = exper_combining_front_back(traindata, testdata)
    rng('shuffle', 'twister');    
    if nargin < 1
        %     get common training and test data
        proportion = 0.9; % Test data proportion
        [observ_seq, state_seq, feat_names] = get_all_data();
        [traindata, testdata] = splitdataset(observ_seq, state_seq, feat_names, proportion);
    end
    
%     build model with combined front and back measurements to predict
%     front
    front_combined_model = BuildGmmHMM(traindata.observ, traindata.state);

%     build model with just front measurements
    front_model = Just_Front_BuildGmmHMM(traindata);

% %     build model with combined front and back measurements to predict back
%     back_combined_model = BuildGmmHMM(traindata.observ, traindata.state);
% 
% %     build model with just front measurements
%     back_model = Just_Back_BuildGmmHMM(traindata, best_feat_num);

    meth_num = 2;
    accuracies = zeros(1, meth_num);
    logliks = zeros(1, meth_num);
    reduc_data = cell(1, meth_num);
    estimated_paths = zeros(size(testdata.state, 1), meth_num);

%     Perform predictions
    disp('Front Combined');
    [accuracies(1), estimated_paths(:, 1), logliks(:, 1)] = GmmHMMpredict( front_combined_model, testdata);
    disp('Front - Not combined');
    [accuracies(2), estimated_paths(:, 2), logliks(:, 2)] = Just_Front_GmmHMMpredict(front_model, testdata);

%   Plot the accuracy of the different runs
%     figure;
%     bar(accuracies);
%     figtitle = 'Effect of dimensionality reduction on prediction accuracy';
%     title(figtitle);
%     mod_labels = {'No reduction', 'PCA', 'LDA', 'SI Ranking', 'SI-forward'};
%     set(gca, 'xticklabel', mod_labels);
%     ylabel('Prediction accuracy (%)');
%     sample_size = size(traindata.observ, 1);
%     figtitle = strcat('Effect of dimensionality reduction on accuracy with ', sample_size);
%     figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
%     print(figpath, '-depsc');
%     
%     figure;
%     bar(logliks);
%     figtitle = 'Effect of dimensionality reduction on log-likelihood with ';
%     title(figtitle);
%     mod_labels = {'No reduction', 'PCA', 'LDA', 'SI Ranking', 'SI-forward'};
%     set(gca, 'xticklabel', mod_labels)
%     ylabel('Prediction accuracy (%)');
%     figtitle = strcat('Effect of dimensionality reduction on log-likelihood with ', sample_size);
%     figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
%     print(figpath, '-depsc');
end