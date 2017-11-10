function front_data = get_just_front_data(data)
    if nargin < 1
        [data.observ, data.state, data.feat] = get_all_data('front');
    end
    
    data_size = size(data.observ);
    feat_names = data.feat;
    front_data.state = data.state;
    front_feat_size = data_size(2)/2;
    front_data.observ = zeros(data_size(1), front_feat_size); %Front measurements is half the total measurement
    front_data.feat = cell(front_feat_size, 1);
    idx = 1;
    for f = 1:size(feat_names, 1)
        feat_name = feat_names(f);
        if contains(feat_name, 'front', 'IgnoreCase',true)
            front_data.observ(:, idx) = data.observ(:, f);
            front_data.feat(idx) = feat_name;
            idx = idx + 1;
        end
    end
end