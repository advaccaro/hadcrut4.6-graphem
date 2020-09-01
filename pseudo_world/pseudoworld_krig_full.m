% pseudoworld_krig_full.m
function X_k = pseudoworld_krig_full(worldnum, datatype, dist)
  if ~exist('dist', 'var')
    dist = 800;
  end

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
  lats = lonlat(:,2);
  lats_2d = repmat(lats(index), [1,nt]);
  lats_2d = lats_2d';



  % Fill in missing values
  lats = double(PW.lat);
  lons = double(PW.lon);
  X_k = cw_krig(Xgrid, dist, lats, lons, index);

  savetag = [fullname '_krig.mat'];
  savepath = [odir savetag];

  save(savepath, 'X_k')

end
