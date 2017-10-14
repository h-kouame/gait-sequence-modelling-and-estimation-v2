function [R] = prgpr(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
    end

    [O, M, D] = preprocess(datapath, true);
    K = proxm([], 'e', 2);
    [t, s] = gendat(D, 0.5);
    R = gpr(t, K);
    error = testr(s, R);
    r = rsquared(s, R);
    disp(error);   
    disp(r);
    plotr(R);
end