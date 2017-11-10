% Effect of training data size on performance
rng('shuffle','twister');

% Get dataset
body_part = 'front';
best_feat_num = 4; %experiment_optimal_number_of_features;
[observ_seq, state_seq, feat_names] = get_all_data(body_part);

test_prop = 9; %Number of runs
meth_num = 2;
accuracies = zeros(test_prop, meth_num);
logliks = zeros(test_prop, meth_num);
% For each run, 
for i = test_prop:-1:1
    testdata_proportion = i/10;
    [traindata, testdata] = splitdataset(observ_seq, state_seq, feat_names, testdata_proportion);
    [accuracies(i, :), logliks(i,:)] = exper_combining_front_back(traindata, testdata, body_part);  
end
N = size(observ_seq, 1);
incr = 0.1*N;
x_axis = 0.1*N:incr:0.9*N;
% Plot effect of datasize
figure;
plot(x_axis, flipud(accuracies(:,1)), 'LineWidth',2, 'MarkerSize',10); hold on;
plot(x_axis, flipud(accuracies(:,2)), 'LineWidth',2, 'MarkerSize',10); hold on;
figtitle = 'Accuracy with both IMUs vs. with front IMU';
title(figtitle);
xlabel('Training data size');
ylabel('Prediction accuracy (%)');
legend({'front and back measurements', 'Just front measurements'}, 'Location', 'NW');

figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');

% Plot effect of datasize
figure;
plot(x_axis, flipud(logliks(:,1)), 'LineWidth',2, 'MarkerSize',10); hold on;
plot(x_axis, flipud(logliks(:,2)), 'LineWidth',2, 'MarkerSize',10); hold on;
figtitle = 'Log-likehood with both IMUs vs. with front IMU';
title(figtitle);
xlabel('Training data size');
ylabel('Log-Likelihood');
legend({'front and back measurements', 'Just front measurements'}, 'Location', 'SE');
figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');