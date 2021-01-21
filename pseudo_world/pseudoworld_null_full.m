% pseudoworld_null.m
function X_n = pseudoworld_null_full(worldnum, datatype)
  % if ~exist('dist', 'var')
  %   dist = 800;
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

  % compute column means
  col_means = nanmean(Xgrid);
  % clim = calc_clim(Xgrid);
  % step_full =12*[0:1:ceil(nt/12)-1];


  % Fill in missing values
  tmp = Xgrid;
  for t = 1:nt
    missing_ind = isnan(tmp(t,:));
    tmp(t,missing_ind) = col_means(missing_ind);
  end
  X_n = tmp;

  savetag = [fullname '_null.mat'];
  savepath = [odir savetag];

  save(savepath, 'X_n', 'index')

end

function gmt = calc_gmt(grid_2d, lats_2d)
  weights = cosd(lats_2d);
  normfac = nansum(nansum(weights));
  gmt = nansum(nansum(grid_2d.*weights))/normfac;
end
