function featselect_all_legs(datapath, num_feat_out)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
        num_feat_out = 3;
    elseif nargin < 2
        num_feat_out = 3;
    end
    delfigs                      % delete existing figures
    fprintf('\nOptimal features for each Foot:\n\n'); 
    fprintf('Left Front:\n');
    footfeatselect(datapath, 'LF', num_feat_out);
    fprintf('\nRight Front:\n'); 
    footfeatselect(datapath, 'RF', num_feat_out);
    fprintf('\nLeft Back:\n'); 
    footfeatselect(datapath, 'LB', num_feat_out);
    fprintf('\nRight Back:\n'); 
    footfeatselect(datapath, 'RB', num_feat_out); 
    
    showfigs;
end