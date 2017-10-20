function [observations, states, feature_labels] = getbackdata(datapath) 
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';  
    end
    
    data = load(datapath);
    states = [data.LB, data.RB];
    states = bin2dec(num2str(states)) + 1;

%     double states sequence by mirroring
    states = [states; flipud(states)];
    fields = {'magFront_cal', 'accFrontZ', 'accFrontY', 'accFrontX', 'FrontRoll', 'FrontPitch', 'FrontYaw', 'numFrontCRC', 'numBackCRC', 'LF', 'LB', 'RF', 'RB'};
 
    D = rmfield(data, fields);
    fns = fieldnames(D);
    observations =  [];
    feature_labels = {};
    for i = 1:length(fns)
        measur = D.(fns{i});
        for j = 1:size(measur, 2)
            observations = [observations, measur(:, j)];
            if j > 1
               feat_lab = strcat(fns{i}, num2str(j));
            else
               feat_lab = fns{i}; 
            end
            feature_labels = [feature_labels; feat_lab];
        end
    end
%     double observations sequence by mirroring
    observations = [observations; flipud(observations)];
end