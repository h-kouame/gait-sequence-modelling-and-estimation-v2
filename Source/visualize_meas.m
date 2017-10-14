datapath = 'C:\School\EEE4022S\DataSets\calibrated_data_with_footfalls\Data_Test6(Walk1).mat';

D = preprocess(datapath);

scatterd(D, 'legend');
