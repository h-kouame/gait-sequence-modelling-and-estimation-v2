function [R] = prgpr(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat'; 
    end

    delfigs;
    
    [D, O, S]  = preprocess(datapath);
    K = proxm([], 'e', 2);
    [t, s] = gendat(D(:,1), 0.5);
    R = gpr(t, K);
    
    error = testr(s, R);
    r = rsquared(s, R);
    disp(error);   
    disp(r);
    figure; plotr(R, 'g'); 
    
    Y = linearr(t, 100);
    errorL = testr(s, Y);
    rL = rsquared(s, Y);
    disp(errorL);   
    disp(rL);
    figure; plotr(Y, 'b');
    
    [p, S, mu] = polyfit(+S, +D(:,1), 5);
end