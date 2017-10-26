proportion = 0.1;
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
selected_observ = featselect();
[pi, A, phi] = BuildGmmHMM(traindata.observ, traindata.state);
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
    accuracies(2, i) = GmmHMMpredict(filter_model, testdata);
end

%Plot the accuracy of the different runs
bar(accuracies(1,:), accuracies(2,:));
ylabel('HMM accuracy');
%plot the averages