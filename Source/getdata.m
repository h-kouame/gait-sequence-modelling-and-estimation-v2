function [observations, states, feature_labels] = getdata(datapath, body_part) 
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';  
        body_part = 'front';
    elseif nargin < 2
        body_part = 'front';
    end
    
    data = load(datapath);
        
%     double states sequence by mirroring
%     states = [states; flipud(states)];

    if(strcmp(body_part, 'front'))
         states = [data.LF, data.RF];
         fields = {'numFrontCRC', 'numBackCRC', 'LF', 'LB', 'RF', 'RB'};
    else
         states = [data.LB, data.RB];
         fields = {'numFrontCRC', 'numBackCRC', 'LF', 'LB', 'RF', 'RB'};
    end
    states = bin2dec(num2str(states)) + 1;
    try 
        z = data.z;
        fields = [fields, 'z'];
    catch
    end
 
    D = rmfield(data, fields);
    D = orderfields(D);
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
%     observations = [observations; flipud(observations)];
end