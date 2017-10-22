function B = footfeatselect(datapath, foot, num_feat_out)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        foot = 'LF';
        num_feat_out = 3;
    elseif nargin < 2
        foot = 'LF'; 
        num_feat_out = 3;
    elseif nargin < 3 
        num_feat_out = 3;
    end
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducability
    
    cross_val_fold = 3;
    A = getdataset(datapath, foot);
    A = setname(A, 'original dataset');
    [T, S] = gendat(A, 0.5);   
    knn = knnc([]);
    [W, R] = featseli(A, 'NN', num_feat_out, T); 
    W = setname(W,'ISel NN');
    feat_out = +W;
    B = A*featsel(feat_out);
    B = setname(B, 'output dataset');
    
    disp(W.labels);
    
    V = T*(W*knn);       % use train set also for classifier training
    1 - S*V*testc            % show test results

%     delfigs                      % delete existing figures
    figure; scatterd(A, 'legend');
    figure; scatterd(B, 'legend');
    showfigs;
% %     disp(W.DATA)
end