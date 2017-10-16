function [LF_KNN, RF_KNN, LB_KNN, RB_KNN] = knn_no_featsel_all_legs(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
    end
    
    prwaitbar off                % waitbar not needed here
%     delfigs                      % delete existing figures
    randreset(1);                % takes care of reproducability

    %LF
    A1 = getdataset(datapath, 'LF');
    [T1, S1] = gendat(A1, 0.5);
    T1 = setname(T1,'LF Training Set'); 
    S1 = setname(S1,'LF Test Set');
    LF_KNN = knnc(T1);
    %Test Error
    DS1 = S1*LF_KNN;                                
    labs1 = getlabels(S1);        
    labsc1 = DS1*labeld;
    
    %RF
    [A2] = getdataset(datapath, 'RF');
    [T2, S2] = gendat(A2, 0.5);
    T2 = setname(T2,'RF Training Set'); 
    S2 = setname(S2,'RF Test Set');
    RF_KNN = knnc(T2);
    %Test Error
    DS2 = S2*RF_KNN;
    labs2 = getlabels(S2);        
    labsc2 = DS2*labeld;
    
    %LB
    [A3] = getdataset(datapath, 'LB');
    [T3, S3] = gendat(A3, 0.5);
    T3 = setname(T3,'LB Training Set'); 
    S3 = setname(S3,'LB Test Set');
    LB_KNN = knnc(T3);
    %Test Error
    DS3 = S3*LB_KNN;
    labs3 = getlabels(S3);        
    labsc3 = DS3*labeld;
    
    %RB
    [A4] = getdataset(datapath, 'RB');
    [T4, S4] = gendat(A4, 0.5);
    T4 = setname(T4,'RB Training Set'); 
    S4 = setname(S4,'RB Test Set');
    RB_KNN = knnc(T4);
    %Test Error
    DS4 = S4*RB_KNN;
    labs4 = getlabels(S4);        
    labsc4 = DS4*labeld;  
    
    min_length = min(min(min(length(labs1), length(labs2)), length(labs3)), length(labs4));
    labs = strcat(labs1(1:min_length), labs2(1:min_length), labs3(1:min_length), labs4(1:min_length));
    labsc = strcat(labsc1(1:min_length), labsc2(1:min_length), labsc3(1:min_length), labsc4(1:min_length));
    disp(sum(labs == labsc)/min_length);
    
    %  Save HMM parameters
   filepath = 'C:\School\EEE4022S\Gait Sequence Estimation\Output\KNN\';
%    datestamp = string(datetime('now','TimeZone','local','Format','yyyyMMdd_HHmmss'));
%    filename = strcat(filepath ,'CHMM_' , datestamp, '.mat');
   filename = strcat(filepath ,'KNN', '.mat');
   save(filename, 'LF_KNN', 'RF_KNN', 'LB_KNN', 'RB_KNN');
end