function [G] = gpreg(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
    end
    
    rng(0,'twister');
%        datapath2 = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test7(Trot then Walk-transition at around 320).mat';
%        [O1, M1, D] =  preprocess(datapath);
%        [O2, M2, D] =  preprocess(datapath2);
%        O = [O1; O2];
%        M = [M1; M2];

       [D, O, S] = preprocess(datapath);
      
      % 2. Fit the model using 'exact' and predict using 'exact'.
      G = fitrgp(S, O(:, 1),'Basis','linear','Optimizer','QuasiNewton',...
                   'verbose',1,'FitMethod','exact','PredictMethod','exact');

      % 3. Plot results.
      scatter(S, O(:, 1), 'b');
      hold on;
      scatter(S, resubPredict(G),'r', 'filled');
      xlabel('States');
      ylabel('Measurement');
      legend('Data', 'GPR fit');
end