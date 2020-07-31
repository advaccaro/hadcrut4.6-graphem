% cci_graphem_cr.m

function cci_graphem_cr(target_cr)
	tic;

	data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
	odir = data_dir; %writing to input directory, for now

	% Load CCI data
	datapath = [data_dir 'cci_combined_include_ice.mat'];
	raw = load(datapath);
	Xraw = raw.cci_anom;
	[nt,ns] = size(Xraw);
	lonlat = double(raw.loc);

	% Load KCV indices (to get Xgrid and index)
	cv_indices_tag = 'cci_kcv_indices.mat';
	cv_indices_path = [data_dir cv_indices_tag];
	load(cv_indices_tag)

	lonlat = lonlat(index,:);
	
	% GraphEM options
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	adjM = neigh_radius_adj(lonlat,target_cr);
	opt.adj = adjM;


	CRkfoldtag = ['cci_graphem_cr' num2str(target_cr) '.mat'];
	CRkfoldpath = [odir CRkfoldtag];
	% Run GraphEM
	[Xg,Mg,Cg] = graphem(double(Xgrid),opt);
	save(CRkfoldpath, 'Xg', 'Cg', 'target_cr', 'adjM', 'index')

	