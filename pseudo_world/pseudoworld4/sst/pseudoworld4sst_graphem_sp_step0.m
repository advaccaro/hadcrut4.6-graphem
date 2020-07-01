%pseudoworld4sst_graphem_sp_step0.m


%% INITIALIZE
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.2/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')

odir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';

N = 100;
target_vals = [.5:.5:5];
nvals = length(target_vals);

load('pseudoworld4_sst.mat')
sst_f = PW4_sst.grid_2d;
ocean = ~isnan(sst_f(1,:));
sst_o = sst_f(:,ocean);


tser = double(PW4_sst.time) + datenum('1850-1-1');
tvec = datevec(tser);
tfrac = tvec(:,1)+tvec(:,2)/12-1/12;
tcal = tfrac(tfrac>=1960 & tfrac < 1991);
calib = ismember(tfrac,tcal);
Xcal = sst_o(calib,:);
S = corrcoef(Xcal);


for k = 1:nvals
	target_spars = target_vals(k);
	adjtag = [odir 'PW4_sst_adj_sp' num2str(target_spars*100) '.mat'];

	
	[spars,adj] = greedy_search_TT(S,target_spars,N);
	spars_f = spars(end); adjM = adj{end};
	
	save(adjtag, 'spars_f', 'adjM', 'target_spars')
end
