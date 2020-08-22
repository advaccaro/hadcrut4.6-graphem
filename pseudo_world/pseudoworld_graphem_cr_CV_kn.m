% pseudoworld_graphem_cr_CV_kn.m

function epe = pseudoworld_graphem_cr_CV_kn(target_cr, Kcv, worldnum, datatype, complete)
	if ~exist('complete', 'var')
		complete = false;
	end
	epe = NaN;
	tic;
	addpath(genpath('/home/geovault-02/vaccaro/hadcrut4.6-graphem/pseudo_world'));
	data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/'
	odir = data_dir; %writing to input directory, for now

	% Prepare pseudoworld
  worldname = ['pseudoworld' num2str(worldnum)];
	fullname = [worldname '_' datatype];
  intag = [fullname '.mat'];
  basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
	odir = [basedir worldname '/' datatype '/data/'];

  % Load pseudoworld
  raw = load(intag);
  PW = identifyPW(raw, worldnum, datatype);
  [nt,ns] = size(PW.grid_2d);

	% Load CV indices
  cv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
  cv_indices_path = [odir cv_indices_tag];
  load(cv_indices_path);

	lonlat = double(PW.loc);
	lats = lonlat(:,2);
	lats_2d = repmat(lats(index), [1,nt]); lats_2d = lats_2d'; %time x space
	lonlat_r = double(PW.loc(index,:));


	if ~complete
		% GraphEM options
		opt.stagtol = 5e-3;
		opt.maxit = 30;
		opt.useggm = 1;
		adjM = neigh_radius_adj(lonlat_r,target_cr);
		opt.adj = adjM;
		% One fold at a time
		k = Kcv;
		[Xg{k},Mg{k},Cg{k}] = graphem(double(Xcv{k}),opt);
		Xg_k = Xg{k};
		CRkfoldtag = [fullname '_cr' num2str(target_cr) '_k' num2str(k) '.mat'];
		CRkfoldpath = [odir CRkfoldtag];
		save(CRkfoldpath, 'Xg_k', 'target_cr');

	else
		% Set up output matrices
		Xg = cell(Kcv);

		for k = 1:Kcv
			CRkfoldtag = [fullname '_cr' num2str(target_cr) '_k' num2str(k) '.mat'];
			CRkfoldpath = [odir CRkfoldtag];
			load(CRkfoldpath)
			Xg{k} = Xg_k;
			test_ind = cv_out{k};
			weights = cosd(lats_2d(test_ind));
			normfac = nansum(nansum(weights));
			mse0{k} = (Xg{k}(test_ind) - Xgrid(test_ind)).^2;
			% mse_t{k} = mse0{k}(indavl_t);
			f_num(k) = nansum(nansum(mse0{k}.*weights));
			f_mse(k) = f_num(k)/normfac;
			clear Xg_k
		end

		epe = sqrt((1/Kcv) * sum(f_mse(:)));
		sigg = std(sqrt(f_mse(:)));
		runtime = toc;

		CVtag = [fullname '_cr' num2str(target_cr) '_CVscores.mat'];
		savepath = [odir CVtag];
		save(savepath, 'epe', 'sigg', 'f_mse')
	end
end
