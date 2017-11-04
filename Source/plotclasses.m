function plotclasses(data, states, figtitle)
       figure;
       feat_num = size(data.observ, 2);
       grp = findgroups(states);
       if feat_num == 1
           gscatter(data.observ(:,:), data.observ(:,:), grp, 'bryg', 'o+xd', 10,'on');
       elseif feat_num == 2
           gscatter(data.observ(:, 1), data.observ(:, 2), grp.', 'bryg', 'o+xd', 10,'on'); 
       else
           data.state = states;
           prdata = getprdataset(data);
           pca_2d_data = prdata*pcam(prdata, 2);
           scatterd(pca_2d_data, 'legend');
       end
       
        xlabel('PCA Component 1');
        ylabel('PCA Component 2');
%         title(figtitle);
        figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
        print(figpath, '-depsc');
end