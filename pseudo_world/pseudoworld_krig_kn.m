% pseudoworld_krig_kn.m
function X_k = pseudoworld_krig_kn(dist, Kcv, worldnum, datatype)
  if ~exist('dist', 'var')
    dist = 800;
  end

  addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world'))
  addpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/cw17') %path to cw_krig.m

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

  k = Kcv;
  lats = double(PW.lat);
  lons = double(PW.lon);
  X_k = cw_krig(Xcv{k}, dist, lats, lons, index);

  % Save
  kfoldtag = [fullname '_krig_k' num2str(k) '.mat'];
  kfoldpath = [odir kfoldtag];

end
