function [best_comp_num, accs] = optimal_pca_comp_num(data, max_comp_num, proportion)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        max_comp_num = 10;
        proportion = 0.9;
    end
    
    accs = zeros(1, max_comp_num);
    [traindata, testdata] = splitdataset(data.observ, data.state, data.feat, proportion);
    for i = 1:max_comp_num
        model = PCA_BuildGmmHMM(traindata, i);
        accs(i) = PCA_GmmHMMpredict(model, testdata, i);
    end
    
    [~, best_comp_num] = max(accs);
    
    figure;
    plot(1:max_comp_num, accs, 'LineWidth',2, 'MarkerSize',10);
    figtitle = 'Optimal PCA component number';
    title(figtitle);
    ylabel('Prediction accuracy (%)');
    figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
    print(figpath, '-depsc');
end