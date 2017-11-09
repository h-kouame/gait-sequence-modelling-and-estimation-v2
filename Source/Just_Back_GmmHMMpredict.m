function [accuracy, path, loglik] = Just_Back_GmmHMMpredict(model, testdata)
    back_testdata = get_just_back_data(testdata);
    [accuracy, path, loglik] = GmmHMMpredict(model, back_testdata);
end