function back_data = get_just_back_data(data)
    if nargin < 1
        [data.observ, data.state, data.feat] = get_all_data('back');
    end
    
    data_size = size(data.observ);
    feat_names = data.feat;
    back_data.state = data.state;
    back_feat_size = data_size(2)/2;
    back_data.observ = zeros(data_size(1), back_feat_size); %back measurements is half the total measurement
    back_data.feat = cell(back_feat_size, 1);
    idx = 1;
    for f = 1:size(feat_names, 1)
        feat_name = feat_names(f);
        if contains(feat_name, 'back', 'IgnoreCase',true)
            back_data.observ(:, idx) = data.observ(:, f);
            back_data.feat(idx) = feat_name;
            idx = idx + 1;
        end
    end
end