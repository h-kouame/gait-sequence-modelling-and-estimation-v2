function [pi, A, B] = visualise_features(observ_seq, state_seq)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        [observ_seq, ~, feat_name] = getfrontdata(datapath);   
    end
    
    delfigs; 
    
    feat_num = size(observ_seq);
%     state_num = 4;
    
    count = 0;
    for i = 1:feat_num - 1     
        for j = i + 1:feat_num
            count = count + 1;
            subplot(4, 4, count);
            scatter(observ_seq(:, i), observ_seq(:, j));
            title(strcat(feat_name(i), 'and', feat_name(j)));
        end
        
    end
end