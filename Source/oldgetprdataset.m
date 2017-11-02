function [dataset, observ_seq, state_seq, feat_labels] = oldgetprdataset(data)
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
    
     O = getstatesdata(observ_seq, state_seq);

    
%     create prtools dataset 
    classes = [O{1}; O{2}; O{3}; O{4}];
    sizes = [size(O{1}, 1), size(O{2}, 1), size(O{3}, 1), size(O{4}, 1)];
    S = unique(state_seq);
    labels = strcat('state', num2str(S));
    L = genlab(sizes, labels);
    dataset = prdataset(classes, L);
    try
        dataset = setfeatlab(dataset, feat_labels);
    catch
    end
    dataset_len = min(length(observ_seq), length(state_seq));
    priors = sizes./dataset_len;
    dataset = setprior(dataset, priors);
end