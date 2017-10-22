function observs = getstatesdata(observ_seq, state_seq) 
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        [observ_seq, state_seq] = getfrontdata(datapath);   
    end
    
    O1 = [];
    O2 = [];
    O3 = [];
    O4 = [];
    
    for i = 1:length(state_seq)
        state = state_seq(i);
        observ = observ_seq(i, :);
        switch state
            case 1
                O1 = [O1; observ];
            case 2
                O2 = [O2; observ];
            case 3
                O3 = [O3; observ];
            case 4
                O4 = [O4; observ];
        end
    end
    
    observs{1} = O1;
    observs{2} = O2;
    observs{3} = O3;
    observs{4} = O4;
        
end