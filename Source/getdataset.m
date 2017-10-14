function dataset = getdataset(datapath, foot)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat'; 
        foot = 'LF';
    elseif nargin < 2
        foot = 'LF';   
    end
    data = load(datapath);
    states = data.LF;
    switch foot
        case 'RF'
            states = data.RF;
        case 'LB'
            states = data.LB;
        case 'RB'  
            states = data.RB;
    end
    
    fields = {'numFrontCRC', 'numBackCRC', 'LF', 'LB', 'RF', 'RB'};
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
    
    dataset_len = min(length(observations), length(states));
    classes = [];
    sizes = [];
    for state = 0:1 
        class = [];
        for i = 1:dataset_len
            observ = states(i);
            measur = observations(i,:);
            if observ == state
                class = [class; measur];
            end
        end
        if (~isempty(class))
            sizes = [sizes, size(class, 1)];
            classes = [classes; class];
        end
    end
    S = unique(states);
    labels = num2str(S);
    L = genlab(sizes, labels);
    dataset = prdataset(classes, L);
    dataset = setfeatlab(dataset, feature_labels);
    priors = sizes./dataset_len;
    dataset = setprior(dataset, priors);
%     dataset = setprior(dataset,0);
end