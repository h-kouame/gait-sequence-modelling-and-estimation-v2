function [dataset, observ_seq, state_seq, feat_labels] = getprdataset(data)
    if nargin < 1
        [obs, states, feats] = get_all_data();
        data = make_data(obs, states, feats);
    end
    
    prwaitbar off                % waitbar not needed here
   
    observ_seq = data.observ; 
    state_seq = data.state; 
    try
        feat_labels = data.feat;
    catch
    end
    
%     create prtools dataset 
    dataset = prdataset(observ_seq, state_seq);
    try
        dataset = setfeatlab(dataset, feat_labels);
    catch
    end
    dataset_len = min(length(observ_seq), length(state_seq));
    sizes = classsizes(dataset);
    priors = sizes./dataset_len;
    dataset = setprior(dataset, priors);
end