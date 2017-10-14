function [E] = all_knn_with_featsel(foot)
    if nargin < 1
        foot = 'LF';
    end
    common_path = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls';
    files = dir(strcat(common_path, '*.mat'));

    prwaitbar off                % waitbar not needed here
    delfigs                      % delete existing figures
    randreset(1);                % takes care of reproducability
    
    E = [];
%     fprintf("Filename          |         Training Error      |      Test Error\n");
    num_feat = 13;
    for f = 1:size(files)
        file = files(f);
        filepath = strcat(common_path, file.name);
        try
            [ES, ET] = knn_with_featsel(filepath, foot, num_feat);
%             fprintf(file.name, '\n');
%             disp([ET ES]);
            E = [E; [ES, ET]];
        catch 
        end
    end
    E = 1-E;
end