function [observ_seq, state_seq, feat_names] = get_all_data(body_part)
    if nargin < 1
        body_part = 'front';   
    end
    
    common_path = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\';
    files = dir(strcat(common_path, '*.mat'));

    state_seq = [];
    observ_seq = [];
    feat_names = [];
    for f = 1:size(files)
        file = files(f);
        filepath = strcat(common_path, file.name);
        try
            [observ, states, feat_names] = getdata(filepath, body_part);
            min_length = min(size(observ, 1), size(states, 1));
            observ_seq = [observ_seq; observ(1:min_length, :)];
            state_seq = [state_seq; states(1:min_length, :)];
        catch 
        end
    end
%     double data by adding reverse sequence
    observ_seq = [observ_seq; flipud(observ_seq)];
    state_seq = [state_seq; flipud(state_seq)];
end