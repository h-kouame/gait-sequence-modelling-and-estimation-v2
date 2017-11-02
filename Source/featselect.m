function [selected_observ_seq, out_feat_labels] = featselect(data, num_feat_out)
    if nargin < 1
        [obs, states, feats] = get_all_data();
        data = make_data(obs, states, feats);
        num_feat_out = 0;
    elseif nargin < 2
        num_feat_out = 4;
    end
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducility
    
%     create prtools dataset 
    dataset = getprdataset(data);
    
%     forward feature selection
    dataset = setname(dataset, 'original dataset');

    W = featself(dataset, 'NN', num_feat_out); 
  
    out_feat_labels = W.labels
    selected_observ_seq = +W
    
    %NOT NEEDED now that observation sequence is in the correct order
%     observ_seq = data.observ; 
%     feat_labels = data.feat;
%     selected_observ_seq = get_selected_features(observ_seq, feat_labels, out_feat_labels);
end

