function [selected_observ_seq, state_seq, out_feat_labels] = featselect(body_part, num_feat_out)
    if nargin < 1
        body_part = 'front';
        num_feat_out = 0;
    elseif nargin < 2
        num_feat_out = 0;
    end
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducility
   
    [observ_seq, state_seq, feat_labels] = get_all_data(body_part);
    
    if num_feat_out == size(observ_seq, 2)
        selected_observ_seq = observ_seq;
        out_feat_labels = feat_labels;
        return
    end
    
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
    
%     forward feature selection
    dataset = setname(dataset, 'original dataset');
    mix_num = 2;
    mixt_based_classifier = mogc([], mix_num);
    W = featself(dataset, mixt_based_classifier, num_feat_out); 
    
    out_feat_labels = W.labels
    
    selected_observ_seq = []; 
    for i = 1:size(feat_labels)
        feat_name = feat_labels(i);
        if ismember(feat_name, out_feat_labels)
            selected_observ_seq = [selected_observ_seq, observ_seq(:, i)];
        end
    end     
end