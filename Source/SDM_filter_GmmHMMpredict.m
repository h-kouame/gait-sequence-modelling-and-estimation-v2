function [accuracy, path, loglik] = SDM_filter_GmmHMMpredict(model, testdata)

    feat_out = {'magFront_cal'; 'magBack_cal'; 'magFront_cal3'; 'FrontYaw'};
    sel_observ = get_selected_features(testdata.observ, testdata.feat, feat_out);
    testdata.observ = sel_observ;
    [accuracy, path, loglik] = GmmHMMpredict(model, testdata);
end