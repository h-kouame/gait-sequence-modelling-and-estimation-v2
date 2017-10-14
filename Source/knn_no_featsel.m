function [ET2, ES2] = knn_no_featsel(datapath, foot)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat'; 
        foot = 'LF';
    elseif nargin < 2
        foot = 'LF';   
    end
    
    prwaitbar off                % waitbar not needed here
    randreset(1);                % takes care of reproducability
    
    A = getdataset(datapath, foot);
    [T1, S1] = gendat(A*pcam(A,4), 0.5);
    [T2, S2] = gendat(A, 0.5);
    
    T1 = setname(T1, 'Training Set with PCA'); 
    S1 = setname(S1, 'Test Set with PCA'); 
    T2 = setname(T2, 'Training Set without PCA'); 
    S2 = setname(S2, 'Test Set without PCA');
    
    W1 = knnc(T1);
    W2 = knnc(T2);                    

% Apparant/ Traininging Error
    DT1 = T1*W1;                   
    ET1 = DT1*testc;             
    labt1 = getlabels(T1);         
    labtc1 = DT1*labeld;            % estimated labels of classified Traininging set
%     disp([labt1 labtc1]);         
    

%     plotc(W2);                    can't plot in 18 dimensions
%     V2 = axis;

    DT2 = T2*W2;                   
    ET2 = DT2*testc;                
    labt2 = getlabels(T2);         
    labtc2 = DT2*labeld;           
%     disp([labt2 labtc2]);         

    
                 

    DS1 = S1*W1;                   
    ES1 = DS1*testc;              
    labs1 = getlabels(S1);        
    labsc1 = DS1*labeld;            
%     disp([labs1 labsc1]);  

                              

    DS2 = S2*W2;                   
    ES2 = DS2*testc;              
    labs2 = getlabels(S2);        
    labsc2 = DS2*labeld;    
    
%     delfigs                      % delete existing figures
%     figure;
%     scatterd(T1);
%     axis equal
%     plotc(W1);
%     
%     % Test Error
%     figure;
%     scatterd(S1);              
% %     axis(V1);
%     plotc(W1); 
%     
%     figure;
%     scatterd(T2);
%     axis equal
%     
%     figure;
%     scatterd(S2); 
%     
% %     disp([labs2 labsc2]);
% 
    fprintf('The apparent performance with PCA: %4.2f \n', 1-ET1);
    fprintf('The apparent performance without PCA: %4.2f \n', 1-ET2);
    fprintf('The test performance with PCA: %4.2f \n', 1-ES1);
    fprintf('The test performance without PCA: %4.2f \n', 1-ES2);
%     
    M1 = knn_map(S1, W1);
    M2 = knn_map(S2, W2);
    showfigs;
end