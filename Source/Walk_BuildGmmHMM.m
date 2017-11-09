function model = Walk_BuildGmmHMM(data)
    if nargin < 1
        data = get_walk_data();
    end
    
    model = BuildGmmHMM(data.observ, data.state);
end