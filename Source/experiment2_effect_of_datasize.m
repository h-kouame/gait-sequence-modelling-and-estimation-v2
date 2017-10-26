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
    accuracies(1, i*2) = GmmHMMpredict(no_reduc_model, testdata);
   
    %Build model with dimensionality reduction
    disp('Feature selection');
    data = make_data(traindata.observ, traindata.state, feat_names);
    [selected_observ, feat_out] = featselect(data, best_feat_num);
    reduc_testdata = get_selected_features(testdata.observ, feat_names, feat_out);
    testdata.observ = reduc_testdata;
    [pi, A, phi] = BuildGmmHMM(selected_observ, traindata.state);
    filter_model.A = A;
    filter_model.phi = phi;
    filter_model.pi = pi;
    accuracies(2, i*2) = GmmHMMpredict(filter_model, testdata);
end

% Plot effect of datasize
plot(0.05:0.05:0.9, accuracies(1,:)); hold on;
plot(0.05:0.05:0.9, accuracies(2,:));
xlabel('Training data proportion');
xlabel('HMM model accuracy');