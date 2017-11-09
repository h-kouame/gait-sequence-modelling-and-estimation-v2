function data = get_walk_data(body_part)
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
        filename = file.name;
        if contains(filename, 'walk', 'IgnoreCase',true)
            filepath = strcat(common_path, filename);
            try
                [observ, states, feat_names] = getdata(filepath, body_part);
                min_length = min(size(observ, 1), size(states, 1));
                if contains(filename, 'trot', 'IgnoreCase',true)
                    walk_start_idx = 320;
                    observ_seq = [observ_seq; observ(walk_start_idx:min_length, :)];
                    state_seq = [state_seq; states(walk_start_idx:min_length, :)];
                else                    
                    observ_seq = [observ_seq; observ(1:min_length, :)];
                    state_seq = [state_seq; states(1:min_length, :)];
                end
            catch 
            end
        end
    end
%     double data by adding reverse sequence
    observ_seq = [observ_seq; flipud(observ_seq)];
    state_seq = [state_seq; flipud(state_seq)];
    
    observ_seq = [observ_seq; flipud(observ_seq)];
    state_seq = [state_seq; flipud(state_seq)];
    
    observ_seq = [observ_seq; flipud(observ_seq)];
    state_seq = [state_seq; flipud(state_seq)];
    
    data.observ = observ_seq;
    data.state = state_seq;
    data.feat = feat_names;
end