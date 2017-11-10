function model = Just_Front_BuildGmmHMM(data)
    if nargin < 1
        [data.observ, data.state, data.feat] = get_all_data('front');
        front_data = get_just_front_data(data);
    end
    
    front_data = get_just_front_data(data);
    model = BuildGmmHMM(front_data.observ, front_data.state);end