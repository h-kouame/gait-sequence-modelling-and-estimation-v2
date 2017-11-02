function model = PCA_BuildGmmHMM(data)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
    end
    
    pca_data = pca_featsel(data);
    [pi, A, phi] = BuildGmmHMM(pca_data.observ, pca_data.state);
    model.pi = pi; model.A = A; model.phi = phi;
end