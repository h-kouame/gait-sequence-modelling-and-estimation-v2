function [accuracy, path, loglik] = Just_Front_GmmHMMpredict(model, testdata)
    front_testdata = get_just_front_data(testdata);
    [accuracy, path, loglik] = GmmHMMpredict(model, front_testdata);
end