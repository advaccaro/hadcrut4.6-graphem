% cci_graphem_cr_CV.m

function epe = cci_graphem_cr_CV(target_cr, Kcv, complete)
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

	% Load KCV indices
	cv_indices_tag = 'cci_kcv_indices.mat';
	cv_indices_path = [data_dir, cv_indices_tag];
	load(cv_indices_path)

	lonlat = double(raw.loc);
	lats = lonlat(:,2);
	lats_2d = repmat(lats, [1,nt]); lats_2d = lats_2d'; %time x space
	lonlat_r = double(raw.loc(index,:));

	% lats_t = lats_2d(indavl_t);
	% weights = cosd(lats_t);
	% normfac = nsum(nsum(weights));


	% Set up output matrices
	Xg = cell(Kcv);
	Mg = cell(Kcv);
	Cg = cell(Kcv);

	% GraphEM options
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	adjM = neigh_radius_adj(lonlat_r,target_cr);
	opt.adj = adjM;


	for k = 1:Kcv
		CRkfoldtag = ['cci_combined_CRCV_cr' num2str(target_cr) '_k' num2str(k) '.mat'];
		CRkfoldpath = [odir CRkfoldtag];
		if ~complete
			% Run GraphEM
			[Xg{k},Mg{k},Cg{k}] = graphem(double(Xcv{k}),opt);
			Xg_k = Xg{k};
			save(CRkfoldpath, 'Xg_k', 'target_cr', 'adjM', 'index')
		else
			load(CRkfoldpath)
			Xg{k} = Xg_k;
		end
		clear Xg_k
	end

	for k = 1:Kcv
		test_ind = cv_out{k};
		weights = cosd(lats_2d(test_ind));
		normfac = nsum(nsum(weights));
		mse0{k} = (Xg{k}(test_ind) - Xgrid(test_ind)).^2;
		% mse_t{k} = mse0{k}(indavl_t);
		f_num(k) = nsum(nsum(mse0{k}.*weights));
		f_mse(k) = f_num(k)/normfac;
	end

	epe = (1/Kcv) * sum(f_mse(:));
	sigg = std(f_mse(:));
	runtime = toc;

	CVtag = 'cci_combined_cr_CVscores.mat';
	savepath = [odir CVtag];
	save(savepath, 'epe', 'sigg', 'runtime', 'cv_in', 'cv_out')
