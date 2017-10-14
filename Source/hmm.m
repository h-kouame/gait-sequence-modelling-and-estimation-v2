function [pStates, A, E] = hmm(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
    end
    data = load(datapath);
    LF2str = num2str(data.LF);
    LB2str = num2str(data.LB);
    RF2str = num2str(data.RF);
    RB2str = num2str(data.RB);
    feat2observ = strcat(LF2str, LB2str, RF2str, RB2str);
    states = bin2dec(feat2observ);
    observations = [data.LF, data.RF, data.LB, data.RB];
    TS = [states(1:length(states)/2)];
    SS = [states(length(states)/2 + 1 :length(states))];
    TO = [observations(1:length(observations)/2,:)];
    SO = [observations(length(observations)/2 + 1 :length(observations),:)];
    [A, E] = hmmestimate(TO, TS, 'SYMBOLS', unique(observations, 'rows'));
    pStates = hmmdecode(S, A);
    mc = dtmc(A);
    figure;
    graphplot(mc);
end
