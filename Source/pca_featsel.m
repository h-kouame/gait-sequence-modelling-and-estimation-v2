function [outdata, pca_map] = pca_featsel(indata, comp_num)
    if nargin < 1
        [observ_seq, state_seq, feat_names] = get_all_data();
        indata = make_data(observ_seq, state_seq, feat_names);
        comp_num = 4;
    end
    
    prdata = getprdataset(indata);
    pca_map = pcam(prdata, comp_num);
    proutdata = prdata*pca_map;
    outdata.observ = +proutdata;
    outdata.state = indata.state;
    outdata.feat = indata.feat;
end