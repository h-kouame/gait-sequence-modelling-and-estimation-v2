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
logliks = zeros(2, run_num*2);
% For each run, 
for i = run_num:-0.5:0.5
    testdata_proportion = i/10;
    [traindata, testdata] = splitdataset(observ_seq, state_seq, testdata_proportion);
   
    %build model without dimensionality reduction
    disp('No reduction');
    [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
    no_reduc_model.A = A;
    no_reduc_model.phi = phi;
    no_reduc_model.pi = pi;
    [accuracies(1, i*2), ~, logliks(1, i*2)] = GmmHMMpredict(no_reduc_model, testdata);
   
    %Build model with dimensionality reduction
    disp('Feature selection');
    data = make_data(traindata.observ, traindata.state, feat_names);
%     [selected_observ, feat_out] = featselect(data, best_feat_num);
    feat_out = {'FrontYaw'; 'BackPitch'; 'BackRoll'; 'BackYaw'};
    selected_observ = get_selected_features(traindata.observ, feat_names, feat_out);
    reduc_testdata = get_selected_features(testdata.observ, feat_names, feat_out);
    testdata.observ = reduc_testdata;
    [pi, A, phi] = BuildGmmHMM(selected_observ, traindata.state);
    filter_model.A = A;
    filter_model.phi = phi;
    filter_model.pi = pi;
    [accuracies(2, i*2), ~, logliks(2, i*2)] = GmmHMMpredict(filter_model, testdata);
end

% Plot effect of datasize
figure;
plot(0.05:0.05:0.9, fliplr(accuracies(1,:))); hold on;
plot(0.05:0.05:0.9, fliplr(accuracies(2,:)));
figtitle = 'Effect on data size on accuracy';
title(figtitle);
xlabel('Training data proportion');
ylabel('HMM model accuracy');
legend({'No reduction', 'Reduction'}, 'Location', 'NW');

figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');

% Plot effect of datasize
figure;
plot(0.05:0.05:0.9, fliplr(logliks(1,:))); hold on;
plot(0.05:0.05:0.9, fliplr(logliks(2,:)));
figtitle = 'Effect on data size on accuracy';
title(figtitle);
xlabel('Training data proportion');
ylabel('LogLikelihood');
legend({'No reduction', 'Reduction'}, 'Location', 'NW');
figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
print(figpath, '-depsc');