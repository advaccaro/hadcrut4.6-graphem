% cci_graphem_sp_CV.m

function cci_graphem_sp(target_spars)

	tic;

	data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
	odir = data_dir; %writing to input directory, for now

	% Load CCI data
	datapath = [data_dir 'cci_combined_include_ice.mat'];
	raw = load(datapath);
	Xraw = raw.cci_anom;
	[nt,ns] = size(Xraw);

	% Compute adjacency matrix and well-conditioned C
	% adj_path = [data_dir 'adj_SPCV_sp' num2str(target_spars*100) '.mat'];
	% load(adj_path)


	C0 = corr(Xraw);
	greedy_maxit = 50;

	%Sigma_G options
	sigma_opt.ggm_tol = 5e-3;
	sigma_opt.ggm_maxit = 200;
	sigma_opt.ggm_thre = 50;
	sigma_opt.adj = 0; %placeholder

	[spars, adj] = greedy_search_TT(C0, target_spars, greedy_maxit);
	spars_f = spars(end);
	adjM = adj{end};

	% Product well-conditioned C
	sigma_opt = rmfield(sigma_opt, 'adj');
	sigma_opt.adj = adjM;
	[Cw,sp_level] = Sigma_G(C0,sigma_opt);
	adjpath = [odir 'cci_graphem_sp' num2str(target_spars * 100) '_adj.mat'];
	save(adjpath, 'adjM', 'Cw', 'target_spars', 'spars_f')


	% GraphEM options
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	opt.adj = adjM;
	opt.C0 = Cw;


	% Run GraphEM
	[Xg,Mg,Cg] = graphem(xraw,opt);

	SPtag = ['cci_graphem_sp' num2str(target_spars*100) '.mat'];
	SPpath = [odir SPtag];

	savepath = [odir SPpath];
	save(savepath, 'Xg' ,'Mg' ,'C')
	