% pseudoworld_graphem_sp_full.m
function Xg = pseudoworld_graphem_sp_full(worldnum, datatype, target_spars)
  % if ~exist('dist', 'var')
  %   dist = 1000;
  % end

  % addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world'))
  % addpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/cw17') %path to cw_krig.m
  tic;
  addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))
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
  % cv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
  % cv_indices_path = [odir cv_indices_tag];
  % load(cv_indices_path);

  % % Set up output matrices
  % Xg = cell(1,Kcv);
  test = ~isnan(PW.grid_2d);
  Stest = sum(test);
  index = find(Stest > 0);
  Xgrid = PW.grid_2d(:, index);

  lonlat = double(PW.loc);
  lats = lonlat(:,2);
  lats_2d = repmat(lats(index), [1,nt]);
  lats_2d = lats_2d';

  % Load kriging results to sample covariance
  krigtag = [fullname '_krig.mat'];
  load(krigtag)
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

  % GLASSO
  greedy_maxit = 100;
  [spars, adj] = greedy_search_TT(C0, target_spars, greedy_maxit);
  spars_f = spars(end);
  adjM = adj{end};

  % Sigma_G options
  sigma_opt.ggm_tol = 5e-3;
  sigma_opt.ggm_maxit = 200;
  sigma_opt.ggm_thre = 50;
  sigma_opt.adj = adjM;

  % Produce well-conditioned C
  [Cw, sp_level] = Sigma_G(C0,sigma_opt);

  % GraphEM options
  opt.stagtol = 5e-3;
  opt.maxit = 30;
  opt.useggm = 1;
  opt.adj = adjM;

  % Run GraphEM
  [Xg, Mg, Cg] = graphem(Xgrid, opt);

  % Save output
  savetag = [fullname '_sp' num2str(target_spars*100) '.mat'];
  savepath = [odir savetag];

  save(savepath, 'Xg', 'Mg', 'Cg')

end
