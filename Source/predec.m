folder = 'Predecessors/';
files = dir(strcat(folder, '*.csv'));
P = [];
for f = 1:size(files)
    file = files(f);
    filepath = strcat(folder, file.name);
    p = getpredec(filepath);
    P = [P; p];
end

L = genlab( [4 247 60 60 17 244 85 94 96 6], char('S4', 'S5', 'S6', 'S7', 'S9', 'S10', 'S11', 'S13', 'S14', 'S15'));
D = prdataset(P, L);
D = setprior(D,0);
scatterd(D*pcam(D,2));
[t,s] = gendat(D*pcam(D,2),0.);
u = knnc([], 10);
w = t*u;
plotc(w);
dt = s*w;
error = dt*testc;
disp(error);