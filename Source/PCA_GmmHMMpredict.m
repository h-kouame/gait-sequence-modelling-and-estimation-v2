function [accuracy, path, loglik] = PCA_GmmHMMpredict(model, testdata)
    pca_testdata = pca_featsel(testdata);
    [accuracy, path, loglik] = GmmHMMpredict(model, pca_testdata );
end