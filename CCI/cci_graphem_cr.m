% cci_graphem_cr.m

function cci_graphem_cr(target_cr)
	if ~exist('complete', 'var')
		complete = false;
	end

	tic;

	data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
	odir = data_dir; %writing to input directory, for now

	% Load CCI data
	datapath = [data_dir 'cci_combined_include_ice.mat'];
	raw = load(datapath);
	Xraw = raw.cci_anom;
	[nt,ns] = size(Xraw);
	lonlat = double(raw.loc(index,:));


	% Set up output matrices
	Xg = cell(Kcv);
	Mg = cell(Kcv);
	Cg = cell(Kcv);

	% GraphEM options
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	adjM = neigh_radius_adj(lonlat,target_cr);
	opt.adj = adjM;


	CRkfoldtag = ['cci_graphem_cr' num2str(target_cr) '.mat'];
	CRkfoldpath = [odir CRkfoldtag];
	% Run GraphEM
	[Xg{k},Mg{k},Cg{k}] = graphem(double(Xcv{k}),opt);
	save(CRkfoldpath, 'Xg_k', 'target_cr', 'adjM', 'index')

	clear Xg_k

	