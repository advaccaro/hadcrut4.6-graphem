%pseudoworld1_lsat_graphem_sp_step0.m

%% INITIALIZE
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')

odir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/pseudoworld1/lsat/data/';


N = 500; %Number of regularization parameters (start w/ high value to obtain upper limit)

target_vals = [3.25:.25:4.5]; %target sparsities (start w/ high value to obtain upper limit)
nvals = length(target_vals);


%% Calcualte sample covariance matrix from previosuly infilled dataset
%infilled data
load('pseudoworld1_lsat_graphem_cr800_step2.mat')

tfrac = PW1_lsat.tfrac;
tcal = tfrac(tfrac >= 1960 & tfrac < 1991); %calibration period 1960-1990
calib = ismember(tfrac,tcal);
Xcal = Xf(calib,:);
S = corrcoef(Xcal); %sample covariance matrix

for k = 1:nvals
	target_spars = target_vals(k);
	adjtag = [odir 'pseudoworld1_lsat_adj_sp' num2str(target_spars*100) '.mat'];

	
	[spars,adj] = greedy_search_TT(S,target_spars,N);
	spars_f = spars(end); adjM = adj{end};
	
	save(adjtag, 'spars_f', 'adjM', 'target_spars')
end
