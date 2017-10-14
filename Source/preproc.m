function P = preproc(data_file)
        data = load(data_file);
        O = [data.LF data.RF data.LB data.RB];
        S = {};
        P = {};
        for i = 1:size(O)
            o = O(i);
            if ~ismember(o, S)
                S = [S, o];
                P = [P, [o {}]]
            if i > 1 :
                P = [P, [S {}]];
            end
        end       

        for i = 1:size(S)
            s = S(s);
            
end
            