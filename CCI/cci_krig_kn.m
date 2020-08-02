% cci_krig_kn.m

function x_k = cci_krig_kn(dist, Kcv)
  if ~exist('dist', 'var')
    dist = 800;
  end

  addpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/cw17')
  data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';

  % Load CCI data
  datapath = [data_dir 'cci_combined_include_ice.mat'];
  raw = load(datapath);
  Xraw = raw.cci_anom;
  [nt,ns] = size(Xraw);

  % Load KCV indices
  cv_indices_tag = 'cci_kcv_indices.mat';
  cv_indices_path = [data_dir cv_indices_tag];
  load(cv_indices_path)

  k = Kcv;
  lats = double(raw.CCI.lat);
  lons = double(raw.CCI.lon);
  data2d = Xcv{k};
  X_k = cw_krig(data2d, dist, lats, lons, index);

  % Save
  kfoldtag = ['cci_combined_krig_k' num2str(k) '.mat'];
  kfoldpath = [data_dir kfoldtag];
  save(kfoldpath, 'X_k', 'index')


end
