function model = Just_Back_BuildGmmHMM(data)
    if nargin < 1
        [data.observ, data.state, data.feat] = get_all_data('back');
        back_data = get_just_back_data(data);
    end
    
    back_data = get_just_back_data(data);
    model = BuildGmmHMM(back_data.observ, back_data.state);
end