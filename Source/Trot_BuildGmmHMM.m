function model = Trot_BuildGmmHMM(data)
    if nargin < 1
        data = get_trot_data();
    end
    
    model = BuildGmmHMM(data.observ, data.state);
end