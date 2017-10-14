[A, O] = preprocess();
[T, S] = gendat(A, 0.5);     
[W1, R1] = A*featseli([],'NN',3, T); W1 = setname(W1,'ISel NN'); 
disp(+W1);
V = T*(W1*knnc);   % train all selectors and classifiers
S*V*testc
% classes = [];
% feat_num = size(O, 2);
% for i = 1:feat_num
%     classes = [classes; O(:, i)];
% end
% sizes(1, 1:feat_num) = size(O, 1);
% labels = genlab(sizes, getfeatlab(D));
% featureset = prdataset(classes, labels);
% w = fisherm(D, 3);
% figure;plotm(w);