function [accuracy, path, loglik] = PCA_GmmHMMpredict(model, testdata, comp_num)
    pca_testdata = pca_featsel(testdata, comp_num);
    [accuracy, path, loglik] = GmmHMMpredict(model, pca_testdata );
end