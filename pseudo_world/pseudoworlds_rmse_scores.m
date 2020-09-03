addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))

datatypes = {'sst', 'lsat'};
ndt = length(datatypes);
worldnums = [1:2];
nw = length(worldnums);
metrics = {'bias2', 'var', 'MSE'};
metric_strings = {'Bias^{2}', 'Variance', 'MSE'};
nm = length(metrics);
sparsities = [40:20:120];
nspars = length(sparsities);

nsets = nw*ndt; %number of data sets ("fullnames")
nmethods = 3 + nspars; %null + sparsities

row_labels = cell(nsets,1);
col_labels = cell(nmethods,1);
mses = cell(nsets,nmethods);
ses = cell(nsets,nmethods);

set_idx = 0;
for di = 1:ndt
  datatype = datatypes{di};
  for worldnum = worldnums
    set_idx = set_idx + 1;
    row_labels{set_idx} = ['PW' num2str(worldnum) ' ' upper(datatype)];

    % Prepare pseudoworld name
    worldname = ['pseudoworld' num2str(worldnum)];
    fullname = [worldname '_' datatype];
    truthtag = [fullname '_truth.mat'];
    basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
    odir = [basedir worldname '/' datatype '/data/'];
    % Load pseudoworld truth
    truth = load(truthtag);
    PWtruth = identifyPWtruth(truth, worldnum, datatype);

    % Load raw pseudoworld
    rawtag = [fullname '.mat'];
    raw = load(rawtag);
    PW = identifyPW(raw, worldnum, datatype);
    test = ~isnan(PW.grid_2d);
    Stest = sum(test);
    index = find(Stest > 0);
    lonlat = double(PW.loc);
    lats = lonlat(:,2);
    [nt,ns] = size(PW.grid_2d);
    lats_2d = repmat(lats(index), [1,nt]); lats_2d = lats_2d';

    % Reduce truth
    truth_r = PWtruth.grid_2d(:, index);
    [nt,ns] = size(PWtruth.grid_2d);

    % Load null reconstruction
    method_idx = 1;
    col_labels{method_idx} = 'Null';
    nulltag = [fullname '_null.mat'];
    null = load(nulltag);
    mses{set_idx, method_idx} = sprintf('%.2f', calc_rmse(truth_r, null.X_n, lats_2d));,
    % ses{set_idx, method_idx} = null.se;




    % Load interpolated datasets
    % Load kriging
    method_idx = method_idx + 1;
    col_labels{method_idx} = 'Kriging';
    krigtag = [fullname '_krig.mat'];
    krig = load(krigtag);
    mses{set_idx, method_idx} = sprintf('%.2f', calc_rmse(truth_r, krig.X_k, lats_2d));
    % ses{set_idx, method_idx} = krig.se;


    % CR
    method_idx = method_idx + 1;
    col_labels{method_idx} = 'GraphEM, R_1000';
    crtag = [fullname '_cr1000.mat'];
    cr = load(crtag);
    mses{set_idx, method_idx} = sprintf('%.2f', calc_rmse(truth_r, krig.Xg, lats_2d));
    % ses{set_idx, method_idx} = cr.se;


    % sp
    sps = {};
    for si = 1:nspars
      method_idx = method_idx + 1;
      if di == 1 && worldnum == 1
        col_labels{method_idx} = [sprintf('%.1f', sparsities(si)/100) '%'];
      end
      spars = sparsities(si);
      sptag = [fullname '_sp' num2str(spars) '.mat'];
      sps{si} = load(sptag);
      mses{set_idx, method_idx} = sprintf('%.2f', calc_rmse(truth_r, sps{si}.Xg, lats_2d));
    end
  end
end



%  still a problem with Row Labels

M = [row_labels mses];
latextable(M,'Horiz',col_labels,'name','pseudoworld_rmse_scores.tex','Hline',[1], 'Vline', 1);


function rmse = calc_rmse(Xt, X, lats_2d)
  weights = cosd(lats_2d);
  normfac = nansum(nansum(weights));
  se0 = (Xt - X).^2;
  % mse_t{k} = mse0{k}(indavl_t);
  f_num = nansum(nansum(se0.*weights));
  rmse = sqrt(f_num/normfac);
end
