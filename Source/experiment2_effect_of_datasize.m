% Effect of training data size on performance

rng(8000,'twister');

% Get dataset
proportion = 0.2;
body_part = 'front';
best_feat_num = 4; %experiment_optimal_number_of_features;
[observ_seq, state_seq, feat_names] = get_all_data(body_part);

% Have multiple runs of both methods
run_num = 9;
accuracies = zeros(2, run_num*2);
logliks = zeros(3, run_num*2);
% For each run, 
for i = run_num:-1:2
    testdata_proportion = i/10;
    [traindata, testdata] = splitdataset(observ_seq, state_seq, testdata_proportion);
   
    %build model without dimensionality reduction
    disp('No reduction');
    [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
    no_reduc_model.A = A;
    no_reduc_model.phi = phi;
    no_reduc_model.pi = pi;
    [accuracies(1, i), ~, logliks(1, i)] = GmmHMMpredict(no_reduc_model, testdata);
   
    %Build model with dimensionality reduction
%     disp('Forward Feature selection with knn');
    data = make_data(traindata.observ, traindata.state, feat_names);
% %     [selected_observ, feat_out] = featselect(data, best_feat_num);
%     feat_out = {'FrontYaw'; 'BackPitch'; 'BackRoll'; 'BackYaw'};
%     selected_observ = get_selected_features(traindata.observ, feat_names, feat_out);
%     reduc_testdata = get_selected_features(testdata.observ, feat_names, feat_out);
%     testdata.observ = reduc_testdata;
%     [pi, A, phi] = BuildGmmHMM(selected_observ, traindata.state);
%     filter_model.A = A;
%     filter_model.phi = phi;
%     filter_model.pi = pi;
%     [accuracies(2, i), ~, logliks(2, i)] = GmmHMMpredict(filter_model, testdata);
    
    %Build model with dimensionality reduction
    disp('Feature selection with SDM');
%     [selected_observ, feat_out] = featselect(data, best_feat_num);
    feat_out = {'magFront_cal'; 'magBack_cal'; 'magFront_cal3'; 'BackYaw'};
    selected_observ = get_selected_features(traindata.observ, feat_names, feat_out);
    reduc_testdata = get_selected_features(testdata.observ, feat_names, feat_out);
    testdata.observ = reduc_testdata;
    [pi, A, phi] = BuildGmmHMM(selected_observ, traindata.state);
    filter_model.A = A;
    filter_model.phi = phi;
    filter_model.pi = pi;
    [accuracies(3, i), ~, logliks(3, i)] = GmmHMMpredict(filter_model, testdata);
end
N = size(observ_seq, 1);
incr = 0.1*N;
x_axis = 0.2*N:incr:0.9*N;
% Plot effect of datasize
figure;
plot(x_axis, fliplr(accuracies(1,:))); hold on;
plot(x_axis, fliplr(accuracies(2,:)));
plot(x_axis, fliplr(accuracies(3,:)));
figtitle = 'Effect on data size on accuracy';
title(figtitle);
xlabel('Training data proportion');
ylabel('HMM model accuracy');
legend({'No reduction', 'Feature selection with KNN', 'Feature selection with SDM'}, 'Location', 'NW');

figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');

% Plot effect of datasize
figure;
plot(x_axis, fliplr(logliks(1,:))); hold on;
plot(x_axis, fliplr(logliks(2,:))); hold on;
plot(x_axis, fliplr(logliks(3,:)));
figtitle = 'Effect on data size on accuracy';
title(figtitle);
xlabel('Training data proportion');
ylabel('LogLikelihood');
legend({'No reduction', 'Feature selection with KNN', 'Feature selection with SDM'}, 'Location', 'NW');
figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');