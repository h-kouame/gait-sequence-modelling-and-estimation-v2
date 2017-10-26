rng(8000,'twister');

proportion = 0.2;
body_part = 'front';
best_feat_num = 4; %experiment_optimal_number_of_features;
[observ_seq, state_seq, feat_names] = get_all_data(body_part);
%get training data
[traindata, testdata] = splitdataset(observ_seq, state_seq, proportion);

%build model without dimensionality reduction
[pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
no_reduc_model.A = A;
no_reduc_model.phi = phi;
no_reduc_model.pi = pi;
%build model with PCA

%Build model with LDA

%Build model with Filter methods: KNN, Gaussian, Maha, Euclidien, In-Maha
data = make_data(traindata.observ, traindata.state, feat_names);
[selected_observ, feat_out] = featselect(data, best_feat_num);
reduc_testdata = get_selected_features(testdata.observ, feat_names, feat_out);
[pi, A, phi] = BuildGmmHMM(selected_observ, traindata.state);
filter_model.A = A;
filter_model.phi = phi;
filter_model.pi = pi;

%Run it many times and get the averages of performances
run_num = 1;
accuracies = zeros(2, run_num);
for i = 1:run_num
    disp('No reduction');
    accuracies(1, i) = GmmHMMpredict(no_reduc_model, testdata);
    disp('Feature selection');
    testdata.observ = reduc_testdata;
    accuracies(2, i) = GmmHMMpredict(filter_model, testdata);
end

%Plot the accuracy of the different runs
bar(accuracies(1,:), accuracies(2,:));
ylabel('HMM accuracy');
%plot the averages