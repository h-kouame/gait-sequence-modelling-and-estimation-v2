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
    max_mixt_num = 18;
    AIC = zeros(1, max_mixt_num);
    BIC = zeros(1, max_mixt_num);
    GMModels = cell(1, max_mixt_num);
    options = statset('MaxIter', 2000);
    for k = 1:max_mixt_num
        GMModels{k} = fitgmdist(X,k,'Options',options,'CovarianceType','diagonal', 'regularize', 1e-10);
        AIC(k)= GMModels{k}.AIC;
        BIC(k)= GMModels{k}.BIC;
    end

    [minAIC, numComponents] = min(AIC);
    numComponents
    minAIC
    
    figure;
    plot(1:max_mixt_num, AIC,... 
         1:max_mixt_num, BIC, 'LineWidth',2, 'MarkerSize',10);
    legend({'AIC', 'BIC'}, 'Location','NE');
    xlabel('Number of mixtures');
    ylabel('AIC/BIC value');
    figtitle = 'Optimal number of mixture components';
    title(figtitle);
    figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
    print(figpath, '-depsc');
end

function best_mix_num = byMOGC(data)
    dataset = getprdataset(data);
    [T, S] = gendat(dataset, 0.8);
    T = setname(T, 'Training Set'); 
    S = setname(S, 'Test Set');
    
    max_mixt_num = size(dataset, 2);
    accuracies = zeros(1, max_mixt_num);
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