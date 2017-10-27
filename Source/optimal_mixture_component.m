function [best_mix_num, criteria] = optimal_mixture_component(data)
    if nargin < 1
        [obs, states, feats] = get_all_data();
        data = make_data(obs, states, feats);
    end
    
    [best_mix_num, criteria] = byAIC(data);
%     byMOGC(data);
end

function [numComponents, AIC] = byAIC(data)
    X = data.observ;
    max_feat_num = size(data.observ, 2);
    AIC = zeros(1, max_feat_num);
    GMModels = cell(1, max_feat_num);
    options = statset('MaxIter',500);
    for k = 1:max_feat_num
        GMModels{k} = fitgmdist(X,k,'Options',options,'CovarianceType','diagonal', 'regularize', 1e-10);
        AIC(k)= GMModels{k}.AIC;
    end

    [minAIC, numComponents] = min(AIC);
    numComponents
    minAIC
end

function best_mix_num = byMOGC(data)
    dataset = getprdataset(data);
    [T, S] = gendat(dataset, 0.8);
    T = setname(T, 'Training Set'); 
    S = setname(S, 'Test Set');
    
    max_feat_num = size(dataset, 2);
    accuracies = zeros(1, max_feat_num);
    best_mix_num = 2;
    max_accuracy = 0;
    for k = 2:6
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
end