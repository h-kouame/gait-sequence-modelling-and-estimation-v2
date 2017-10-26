function [post_prob, state_seq, feat_labels] = CKNN(body_part)
    if nargin < 1
        body_part = 'front';  
    end
    
    delfigs;
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducility
   
    [dataset, ~ , state_seq, feat_labels] = getprdataset(body_part);
    
    [T, S] = gendat(dataset, 0.5);
    T = setname(T, strcat(body_part, ' Training Set')); 
    S = setname(S, strcat(body_part, ' Test Set'));
    KNN = knnc(dataset);
        
    %Errors
    DT = dataset*KNN;
    training_error = DT*testc
    DS = flipud(dataset)*KNN;
    test_error = DS*testc
    labs = getlabels(flipud(dataset));        
    labsc = DS*labeld;
    accuracy = 100*mean(labs==labsc)
    
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
    