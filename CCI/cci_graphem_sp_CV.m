% cci_graphem_sp_CV.m

function epe = cci_graphem_sp_CV(target_spars, Kcv, complete)
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

	% Load adjacency matrix and well-conditioned C
	adj_path = [data_dir 'adj_SPCV_sp' num2str(target_spars*100) '.mat'];
	load(adj_path)

	% Set up output matrices
	Xg = cell(Kcv);
	Mg = cell(Kcv);
	Cg = cell(Kcv);

	% GraphEM options
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	opt.adj = adjM;
	opt.C0 = Cw;

	for k = 1:Kcv
		SPkfoldtag = ['cci_combined_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
		SPkfoldpath = [odir SPkfoldtag];
		if ~complete
		% Run GraphEM
			[Xg{k},Mg{k},Cg{k}] = graphem(double(Xcv{k}),opt);
			Xg_k = Xg{k};
			save(SPkfoldpath, 'Xg_k', 'target_spars', 'adjM', 'index')
		else
			load(SPkfoldpath)
			Xg{k} = Xg_k;
		end
		clear Xg_k
	end

	indavl_t = ~isnan(Xgrid);
	lonlat = double(raw.loc(index,:));
	lats = lonlat(:,2);
	lats_2d = repmat(lats, [1,nt]); lats_2d = lats_2d'; %time x space
	lats_t = lats_2d(indavl_t);
	weights = cosd(lats_t);
	normfac = nsum(nsum(weights));

	for k = 1:Kcv
		mse0{k} = (Xg{k} - Xgrid).^2;
		mse_t{k} = mse0{k}(indavl_t);
		f_num(k) = nsum(nsum(mse_t{k}.*weights));
		f_mse(k) = f_num(k)/normfac;
	end

	epe = (1/Kcv) * sum(f_mse(:));
	sigg = std(f_mse(:));
	runtime = toc;

	CVtag = ['cci_combined_sp' num2str(target_spars*100) '_CVscores.mat'];
	savepath = [odir CVtag];
	save(savepath, 'epe', 'sigg', 'runtime', 'cv_in', 'cv_out')
	