function [accuracy, path, loglik] = FullSearch_GmmHMMpredict(model, testdata, build_data)

%     feat_out = {'magBack_cal2'; 'FrontRoll'; 'magFront_cal3'; 'BackYaw'};
%    Not determistic
    sel_observ = get_selected_features(testdata.observ, testdata.feat, build_data.feat);
    testdata.observ = sel_observ;
    testdata.feat = feat_out;
    [accuracy, path, loglik] = GmmHMMpredict(model, testdata);
end