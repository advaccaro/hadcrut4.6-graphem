% pseudoworld_graphem_cr_full.m
function Xg = pseudoworld_graphem_cr_full(worldnum, datatype, target_cr)
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
  cv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
  cv_indices_path = [odir cv_indices_tag];
  load(cv_indices_path);

  % % Set up output matrices
  % Xg = cell(1,Kcv);
  test = ~isnan(PW.grid_2d);
  Stest = sum(test);
  index = find(Stest > 0);
  Xgrid = PW.grid_2d(:, index);

  lonlat = double(PW.loc);
  lonlat_r = lonloat(index,:);
  lats = lonlat(:,2);
  lats_2d = repmat(lats(index), [1,nt]);
  lats_2d = lats_2d';

  % Neighborhood graph
  adjM = niegh_radius_adj(lonlat_r, target_cr);

  % GraphEM options
  opt.stagtol = 5e-3;
  opt.maxit = 30;
  opt.useggm = 1;
  opt.adj = adjM;

  % Run GraphEM
  [Xg, Mg, Cg] = graphem(Xgrid, opt);

  % Save output
  savetag = [fullname '_cr' num2str(target_cr) '.mat'];
  savepath = [odir savetag];

  save(savepath, 'Xg', 'Mg', 'Cg')

end
