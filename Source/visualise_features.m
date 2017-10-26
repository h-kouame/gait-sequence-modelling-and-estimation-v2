function visualise_features(body_part)
    if nargin < 1
        body_part = 'front';
    end
    
    delfigs; 
    
    [observ_seq, state_seq, feat_names] = get_all_data(body_part); 
    feat_num = size(observ_seq, 2);
%     state_num = 4;
    figure;
    for k = 1:size(observ_seq, 2)
        scatter(observ_seq(:, k), state_seq, 'filled');
        hold on;
    end
    figtitle = strcat('Observations', '\_vs\_', 'States');
    title(figtitle);
    figtitle = strcat('Observations', '_vs_', 'States');
    lgd = legend(feat_names);
    lgd.Location = 'northwest';
    xlabel('IMU Observations');
    ylabel('States');
    figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
    print(figpath, '-depsc');
    
    for i = 1:feat_num - 1     
        for j = i + 1:feat_num
            fig = figure;
            fig.Visible = 'off';
            feat1 = getstatesdata(observ_seq(:, i), state_seq);
            feat2 = getstatesdata(observ_seq(:, j), state_seq);
            for k = 1:size(feat1, 2)
                scatter(feat1{k}, feat2{k}, 'filled');
                hold on;
            end
            figtitle = strcat(feat_names(i), '\_vs\_', feat_names(j));
            title(figtitle);
            figtitle = strcat(feat_names(i), '_vs_', feat_names(j));
            lgd = legend({'state 1', 'state 2', 'state 3', 'state 4'});
            lgd.Location = 'best';
            xlabel(feat_names(i));
            ylabel(feat_names(j));
            figpath = strcat('C:\School\EEE4022S\Gait Sequence Estimation\Figures\', figtitle);
            print(figpath{1}, '-depsc');
        end   
    end
%     showfigs;
end