function [ES2, ET2] = knn_with_featsel(datapath, foot, num_feat_out)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat'; 
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
    
    A = featselect(datapath, foot, num_feat_out);

    [T1, S1] = gendat(A*pcam(A,2), 0.5);
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

              
%     axis(V2);
%     plotc(W2);                  

    DS2 = S2*W2;                   
    ES2 = DS2*testc;              
    labs2 = getlabels(S2);        
    labsc2 = DS2*labeld;            
%     disp([labs2 labsc2]);

%     delfigs                      % delete existing figures

%     figure;
%     scatterd(T1);
%     axis equal
%     plotc(W1); 

%     figure;
%     scatterd(T2);
%     axis equal

% % Test Error
%     figure;
%     scatterd(S1);              
% %     axis(V1);
%     plotc(W1);  
    
%     figure;
%     scatterd(S2);
    
%     M1 = knn_map(S1, W1);
%     M2 = knn_map(S2, W2);
%     showfigs;
end