function model = LDA_BuildGmmHMM(data)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
    end
    
    lda_data = pca_featsel(data);
    [pi, A, phi] = BuildGmmHMM(lda_data.observ, lda_data.state);
    model.pi = pi; model.A = A; model.phi = phi;
end