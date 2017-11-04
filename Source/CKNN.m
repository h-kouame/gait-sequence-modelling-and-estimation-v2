function [test_err, train_err] = CKNN(data, train_prop)
    if nargin < 1
        [obs, states, feats] = get_all_data();
        data = make_data(obs, states, feats);
        train_prop = 0.5;
    end
   
%     [dataset, ~ , state_seq, feat_labels] = getprdataset(data);
    dataset = getprdataset(data);
    
    %split dataset into train and test sets
    [T, S] = gendat(dataset, train_prop);
    T = setname(T, 'Training Set'); 
    S = setname(S, 'Test Set');
    KNN = knnc(dataset);
        
%     evaluate bias error
    DT = T*KNN;
    train_err = DT*testc
    
%     evaluate test error
    DS = S*KNN;
    test_err = DS*testc
        
     post_prob = +knn_map(dataset, KNN);
%     MOGC = mogc(post_prob, 2);
%     
%     DT = post_prob*MOGC;
%     training_error = DT*testc
%     DS = flipud(post_prob)*MOGC;
%     test_error = DS*testc
%     labs = getlabels(flipud(post_prob));        
%     labsc = DS*labeld;
%     accuracy = 100*mean(labs==labsc)
%     scatterd(post_prob);
end
    