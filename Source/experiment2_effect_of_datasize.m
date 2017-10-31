% Effect of training data size on performance

rng('shuffle','twister');

% Get dataset
proportion = 0.2;
body_part = 'front';
best_feat_num = 4; %experiment_optimal_number_of_features;
[observ_seq, state_seq, feat_names] = get_all_data(body_part);

% Have multiple runs of both methods
test_prop = 9;
accuracies = zeros(3, test_prop - 1);
logliks = zeros(3, test_prop - 1);
% For each run, 
for i = test_prop:-1:1
    testdata_proportion = i/10;
    [traindata, testdata] = splitdataset(observ_seq, state_seq, feat_names, testdata_proportion);
   
    %build model without dimensionality reduction
    disp('No reduction');
    [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
    no_reduc_model.A = A;
    no_reduc_model.phi = phi;
    no_reduc_model.pi = pi;
    [accuracies(1, i), ~, logliks(1, i)] = GmmHMMpredict(no_reduc_model, testdata);
   
    %Build model with dimensionality reduction
    disp('Forward Feature selection with knn');
    filter_model = KNN_BuildGmmHMM(traindata);
    [accuracies(2, i), ~, logliks(2, i)] = KNN_GmmHMMpredict(filter_model, testdata);
    
    %Build model with dimensionality reduction
    disp('Feature selection with SDM');
    SDM_model = SDM_BuildGmmHMM(traindata);
    [accuracies(3, i), ~, logliks(3, i)] = SDM_GmmHMMpredict(SDM_model, testdata);
end
N = size(observ_seq, 1);
incr = 0.1*N;
x_axis = 0.1*N:incr:0.9*N;
% Plot effect of datasize
figure;
plot(x_axis, fliplr(accuracies(1,:))); hold on;
plot(x_axis, fliplr(accuracies(2,:)));
plot(x_axis, fliplr(accuracies(3,:)));
figtitle = 'Effect on data size on accuracy';
title(figtitle);
xlabel('Training data size');
ylabel('HMM model accuracy');
legend({'No reduction', 'Feature selection with KNN', 'Feature selection with SDM'}, 'Location', 'NW');

figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');

% Plot effect of datasize
figure;
plot(x_axis, fliplr(logliks(1,:))); hold on;
plot(x_axis, fliplr(logliks(2,:))); hold on;
plot(x_axis, fliplr(logliks(3,:)));
figtitle = 'Effect on data size on log-likelihood';
title(figtitle);
xlabel('Training data proportion');
ylabel('LogLikelihood');
legend({'No reduction', 'Feature selection with KNN', 'Feature selection with SDM'}, 'Location', 'NW');
figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');