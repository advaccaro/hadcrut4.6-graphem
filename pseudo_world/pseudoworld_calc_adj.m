function adjM = pseudoworld_calc_adj(dataset, datatype, worldnum, target_spars)
	home_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
	addpath(genpath(home_dir))
	raw = load(dataset)
	PW = identifyPW(raw, worldnum, datatype);
	[nt,ns] = size(PW.grid_2d);

	% select points with > (1/Kcv)% coverage
	worldname = ['pseudoworld' num2str(worldnum)];
	fullname = [worldname '_' datatype];
	basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
	odir = [basedir worldname '/' datatype '/data/'];

	kcv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
	kcv_indices_path = [odir kcv_indices_tag];
	K = load(kcv_indices_path);
	index = K.index;

	Xgrid = PW.grid_2d(:,index);

	cwspath = [homedir 'cw17/data/cw17_short.mat'];
	load(cwspath);
	cw17s_red = cws.temp2d(:,index);
	C0 = corr(cws17_red);
	% greedy_maxit = 50;

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

	% Save adjM and Cw
	adjtag = [worldnum '_' datatype '_sp' num2str(target_spars*100) '_adj.mat'];
	adjpath = [odir adjtag];
	save(adjpath, 'spars_f', 'adjM', 'Cw', 'target_spars')
end
