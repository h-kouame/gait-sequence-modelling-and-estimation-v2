function model = PCA_BuildGmmHMM(data, comp_num)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        comp_num = 4;
    end
    
    pca_data = pca_featsel(data, comp_num);
    model = BuildGmmHMM(pca_data.observ, pca_data.state);
end