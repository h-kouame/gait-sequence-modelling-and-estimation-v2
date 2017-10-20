function [prior, mu, Sigma, loglik] = gmmodel(datapath)
    if nargin < 1
        datapath = 'C:\School\EEE4022S\Gait Sequence Estimation\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat'; 
    end
    
%     data = load(datapath);
    mix_num = 16;%size(unique([data.LF, data.RF, data.LB, data.RB], 'rows'), 1);
    seq_observ = getseqs(datapath);
    [prior, mu, Sigma, loglik] = Gmm(seq_observ, mix_num);
    [p_start, A, phi, loglik] = ChmmGauss(seq_observ, mix_num, 'p_start0', p_start0, 'A0', A0, 'phi0', phi0, 'cov_type', 'diag', 'cov_thresh', 1e-1);
end