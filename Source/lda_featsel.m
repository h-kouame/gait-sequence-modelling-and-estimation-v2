function [outdata, lda_map] = lda_featsel(indata, feat_num)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        indata = make_data(observ_seq, state_seq, feat_names);
        feat_num = 3;
    end
    
    rel_feat = get_relevant_feats(indata);
    prdata = getprdataset(rel_feat);
    lda_map = fisherm(prdata, feat_num);
    proutdata = prdata*lda_map;
    outdata.observ = +proutdata;
    outdata.state = rel_feat.state;
    outdata.feat = rel_feat.feat;
end