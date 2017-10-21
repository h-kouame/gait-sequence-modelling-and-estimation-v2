function best_mix_num = optimal_mixture_component(data)
    if nargin < 1
        data = get_all_frontdata;   
    end

    AIC = zeros(1, 2);
    GMModels = cell(1,length(AIC));
    options = statset('MaxIter', 500);
    for k = 1:length(AIC)
        GMModels{k} = fitgmdist(data, k, 'Options',options, 'CovarianceType', 'diagonal');
        AIC(k)= GMModels{k}.AIC;
    end

    [minAIC, best_mix_num] = min(AIC);
    best_mix_num
%     BestModel = GMModels{numComponents}

end

