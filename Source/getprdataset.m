function [dataset, observ_seq, state_seq, feat_labels] = getprdataset(body_part)
    if nargin < 1
        body_part = 'front';  
    end
    
    delfigs;
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducility
   
    [observ_seq, state_seq, feat_labels] = get_all_data(body_part);
    
    O = getstatesdata(observ_seq, state_seq);
    
%     create prtools dataset 
    classes = [O{1}; O{2}; O{3}; O{4}];
    sizes = [size(O{1}, 1), size(O{2}, 1), size(O{3}, 1), size(O{4}, 1)];
    S = unique(state_seq);
    labels = num2str(S);
    L = genlab(sizes, labels);
    dataset = prdataset(classes, L);
    dataset = setfeatlab(dataset, feat_labels);
    dataset_len = min(length(observ_seq), length(state_seq));
    priors = sizes./dataset_len;
    dataset = setprior(dataset, priors);
end