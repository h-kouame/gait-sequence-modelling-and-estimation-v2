function best_mix_num = optimal_mixture_component(data, max_feat_num)
    if nargin < 1
        data = get_all_data;   
    end

    AIC = zeros(1, max_feat_num);
    GMModels = cell(1, length(AIC));
    options = statset('MaxIter', 500);
    for k = 1:max_feat_num
        GMModels{k} = fitgmdist(data, k, 'Options',options, 'CovarianceType', 'diagonal');
        AIC(k)= GMModels{k}.AIC;
    end

    [minAIC, best_mix_num] = min(AIC);
    if (mod(best_mix_num, 2) ~= 0)
        best_mix_num = best_mix_num - 1;
    end
    best_mix_num
        
%     BestModel = GMModels{numComponents}

end

