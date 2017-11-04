function model = LDA_BuildGmmHMM(data, feat_num)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        data = make_data(observ_seq, state_seq, feat_names);
        feat_num = 3;
    end
    
    lda_data = lda_featsel(data, feat_num);
    [pi, A, phi] = BuildGmmHMM(lda_data.observ, lda_data.state);
    model.pi = pi; model.A = A; model.phi = phi;
end