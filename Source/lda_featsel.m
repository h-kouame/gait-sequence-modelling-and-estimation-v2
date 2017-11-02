function [outdata, lda_map] = lda_featsel(indata, comp_num)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        indata = make_data(observ_seq, state_seq, feat_names);
        comp_num = 3;
    end
    
    prdata = getprdataset(indata);
    lda_map = fisherm(prdata, comp_num);
    proutdata = prdata*lda_map;
    outdata.observ = +proutdata;
    outdata.state = indata.state;
    outdata.feat = indata.feat;
end