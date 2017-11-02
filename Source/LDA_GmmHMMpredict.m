function [accuracy, path, loglik] = LDA_GmmHMMpredict(model, testdata, feat_num)
    lda_testdata = lda_featsel(testdata, feat_num);
    [accuracy, path, loglik] = GmmHMMpredict(model, lda_testdata );
end