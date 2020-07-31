function epe = cci_graphem_sp_CV_kn_Call_combine(target_spars, Kcv)
	data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
	odir = data_dir; %writing to input directory, for now

	datapath = [data_dir 'cci_combined_include_ice.mat'];
	raw = load(datapath);
	Xraw = raw.cci_anom;
	[nt,ns] = size(Xraw);
	
	% Load KCV indices
	cv_indices_tag = 'cci_kcv_indices.mat';
	cv_indices_path = [data_dir, cv_indices_tag];
	load(cv_indices_path)
	
	% Set up output matrices
	Xg = cell(Kcv);


	for k = 1:Kcv
		SPkfoldtag = ['cci_combined_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '_all.mat'];
		SPkfoldpath = [odir SPkfoldtag];

		a = load(SPkfoldpath);
		Xg{k} = a.Xg_k;
		clear a
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

	CVtag = 'cci_combined_sp_CVscores_all.mat';
	savepath = [odir CVtag];
	save(savepath, 'epe', 'sigg', 'cv_in', 'cv_out')