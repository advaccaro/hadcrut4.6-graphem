function pseudoworld_test_map(worldnum, datatype)
  addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))

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
  lons = double(PW.lon);
  nlon = length(lons);
  lats = double(PW.lat);
  nlat = length(lats);

  % Reduce truth
  truth_r = PWtruth.grid_2d(:, index);
  [nt,ns] = size(PWtruth.grid_2d);


  % Load interpolated datasets
  %null
  nulltag = [fullname '_null.mat'];
  null = load(nulltag);
  [null.bias2, null.var, null.MSE] = MSE_decomp1d(truth_r, null.X_n);

  %krig
  krigtag = [fullname '_krig.mat'];
  krig = load(krigtag);
  [krig.bias2, krig.var, krig.MSE] = MSE_decomp1d(truth_r, krig.X_k);

  %cr
  crtag = [fullname '_cr1000.mat'];
  cr = load(crtag);
  [cr.bias2, cr.var, cr.MSE] = MSE_decomp1d(truth_r, cr.Xg);

  %sp
  % keys = {'50','60','70','80','90;,100'}
  spars = {'50', '60', '100'};
  nspars = length(spars);
  sps = {};
  for i = 1:nspars
    sptag = [fullname '_sp' spars{i} '.mat'];
    sps{i} = load(sptag);
    sps{i}.spars = spars{i};
    [sps{i}.bias2, sps{i}.var, sps{i}.MSE] = MSE_decomp1d(truth_r, sps{i}.Xg);
  end
  % sps = containers.Map(keys, values);


  % Prepare data structures for plotting
  DATA = {}; DATA2 = {};
  DATA{1}.bias2 = null.bias2; DATA2{1} = null.bias2;
  DATA{1}.var = null.var; DATA2{1} = null.var;
  DATA{1}.MSE = null.MSE; DATA2{3} = null.MSE;
  DATA{2}.bias2 = krig.bias2; DATA2{4} = krig.bias2;
  DATA{2}.var = krig.var; DATA2{5} = krig.var;
  DATA{2}.MSE = krig.MSE; DATA2{6} = krig.MSE;
  DATA{3}.bias2 = cr.bias2; DATA2{7} = cr.bias2;
  DATA{3}.var = cr.var; DATA2{8} = cr.var;
  DATA{3}.MSE = cr.MSE; DATA2{9} = cr.MSE;
  % for i = 1:nspars
  %   ix = 3+i;
  %   DATA{ix}.bias2 = sps{i}.bias2;
  %   DATA{ix}.var = sps{i}.var;
  %   DATA{ix}.MSE = sps{i}.MSE;
  % end
  DATA{4}.bias2 = sps{2}.bias2; DATA2{10} = sps{2}.bias2;
  DATA{4}.var = sps{2}.var; DATA2{11} = sps{2}.var;
  DATA{4}.MSE = sps{2}.MSE; DATA2{12} = sps{2}.MSE;

  %% Plotting
  fig('Bias2/VAR/MSE snapshots'); clf;
  p = panel();
  p.pack('h', {1/7 []},'v',{9/10 []})
  % set margins and properties
  p.de.margin = 2;
  p.fontsize = 8;

  % Labels in left column
  p(1,1).pack(4)
  row_labels = {'Null', 'Kriging','GraphEM, R_{1000}', 'GraphEM, glasso 0.6%'};
  for k = 1:4
    p(1,1,k).select();  text(-.2,.5,row_labels{k},'FontSize',8)
    set(gca, 'xtick', [], 'ytick', [],'visible','off');
  end

  % Meat of the plot
  q = p(2,1);
  q.pack(4,3);
  q.margin = 4;

  col_labels = {'Bias^{2}', 'Var', 'MSE'};
  cmap = brewermap(27,'*RdBu');
  cx = [-4 4];
  clong = 180;

  for ji = 1:4
    for jj = 1:3
      ii = jj + (ji-1)*3;
      q(ji,jj).select();
      D = nan(ns,1);
      D(index) = DATA2{ii};
      D = reshape(D',[nlon,nlat]);
      map_sst(D, lons, lats, cmap, cx, clong);
      if j1 == 1
        title(col_labels{jj}, 'FontWeight','bold');
      end
    end
  end

  % Colorbar
  p(2,2).select()
  cbax = gca;
  set(cbax, 'xtick', [], 'ytick', [],'visible','off');
  caxis(cbax, cx);

  c = colorbar('peer', cbax, 'southoutside')
  pos = c.Position
  c.Position = [.3 pos(2)-.03 0.6 0.03];
  c.Label.String = 'SST anomaly (\circC)';

  otagf = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/figs/mse_4x3_sp60_RWB.jpeg';
  otag = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/figs/mse_4x3_sp60_RWB.pdf';
  print(otagf, '-djpeg', '-cmyk', '-r500')
  print(otag, '-dpdf', '-cmyk')
end

function [bias2, var, MSE] = MSE_decomp1d(Xt, X)
  [nt,ns] = size(Xt);
  bias2 = nan(ns,1);
  var = nan(ns,1);
  MSE = nan(ns,1);
  for i = 1:ns
    [bias2(i), var(i), MSE(i)] = MSE_decomp(Xt(:,i), X(:,i));
  end
end

function map_sst(grid, lons, lats, cmap, cx, clong)
  m_proj('Robinson', 'clong', clong);
  hold on;
  p = m_pcolor(lons, lats, grid);
  set(p, 'EdgeColor', 'none');
  colormap('default');
  m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
  m_coast('color','k');
  hold off;
end
