function [traindata, testdata] = splitdataset(observ_seq, state_seq, feat, proportion)  
    if nargin < 1
        [observ_seq, state_seq, feat] = get_all_data();
        proportion = 0.1;
    end
    
    rng('shuffle','twister');
    
    group = findgroups(state_seq); %group data based on the different states
    C = cvpartition(group, 'HoldOut', proportion); %partion
    
    %traing data
    trIdx = training(C);
    traindata.observ = observ_seq(trIdx, :);
    traindata.state = state_seq(trIdx, :);
    traindata.feat = feat;
    
    %test data
    teIdx = test(C); 
    testdata.observ = observ_seq(teIdx, :); 
    testdata.state = state_seq(teIdx, :); 
    testdata.feat = feat;
end