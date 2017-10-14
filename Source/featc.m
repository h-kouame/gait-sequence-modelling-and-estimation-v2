folder = 'Successors/';
files = dir(strcat(folder, '*.csv'));
P = [];
sizes = [];
W = {};
%define dataset of states to build the transition matrix for
C = prdataset([1; 0], char('Footfall'));
for f = 1:size(files, 1)
    file = files(f);
    filepath = strcat(folder, file.name);
    data = getpredec(filepath);
    
    W_ = {};
    for i = 1:4 
        feature = data(:, i);
        H = [];
        L = [];
        for j = 1:size(feature)
            elt = data(j);
            if elt == 1
                H = [H; elt];
            else
                L = [L; elt];
            end
        end
        sizes = [size(H, 1), size(L, 1)];
        labels = genlab(sizes, char('High', 'Low'));
        %prtool dataset
        D = prdataset([H; L], labels);
        %prior knowledge of the data: use number of occurences
        %priors = sizes./size(data, 1);
        D = setprior(D, 0);
        %features
        D = setfeatlab(D, char('Foot'));

        %split data into training set and test set
        [t,s] = gendat(D, 0.5); % OR ??? [t,s] = gendat(D*pcam(D,2), 0.5);

        %build classifier with training set
        [w, k, e] = knnc(t);
        W_ = {W_, w};
        
        %test classifier with test dataset
        T = s*w;
        %get test error
%         error = T*testc;
%         diff = [getlabels(s) T*labeld];
%         disp(A);
        disp(w)
        disp(error);
    end
    W = {W; W_};
    

% 
%     %map knn classifAier to available states
%     F = knn_map(C, w); % OR ?? F = knn_map(S*pcam(S,2), w);
% 
%     %get transition states
%     A = +F;
% 

% 
%     % figure; 
%     scatterd(D,'legend');
%     colorbar;
%     %scatterdui(A*pcam(A))
%     % plotc(w, 'col'); %showfigs;
%     plotm(w, 1);
end