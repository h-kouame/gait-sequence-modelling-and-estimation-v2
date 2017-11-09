function accuracy = evaluate(ground_truth, estimation)
    accurate_estimation = sum(ground_truth == estimation) + count_wrong_transitions(ground_truth, estimation);
    accuracy = 100 * accurate_estimation/size(ground_truth, 1);
end

function count = count_wrong_transitions(ground_truth, estimation)
    count = 0;
    for i = 1:size(ground_truth, 1) - 2
        if ((ground_truth(i) ~= ground_truth(i + 1) || estimation(i) ~= estimation(i + 1)) ... % transition in ground_truth or estimation
           && (ground_truth(i + 1) ~= estimation(i + 1))... % estimation lagged or led the transition
           && (ground_truth(i + 2) == estimation(i + 2)) ... %  by just one step, i.e, it got it correct in the next step
           && (ground_truth(i + 1) == ground_truth(i + 2) || estimation(i + 1) == estimation(i + 2))) %make sure it was just a transition in ground truth or in estimation
            count = count + 1;
        end
    end
end