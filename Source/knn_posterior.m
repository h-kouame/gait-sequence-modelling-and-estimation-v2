function [posteriors] = knn_posterior(knnpath, datapath, foot)    
    if nargin < 1
        knnpath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\KNN\KNN.mat';
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';   
        foot = 'LF';
    elseif nargin < 2
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        foot = 'LF'; 
    elseif nargin < 3
        foot = 'LF';
    end
    
    knn_model = load(knnpath);
    KNN = knn_model.LF_KNN;
    switch foot
        case 'RF'
            KNN = knn_model.RF_KNN;
        case 'LB'
            KNN = knn_model.LB_KNN;
        case 'RB'
            KNN = knn_model.RB_KNN;
    end
  
    O = getseqs(datapath, foot);
    dataset = prdataset(O);
%     dataset = gendat(dataset, 1);
    posteriors = dataset*KNN;
end