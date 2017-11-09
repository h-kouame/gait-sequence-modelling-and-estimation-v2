function model = Run_BuildGmmHMM(data)
    if nargin < 1
        data = get_run_data();
    end
    
    model = BuildGmmHMM(data.observ, data.state);
end