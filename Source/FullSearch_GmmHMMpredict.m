function [accuracy, path, loglik] = FullSearch_GmmHMMpredict(model, testdata, build_data)

%    Not determistic
    sel_observ = get_selected_features(testdata.observ, testdata.feat, build_data.feat);
    testdata.observ = sel_observ;
    testdata.feat = build_data.feat;
    [accuracy, path, loglik] = GmmHMMpredict(model, testdata);
end