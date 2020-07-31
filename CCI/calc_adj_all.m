% load cw14 short
function adjM = calc_adj_all(target_spars)
	%% load data
	home_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';

	% cci
	ccipath = [home_dir 'CCI/data/cci_combined_include_all.mat'];
	raw = load(ccipath);
	[nt,ns] = size(raw.cci_anom);

	%select points with > (1/Kcv)% coverage to precent failure
	kcv_indices_path = [home_dir 'CCI/data/cci_kcv_indices.mat'];
	K = load(kcv_indices_path);
	index = K.index;



	Xgrid = raw.cci_anom(:,index);

	C0 = corr(Xgrid);
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

	% Save adjM and Cw
	adjpath = [home_dir, 'CCI/data/adj_SPCV_sp' num2str(target_spars*100) '_all.mat'];
	save(adjpath, 'spars_f', 'adjM', 'Cw', 'target_spars')

end