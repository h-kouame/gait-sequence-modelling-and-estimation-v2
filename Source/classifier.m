function [ET2, ES2] = classifier(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
    end
    [A] = preprocess(datapath);
    
    prwaitbar off                % waitbar not needed here
    delfigs                      % delete existing figures
    randreset(1);                % takes care of reproducability

    [T1, S1] = gendat(A*pcam(A,2), 0.5);
    [T2, S2] = gendat(A, 0.5);
    
    T1 = setname(T1,'Train Set with PCA'); 
    S1 = setname(S1,'Test Set with PCA'); 
    T2 = setname(T2,'Train Set without PCA'); 
    S2 = setname(S2,'Test Set without PCA');
    
    W1 = knnc(T1);
    W2 = knnc(T2);
    
    figure;
    scatterd(T1);
    axis equal
    plotc(W1);                    
    V1 = axis;

% Apparant/ Training Error
    DT1 = T1*W1;                   
    ET1 = DT1*testc;             
    labt1 = getlabels(T1);         
    labtc1 = DT1*labeld;            % estimated labels of classified training set
%     disp([labt1 labtc1]);         
    
    figure;
    scatterd(T2);
    axis equal
%     plotc(W2);                    can't plot in 18 dimensions
    V2 = axis;

    DT2 = T2*W2;                   
    ET2 = DT2*testc;                
    labt2 = getlabels(T2);         
    labtc2 = DT2*labeld;           
%     disp([labt2 labtc2]);         

    
% Test Error
    figure;
    scatterd(S1);              
    axis(V1);
    plotc(W1);                  

    DS1 = S1*W1;                   
    ES1 = DS1*testc;              
    labs = getlabels(S1);        
    labsc = DS1*labeld;            
%     disp([labs labsc]);  

    figure;
    scatterd(S2);              
    axis(V2);
%     plotc(W2);                  

    DS2 = S2*W2;                   
    ES2 = DS2*testc;              
    labs = getlabels(S2);        
    labsc = DS2*labeld;            
    disp([labs labsc]);

%     fprintf('The apparent error with PCA: %4.2f \n', ET1);
%     fprintf('The apparent error without PCA: %4.2f \n', ET2);
%     fprintf('The test error with PCA: %4.2f \n', ES1);
%     fprintf('The test error without PCA: %4.2f \n', ES2);
    
    M1 = knn_map(S1, W1);
    M2 = knn_map(S2, W2);
    showfigs;
end