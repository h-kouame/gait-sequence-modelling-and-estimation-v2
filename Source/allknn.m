function [E] = allknn()
    common_path = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls';
    files = dir(strcat(common_path, '*.mat'));

    E = [];
%     fprintf("Filename          |         Training Error      |      Test Error\n");
    for f = 1:size(files)
        file = files(f);
        filepath = strcat(common_path, file.name);
        try
            [ET, ES] = classifier(filepath);
            fprintf(file.name, '\n');
            disp([ET ES]);
            E = [E; [ET, ES]];
        catch 
        end
    end
end