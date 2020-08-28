%pseudoworld_graphem_sp_CV.m
% Cross-validation of target sparsity for GraphEM w/ GLASSO
function epe = pseudoworld_graphem_sp_CV_kn(target_spars, Kcv, worldnum, datatype, complete, full_run)
	% Set missing optional arguments to false
	if ~exist('complete', 'var')
		complete = false;
	end

	if ~exist('full_run', 'var')
		full_run = false;
	end

	%% Initialize
	epe = NaN;	%return value
	tic;
	homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
	addpath(genpath(homedir))

	worldname = ['pseudoworld' num2str(worldnum)];
	fullname = [worldname '_' datatype];
	intag = [fullname '.mat'];
	basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
	odir = [basedir worldname '/' datatype '/data/'];

	% Load raw data data matrix
	raw = load(intag);
	PW = identifyPW(raw, worldnum, datatype);
	[nt,ns] = size(PW.grid_2d);

	% Load KCV indices
	kcv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
	kcv_indices_path = [odir kcv_indices_tag];
	K = load(kcv_indices_path);
	Xcv = K.Xcv;
	index = K.index;
	Xgrid = PW.grid_2d(:,index);
	lonlat = double(PW.loc);
	lats = lonlat(:,2);
	lats_2d = repmat(lats(index), [1,nt]); lats_2d = lats_2d;



	if ~complete || full_run
		for k = 1:Kcv
			SPkfoldtag = [fullname '_CV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
			SPkfoldpath = [odir SPkfoldtag];

			% Do krigging
			X_k = cw_krig(Xcv{k}, 800, double(PW.lat), double(PW.lon), index);

			% Get index for 1980-2010
			tfrac = zeros(nt,1);
			if worldnum ~= 4
				for i = 1:nt
					tfrac(i) = 1850 + (i-1)/12;
				end
			else
				for i = 1:nt
					tfrac(i) = 1859 + i/12;
				end
			end
			modern = find(tfrac >= 1979);

			% Sample covariance
			C0 = corr(X_k(modern, :));
			% C0 = corr(Xcv{k});
			greedy_maxit = 50;

			%Sigma_G options
			sigma_opt.ggm_tol = 5e-3;
			sigma_opt.ggm_maxit = 200;
			sigma_opt.ggm_thre = 50;
			sigma_opt.adj = 0; %placeholder

			% Prodeuce adjacency matrix
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

	if complete || full_run
		% Initialize output matrices
		Xg = cell(Kcv);
		for k = 1:Kcv
			SPkfoldtag = [fullname '_CV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
			SPkfoldpath = [odir SPkfoldtag];
			load(SPkfoldpath)
			Xg{k} = Xg_k;
			test_ind = K.cv_out{k};
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

		CVtag = [fullname '_sp' num2str(target_spars*100) '_CVscores.mat'];
		savepath = [odir CVtag];
		save(savepath, 'epe', 'sigg', 'f_mse')
	end
end
