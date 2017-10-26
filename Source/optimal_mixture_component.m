function [best_mix_num, accuracies] = optimal_mixture_component(body_part)
    if nargin < 1
        body_part = 'front';  
    end
    
    dataset = getprdataset(body_part);
    [T, S] = gendat(dataset, 0.8);
    T = setname(T, strcat(body_part, ' Training Set')); 
    S = setname(S, strcat(body_part, ' Test Set'));
    
    max_feat_num = size(dataset, 2);
    accuracies = zeros(1, max_feat_num);
    best_mix_num = 2;
    max_accuracy = 0;
    for k = 2:6
        k
        KNN = mogc(T, k); 
        DS = S*KNN;
%         test_error = DS*testc;
        labs = getlabels(S);        
        labsc = DS*labeld;
        accuracy = 100*mean(labs==labsc);
        accuracies(k) = accuracy;
        if accuracy > max_accuracy
            best_mix_num = k;
            max_accuracy = accuracy;
        end
    end

    max_accuracy
    best_mix_num
    
    figure;
    plot(1:6, accuracies(1,1:6));
    accuracies(1,1:6)
%     BestModel = GMModels{numComponents}

end

