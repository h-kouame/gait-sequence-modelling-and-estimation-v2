function data = make_data(obs, states, feats)
    data.observ = obs;
    data.state = states;
    if(exist('feats', 'var'))
        data.feat = feats;
    end
end