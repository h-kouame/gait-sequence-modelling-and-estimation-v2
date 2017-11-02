function [accuracy, path, loglik] = LDA_GmmHMMpredict(model, testdata)
    lda_testdata = lda_featsel(testdata);
    [accuracy, path, loglik] = GmmHMMpredict(model, lda_testdata );
end