function [observ_seq, state_seq] = get_all_backdata()
    common_path = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\';
    files = dir(strcat(common_path, '*.mat'));

    state_seq = [];
    observ_seq = [];
    for f = 1:size(files)
        file = files(f);
        filepath = strcat(common_path, file.name);
        try
            [observ, states] = getbackdata(filepath);
            min_length = min(size(observ, 1), size(states, 1));
            observ_seq = [observ_seq; observ(1:min_length, :) ];
            state_seq = [state_seq; states(1:min_length, :)];
        catch 
        end
    end
%     double data by adding reverse sequence
    observ_seq = [observ_seq; flipud(observ_seq)];
    state_seq = [state_seq; flipud(state_seq)];
end