%pseudoworld_graphem_sp_CV.m
function pseudoworld_graphem_sp_CV_kn(dataset,datatype,worldnum,target_spars,Kcv)
	k = Kcv;
	% Cross-validation of target sparsity for GraphEM w/ GLASSO
	tic

	%% Initialize
	homedir = '/home/ubuntu/hadcrut4.6-graphem/';
	addpath(genpath(homedir))

	worldname = ['pseudoworld' num2str(worldnum)];
	fullname = [worldname '_' datatype];
	basedir = '/home/ubuntu/hadcrut4.6-graphem/pseudo_world/';
	odir = [basedir worldname '/' datatype '/data/'];

	% Load raw data data matrix
	raw = load(dataset);
	PW = identifyPW(raw, worldnum, datatype);

	% Load KCV indices
	kcv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
	kcv_indices_path = [odir kcv_indices_tag];
	K = load(kcv_indices_path);

	% Load adjacency matrix and well-conditioned C
	index = K.index;


	Xgrid = PW.grid_2d(:,index);

	C0 = corr(Xcv{k});
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


	% GraphEM options
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	opt.adj = adjM;
	opt.C0 = Cw;

	for k = Kcv
		SPkfoldtag = [fullname '_CV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
		SPkfoldpath = [odir SPkfoldtag];
		% if ~complete
		% Run GraphEM
		[Xg,Mg,Cg] = graphem(double(Xcv{k}),opt);
		Xg_k = Xg;
		save(SPkfoldpath, 'Xg_k', 'target_spars', 'adjM')
		% else
		% 	load(SPkfoldpath)
		% 	Xg{k} = Xg_k;
		clear Xg_k
		end
end
