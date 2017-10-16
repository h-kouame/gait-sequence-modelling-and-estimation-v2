function [overall_accuracy, overall_knn_accuracy, hmm_accuracy, Q, logP] = chmmpredict(hmmpath, knnpath, testdatapath)
    if nargin < 1
        hmmpath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\HMM\CHMM'; 
        knnpath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\KNN\KNN.mat';
        testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';     
    elseif nargin < 2
        knnpath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\KNN\KNN.mat';
        testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';  
    elseif nargin < 3
        testdatapath =  'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat'; 
    end
        
%     Load HMM
    CHMM = load(hmmpath);
    A = CHMM.A;
    B = CHMM.B;
    
%     Load KNN for dimension reduction
    KNN = load(knnpath);
    LF_KNN = KNN.LF_KNN;
    RF_KNN = KNN.RF_KNN;
    LB_KNN = KNN.LB_KNN;
    RB_KNN = KNN.RB_KNN;
    
%     Dimension reduction with individual KNN
    LF_IMU_dataset = getdataset(testdatapath, 'LF');
    LF_dim_red = LF_IMU_dataset*LF_KNN;
    LF_ground_truth = getlabels(LF_IMU_dataset);        
    LF_knn_output = LF_dim_red*labeld;
    LF_knn_accuracy = sum(LF_ground_truth == LF_knn_output)/length(LF_knn_output)
    
    RF_IMU_dataset = getdataset(testdatapath, 'RF');
    RF_dim_red = RF_IMU_dataset*RF_KNN;
    RF_ground_truth = getlabels(RF_IMU_dataset);        
    RF_knn_output = RF_dim_red*labeld;
    RF_knn_accuracy = sum(RF_ground_truth == RF_knn_output)/length(RF_knn_output)
    
    LB_IMU_dataset = getdataset(testdatapath, 'LB');
    LB_dim_red = LB_IMU_dataset*LB_KNN;
    LB_ground_truth = getlabels(LB_IMU_dataset);        
    LB_knn_output = LB_dim_red*labeld;
    LB_knn_accuracy = sum(LB_ground_truth == LB_knn_output)/length(LB_knn_output)
    
    RB_IMU_dataset = getdataset(testdatapath, 'RB');
    RB_dim_red = RB_IMU_dataset*RB_KNN;
    RB_ground_truth = getlabels(RB_IMU_dataset);        
    RB_knn_output = RB_dim_red*labeld;
    LF_knn_accuracy = sum(LF_ground_truth == RB_knn_output)/length(RB_knn_output)
    
%   discrete observations sequence before knn: ground truth
    feat2observ = strcat(LF_ground_truth, RF_ground_truth, LB_ground_truth, RB_ground_truth);
    seq_observ =  bin2dec(feat2observ) + 1; % states range from 1 to 16
    
%   discrete observations sequence from knn after dimension reduction
    knn_feat2observ = strcat(LF_knn_output, RF_knn_output, LB_knn_output, RB_knn_output);
    knn_seq_observ =  bin2dec(knn_feat2observ) + 1; % states range from 1 to 16
    
%     predict best possible state path
    [Q, logP] = hmmviterbi(knn_seq_observ, A, B);
    
%     Accuracies
    overall_knn_accuracy = 100*sum(knn_seq_observ == seq_observ)/length(knn_seq_observ)
    hmm_accuracy = 100*sum(knn_seq_observ == Q.')/length(knn_seq_observ)
    overall_accuracy = 100*sum(seq_observ == Q.')/length(seq_observ)
end