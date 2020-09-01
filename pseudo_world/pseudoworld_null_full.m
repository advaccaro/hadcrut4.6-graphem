% pseudoworld_null.m
function X_n = pseudoworld_null_full(worldnum, datatype)
  % if ~exist('dist', 'var')
  %   dist = 800;
  % end

  % addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world'))
  % addpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/cw17') %path to cw_krig.m
  tic;
  addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world'))
  % addpath(genpath('/Users/ADV/hadcrut4.6-graphem/pseudo_world'))

  % Prepare pseudoworld
  worldname = ['pseudoworld' num2str(worldnum)];
	fullname = [worldname '_' datatype];
  intag = [fullname '.mat'];
  basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
  % basedir = '/Users/ADV/hadcrut4.6-graphem/pseudo_world/';
  odir = [basedir worldname '/' datatype '/data/'];
  % Load pseudoworld
  raw = load(intag);
  PW = identifyPW(raw, worldnum, datatype);
  [nt,ns] = size(PW.grid_2d);

  % Load CV indices
  cv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
  cv_indices_path = [odir cv_indices_tag];
  load(cv_indices_path);

  % % Set up output matrices
  % Xg = cell(1,Kcv);
  test = ~isnan(PW.grid_2d);
  Stest = sum(test);
  index = find(Stest > 0);
  Xgrid = PW.grid_2d(:, index);

  % compute climatology
  clim = calc_clim(Xgrid);
  step_full =12*[0:1:ceil(nt/12)-1];


  % Fill in missing values
  tmp = Xgrid;
  for t = 1:nt
    month = mod(t,12);
    if month == 0
      month = 12;
    end
    missing_ind = isnan(tmp(t,:));
    tmp(t, missing_ind) = clim(month, missing_ind);
  end
  X_n = tmp;

  savetag = [fullname '_null.mat'];
  savepath = [odir savetag];

  save(savepath, 'X_n', 'index')



  % for k = 1:Kcv
  % 	% % Run GraphEM
  % 	% % [Xg{k},Mg{k},Cg{k}] = graphem(double(Xcv{k}),opt);
  % 	% tmp = Xcv{k};
  % 	% for t = 1:nt
  % 	% 	month = mod(t,12);
  % 	% 	if month == 0
  % 	% 		month = 12;
  % 	% 	end
  % 	% 	missing_ind = isnan(tmp(t,:));
  % 	% 	tmp(t, missing_ind) = clim(month, missing_ind);
  % 	% end
  %
  % 	% Xg{k} = tmp;
  % 	% Xg_k = Xg{k};
  % 	SPkfoldtag = [fullname '_k' num2str(k) '_null.mat'];
  % 	SPkfoldpath = [odir SPkfoldtag];
  %   load(SPkfoldpath)
  %   Xg{k} = Xg_k;
  % 	% save(SPkfoldpath, 'Xg_k', 'index')
  % 	clear Xg_k
  % end
  %
  % % indavl_t = ~isnan(Xgrid);
  % % lonlat = double(raw.loc(index,:));
  % % lats_t = lats_2d(cv_out);
  % lonlat = double(PW.loc);
  % lats = lonlat(:,2);
  % lats = lats(index);
  % lats_2d = repmat(lats, [1,nt]); lats_2d = lats_2d'; %time x space
  % % weights = cosd(lats_2d);
  % % normfac = nsum(nsum(weights));
  %
  % for k = 1:Kcv
  % 	test_ind = cv_out{k};
  % 	weights = cosd(lats_2d(test_ind));
  % 	normfac = nansum(nansum(weights));
  % 	mse0{k} = (Xg{k}(test_ind) - Xgrid(test_ind)).^2;
  % 	mse_t{k} = mse0{k};
  % 	f_num(k) = nansum(nansum(mse_t{k}.*weights));
  % 	f_mse(k) = f_num(k)/normfac;
  %   % f_rmse(k) = sqrt(f_num(k));
  % end
  %
  % epe = sqrt((1/Kcv) * sum(f_mse(:)));
  % sigg = sqrt(std(f_mse(:)));
  % runtime = toc;
  %
  % CVtag = [fullname '_null_CVscores.mat'];
  % savepath = [odir CVtag];
  % save(savepath, 'epe', 'sigg', 'f_mse', 'runtime', 'cv_in', 'cv_out')

end
