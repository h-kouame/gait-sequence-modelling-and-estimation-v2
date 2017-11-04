function [accuracy, path, loglik] = SDM_GmmHMMpredict(model, testdata)
    feat_out = {'magFront_cal'; 'magBack_cal'; 'magFront_cal3'; 'BackYaw'};
    sel_observ = get_selected_features(testdata.observ, testdata.feat, feat_out);
    testdata.observ = sel_observ;
    testdata.feat = feat_out;
    [accuracy, path, loglik] = GmmHMMpredict(model, testdata);
end