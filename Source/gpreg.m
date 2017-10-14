function [G] = gpreg(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
    end
    
    rng(0,'twister');
%        datapath2 = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';
%        [O1, M1, D] =  preprocess(datapath);
%        [O2, M2, D] =  preprocess(datapath2);
%        O = [O1; O2];
%        M = [M1; M2];

       [O, M] = preprocess(datapath);
      
      % 2. Fit the model using 'exact' and predict using 'exact'.
      G = fitrgp(O, M,'Basis','linear','Optimizer','QuasiNewton',...
                   'verbose',1,'FitMethod','exact','PredictMethod','exact');

      % 3. Plot results.
      scatter(O, M,'b');
      hold on;
      scatter(O, resubPredict(G),'r', 'filled');
      xlabel('O');
      ylabel('M');
      legend('Data','GPR fit');
end