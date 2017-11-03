function [accuracy, path, loglik] = KNN_GmmHMMpredict(model, testdata)

    feat_out = {'FrontYaw'; 'BackPitch'; 'BackRoll'; 'BackYaw'};
    sel_observ = get_selected_features(testdata.observ, testdata.feat, feat_out);
    testdata.observ = sel_observ;
    testdata.feat = feat_out;
    [accuracy, path, loglik] = GmmHMMpredict(model, testdata);
end