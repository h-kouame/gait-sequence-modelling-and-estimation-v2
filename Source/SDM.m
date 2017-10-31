function [G_x_k, wm_k, sim_d_k, sdm_avg, sdm] = SDM(data)
    if nargin < 1
        [obs, states, feats] = get_all_data();
        data = make_data(obs, states, feats);
    end
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducility
    
%     create prtools dataset 
    dataset = getprdataset(data);
    
    feat_num = size(dataset, 2);
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
                if sdm(r, c, k) > sdm_avg(r, c, 1)
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
    
    G_x_k_temp = zeros(1, feat_num);
    for k = 1:feat_num
        G_x_k_temp = sum(sum(sim_d_k .* wm_k(:,:, k), 'omitnan'));
    end
    G_x_k = G_x_k_temp(:).';
%     sorted_G = sort(G_x_k, 3, 'descend');
%     ordered_observ_seq = zeros(size(observ_seq, 1), size(observ_seq, 2)); 
%     feat_idx = 1;
%     for i = 1:feat_num
%         if (isempty(sorted_G))
%             break
%         end
%         next_max_G = sorted_G(1,1,1);
%         for j = 1:feat_num
%             if G_x_k(1, 1, j) == next_max_G
%                 ordered_observ_seq(:, feat_idx) = observ_seq(:, j);
%                 feat_idx = feat_idx + 1;
%             end
%         end
%         sorted_G = sorted_G(sorted_G(1,1,:) ~=  next_max_G);
%     end     
end