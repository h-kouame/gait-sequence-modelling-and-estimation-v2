function  all_knn_no_featsel_all_legs()
    common_path = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\';
    files = dir(strcat(common_path, '*.mat'));

    delfigs;
    E = [];
%     fprintf("Filename          |         Training Error      |      Test Error\n");
    for f = 1:size(files)
        file = files(f);
        filepath = strcat(common_path, file.name);
        try
            knn_no_featsel_all_legs(filepath);
%             fprintf(file.name, '\n');
%             disp([ET ES]);
        catch 
        end
    end
    E = 1-E;
end