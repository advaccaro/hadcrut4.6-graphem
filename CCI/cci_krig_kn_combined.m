function epe = cci_krig_kn_combine(dist, Kcv)
  data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
  odir = data_dir;

  % Load raw data
  datapath = [data_dir 'cci_combined_include_ice.mat'];
  raw = load(datapath);
  [nt,ns] = size(raw.cci_anom);

  % Load KCV indices
  cv_indices_tag = 'cci_kcv_indices.mat';
  cv_indices_path = [data_dir cv_indices_tag];
  load(cv_indices_path)

  % Set up output matrices
  Xg = cell(Kcv);

  for k = 1:Kcv
    kfoldtag = ['cci_combined_krig_k' num2str(k) '.mat'];
    kfoldpath = [data_dir kfoldtag];
    a = load(kfoldpath); %save(kfoldpath, 'X_k', 'index')
    Xg{k} = a.X_k;
    clear a
  end

  lonlat = double(raw.loc);
  lats = lonlat(:,2);
  lats = lats(index);
  lats_2d = repmat(lats, [1,nt]); lats_2d = lats_2d';

  for k = 1:Kcv
    test_ind = cv_out{k};
    weights = cosd(lats_2d(test_ind));
    normfac = nsum(nsum(weights));
    mse0{k} = (Xg{k}(test_ind) - Xgrid(test_ind)).^2;
    f_num(k) = nsum(nsum(mse0{k}.*weights));
    f_mse(k) = f_num(k)/normfac;
  end

  % Calculate expected prediction error
  epe = (1/Kcv) * sum(f_mse(:));
  sigg = std(f_mse(:));

  % Save CV scores
  cvtag = ['cci_combined_krig' num2str(dist) '_CVscores.mat'];
  savepath = [odir cvtag];
  save(savepath, 'epe', 'sigg', 'cv_in', 'cv_out')
end
