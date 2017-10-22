function [selected_observ_seq, state_seq, out_feat_labels] = SDM(body_part, num_feat_out)
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
    [means, cov_matrices] = meancov(dataset);
%     separability degree matrix
%     sdm = distmaha(dataset, means, cov_matrices);
    
    feat_num = size(observ_seq, 2);
    class_num = 4;
    sdm = zeros(class_num, class_num, feat_num);
    for k = 1:feat_num
        sdm_k = distmaha(dataset(:, k));
        sdm(:, :, k) = sdm_k; 
    end
    sdm_avg = mean(sdm, 3);
    
    sim_d_k = zeros(class_num, class_num, feat_num);
    threshold = 1;
    for k = 1:feat_num
        for r = 1:class_num
            for c = 1:class_num
                if sdm(r, c, k) > 1.1*sdm_avg(r, c, 1)
                   sim_d_k(r, c, k) = 1;
                elseif sdm(r, c, k) > threshold
                    sim_d_k(r, c, k) = 1;
                else
                    sim_d_k(r, c, k) = 0;
                end
            end
        end
    end
    
    wm_k = sim_d_k ./ (sum(sim_d_k, 3));
    
    G_x_k = zeros(1, feat_num);
    for k = 1:feat_num
        G_x_k = sum(sum(sim_d_k .* wm_k(:,:, k), 'omitnan'));
    end
    
    out_feat_labels = W.labels
    
    selected_observ_seq = []; 
    for i = 1:size(feat_labels)
        feat_name = feat_labels(i);
        if ismember(feat_name, out_feat_labels)
            selected_observ_seq = [selected_observ_seq, observ_seq(:, i)];
        end
    end     
end