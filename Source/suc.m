folder = 'Successors/';
files = dir(strcat(folder, '*.csv'));
P = [];
sizes = [];
for f = 1:size(files)
    file = files(f);
    filepath = strcat(folder, file.name);
    p = getpredec(filepath);
    P = [P; p];
    sizes = [sizes, length(p)];
end

labels = char('S4', 'S5', 'S6', 'S7', 'S9', 'S10', 'S11', 'S13', 'S14', 'S15');
L = genlab(sizes, labels);
%prtool dataset
D = prdataset(P, L);
%prior knowledge of the data: use number of occurences
priors = sizes./size(P, 1);
D = setprior(D, priors);
%features
D = setfeatlab(D, char('LF', 'RF', 'LB', 'RB'));

%split data into training set and test set
[t,s] = gendat(D, 0.5); % OR ??? [t,s] = gendat(D*pcam(D,2), 0.5);

%build classifier with training set
[w, k, e] = knnc(t);

%get the available states from the data
states = getpredec('states.csv');
%define dataset of states to build the transition matrix for
S = prdataset(states, char('States'));

%map knn classifAier to available states
M = knn_map(S, w); % OR ?? F = knn_map(S*pcam(S,2), w);

%get transition states
A = +M;

%test classifier with test dataset
T = s*w;
%get test error
[E, C] = T*testc;
diff = [getlabels(s) T*labeld];
disp(A);
disp(w)
disp(E);
disp(C);
%disp(F)

% figure; 
scatterd(D*pcam(D,2),'legend');
colorbar;
%scatterdui(A*pcam(A))
% plotc(w, 'col'); %showfigs;
plotm(w, 1);