function [model, sel_data] = FullSearch_BuildGmmHMM(data)
    if nargin < 1
        [data.observ, data.state, data.feat] = get_all_data();
    end
    
    sel_data = fullsearch_featselect(data);  %use deterministic %     result below
%     feat_out = {'magBack_cal2'; 'FrontRoll'; 'magFront_cal3'; 'BackYaw'};
%     sel_observ = get_selected_features(data.observ, data.feat, feat_out);
    model = BuildGmmHMM(sel_data.observ, sel_data.state);
end