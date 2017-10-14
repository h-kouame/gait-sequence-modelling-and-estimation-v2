datapath = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';
data = load(datapath);
fields = {'numFrontCRC', 'numBackCRC', 'LF', 'LB', 'RF', 'RB'};
D = rmfield(data, fields);
fns = fieldnames(D);

front_fns = fns(1);
for i = 3:8
    front_fns = [front_fns, fns(i)];
end

back_fns = fns(2);
for i = 9:length(fns)
    back_fns = [back_fns, fns(i)];
end

[A, O] = preprocess(datapath);
clf;
figure
subplot(2,2,[1 2])
title('All Measurements')
legends = {};
for i = 1:length(fns)
    M = D.(fns{i});
    for j = 1: size(M, 2)
        legends = [legends, fns{i}];
        scatter(O, M(:, j), 'filled');
        hold on;
    end
end
xlabel('State');
ylabel('Observation');
legend(legends);

subplot(2,2,3)
title('Front Measurements')
legends = {};
for i = 1:length(front_fns)
    M = D.(front_fns{i});
    for j = 1: size(M, 2)
        legends = [legends, front_fns{i}];
%         scatter(O, M(:, j), colours{mod(i + j, 4)+1});
        scatter(O, M(:, j), 'filled');
        hold on;
    end
end
xlabel('State');
ylabel('Observation');
legend(legends);

subplot(2,2,4)
title('Back Measurements')
legends = {};
for i = 1:length(back_fns)
    M = D.(back_fns{i});
    for j = 1: size(M, 2)
        legends = [legends, back_fns{i}];
%         scatter(O, M(:, j), colours{mod(i + j, 4)+1});
        scatter(O, M(:, j), 'filled');
        hold on;
    end
end
xlabel('State');
ylabel('Observation');
legend(legends);

