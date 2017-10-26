% Effect of training data size on performance

% Consider both one dimensionality reduction and no reduction

% Get dataset
body_part = 'front';
num_feat_out = 0;
[observ_seq, state_seq, feat_names] = get_all_data(body_part);

% Have multiple runs of both methods
run_num = 9;
accuracies = zeros(2, run_num);
% For each run, 
for i = run_num:-1:1
    testdata_proportion = i/10;
    [traindata, testdata] = splitdataset(observ_seq, state_seq, testdata_proportion);
   
    %build model without dimensionality reduction
    disp('No reduction');
    [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
    no_reduc_model.A = A;
    no_reduc_model.phi = phi;
    no_reduc_model.pi = pi;
    accuracies(1, i) = GmmHMMpredict(no_reduc_model, testdata);
   
    %Build model with dimensionality reduction
    disp('Feature selection');
    selected_observ = featselect(body_part, num_feat_out);
    [pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
    filter_model.A = A;
    filter_model.phi = phi;
    filter_model.pi = pi;
    accuracies(2, i) = GmmHMMpredict(filter_model, testdata);
end

% Plot effect of datasize
plot(0.1:-0.1:0.9, accuracies(1,:)); hold on;
plot(0.1:-0.1:0.9, accuracies(2,:));
xlabel('Training data proportion');
xlabel('HMM model accuracy');