function chmmvisualise(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';  
    end
    delfigs;
    [A, B] = chmm(datapath);
    stateNames = ["S1" "S2" "S3" "S4" "S5" "S6" "S7" "S8" "S9" "S10" "S11" "S12" "S13" "S14" "S15" "S16"];
    mc = dtmc(A, 'StateNames', stateNames);
    
    figure;
    imagesc(A);
    colormap(jet);
    colorbar;
    axis square
    h = gca;
    N = length(A);
    h.XTick = 1:N;
    h.YTick = 1:N;
    title 'Transition Matrix Heat Map of HMM';

%     Directed Graphs
%     A directed graph, or digraph, shows the states in the chain as nodes and feasible transitions between states as directed edges. 
%     A feasible transition is a transition whose probability of occurring is greater than zero.
    figure; 
    graphplot(mc, 'ColorEdges',true, 'ColorNodes',true); 
    title 'Directed graph of HMM';
    
%     An eigenvalue plot shows eigenvalues on the complex plane. eigplot returns an eigenvalue plot and identifies:

%     =>The Perron-Frobenius eigenvalue, which is guaranteed for nonnegative matrices, using a bold asterisk.
%     =>The spectral gap, which is the area between the radius with length equal to the second largest eigenvalue magnitude (SLEM) and the radius with a length of one.
%     Plot an eigenvalue plot of the Markov chain. Return the eigenvalues of the transition matrix.
    figure;
    %Possible interpretation: Two eigenvalue roots are one indicating that the Markov chain has a period of two
    eVals = eigplot(mc)
    title 'Eigen Plot of HMM';
    
%     Redistribution Plots
%     A redistribution plot graphs of the state redistributions  from an initial distribution. Specifically, ...formulae
%     displot plots redistributions, but requires redistribution data generated by redistribute and the Markov chain object. 
%     You can plot the redistributions as a static heat map or as animated histograms or digraphs.

%     Generate a ten-step redistribution from the initial distribution .   
    figure; 
    numSteps = 10;
    x0 = ones(1, N)/N;
    X = redistribute(mc, numSteps, 'X0', x0);
    
%   Interpretation of the plot below from Matlab: 
%   Because regimes 1 and 2 are transient, the Markov chain eventually concentrates the probability to regimes 3 and 4. 
%   Also, as the eigenvalue plot suggests, there appears to be a period of 2 in those states.
    distplot(mc,X);
    title 'Redistributions as a heat map';   

%     Plot an animated histogram. Set the frame rate to two seconds.
    figure;
    distplot(mc,X,'Type','histogram','FrameRate', 2);
    title 'Animated histogram of distribution of states';
    
%     A simulation plot graphs of random walks through the Markov chain starting at particular initial states. 
%     simplot plots the simulation, but requires simulation data generated by simulate and the Markov chain object. 
%     You can plot the simulation as a static heat map displaying the proportion of states reached at each step or 
%     a heat map of the realized transition matrix, 
%     or as animated digraph showing the realized transitions.

%     Generate 100, ten-step random walks, where each state initializes the walk 25 times.
    x0 = ones(1, N)*25;
    X = simulate(mc,numSteps,'X0',x0);
    
%     Plot the simulation as a heat map showing the proportion of states reached at each step.
    figure;
    simplot(mc,X);
    
%     Plot a heat map of the realized transition matrix.
    figure;
    simplot(mc,X,'Type','transition');
end