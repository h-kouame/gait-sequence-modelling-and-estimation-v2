function [E] = all_knn_no_featsel(foot)
    if nargin < 1
        foot = 'LF';
    end
    common_path = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\';
    files = dir(strcat(common_path, '*.mat'));

    delfigs;
    E = [];
%     fprintf("Filename          |         Training Error      |      Test Error\n");
    for f = 1:size(files)
        file = files(f);
        filepath = strcat(common_path, file.name);
        try
            [ET, ES] = knn_no_featsel(filepath, foot);
%             fprintf(file.name, '\n');
%             disp([ET ES]);
            E = [E; [ET, ES]];
        catch 
        end
    end
    E = 1-E;
end