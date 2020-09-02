% pseudoworld_maps_spars_diff.m

addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))

datatypes = {'sst', 'lsat'};
ndt = length(datatypes);
worldnums = [1:2];
nw = length(worldnums);
metrics = {'bias2', 'var', 'MSE'};
nm = length(metrics);
cxs = {};
cxs{1} = {[-.05 .05], [-1 1], [-1 1]};
cxs{2} = {[-.1 .1], [-2 2], [-2 2]};
sparsities = [50:10:100];
nspars = length(sparsities);

nsets = nw*ndt; %number of data sets ("fullnames")
nmethods = 1 + nspars; %null + sparsities

% col_labels = {};
% for i = 1:nspars
%   col_labels{i} = [sprintf('%.1f', sparsities(i)/100) '%'];
%   if i == 1
%     col_labels{i} = ['Sparsity:  ' col_labels{i}];
%   end
% end
row_labels = {};
indices = {};
DATA = {};
BIAS2 = {};
VAR = {};
MSE = {};

set_idx = 0;
lookup = {};
for di = 1:ndt
  datatype = datatypes{di};
  for worldnum = worldnums
    set_idx = set_idx + 1;
    lookup{di, worldnum} = set_idx;
    row_labels{set_idx} = ['PW' worldnum upper(datatype)];

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
    indices{set_idx} = index;
    lons = double(PW.lon);
    nlon = length(lons);
    lats = double(PW.lat);
    nlat = length(lats);

    % Reduce truth
    truth_r = PWtruth.grid_2d(:, index);
    [nt,ns] = size(PWtruth.grid_2d);

    % Load null reconstruction
    nulltag = [fullname '_null.mat'];
    null = load(nulltag);
    [null.bias2, null.var, null.MSE] = MSE_decomp1d(truth_r, null.X_n);
    method_idx = 1;
    BIAS2{set_idx, method_idx} = null.bias2;
    VAR{set_idx, method_idx} = null.var;
    MSE{set_idx, method_idx} = null.MSE;
    col_labels{method_idx} = 'Null'


    % Load interpolated datasets
    sps = {};
    for si = 1:nspars
      method_idx = method_idx + 1;
      spars = sparsities(si);
      sptag = [fullname '_sp' num2str(spars) '.mat'];
      sps{si} = load(sptag);
      [sps{si}.bias2, sps{si}.var, sps{si}.MSE] = MSE_decomp1d(truth_r, sps{si}.Xg);
      BIAS2{set_idx, method_idx} = null.bias2 - sps{si}.bias2;
      VAR{set_idx, method_idx} = null.var - sps{si}.var;
      MSE{set_idx, method_idx} = null.MSE - sps{si}.MSE;
      col_labels{method_idx} = ['Null - glasso ' sprintf('%.1f', sparsities(i)/100) '%'];
      % idx = idx + 1;
    end
  end
end
DATAS = {BIAS2, VAR, MSE};
[nmethods, nsets] = size(BIAS2); %should be same as at top

%% Plotting
for mi = 1:nm
  metric = metrics{mi};
  DATA = DATAS{mi};

  %% Plotting
  figtitle = [metric ' difference snapshots'];
  fig(figtitle); clf;
  p = panel();
  p.pack('h', {1/7 []},'v',{9/10 []})
  % set margins and properties
  p.de.margin = 2;
  p.fontsize = 8;

  % Labels in left column
  p(1,1).pack(nsets)
  for k = 1:nsets
    p(1,1,k).select();  text(-.2,.5,row_labels{k},'FontSize',8)
    set(gca, 'xtick', [], 'ytick', [],'visible','off');
  end

  % Meat of the plot
  q = p(2,1);
  q.pack(nsets,nmethods);
  q.margin = 4;


  cmap = flipud(cbrewer('div','RdYlBu',31));
  cx = cxs{2}{mi}; % 2 IS HARD-CODED
  clong = 0; %180;

  for set_idx = 1:nsets
    for method_idx = 1:nmethods
      q(set_idx,method_idx).select();
      D = nan(ns,1);
      index = indices{set_idx};
      D(index) = DATA{set_idx, method_idx};
      D = reshape(D',[nlon,nlat])';
      map_sst(D, lons, lats, cmap, cx, clong);
      if set_idx == 1
        title(col_labels{method_idx}, 'FontWeight','bold');
      end
    end
  end

  % Colorbar
  p(nsets,nmethods).select()
  cbax = gca;
  set(cbax, 'xtick', [], 'ytick', [],'visible','off');
  caxis(cbax, cx);

  c = colorbar('peer', cbax, 'southoutside');
  pos = c.Position;
  c.Position = [.3 pos(2)-.03 0.6 0.03];
  c.Label.String = 'SST anomaly (\circC^{2})';

  figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/figs/';
  figtag = [figdir 'pseudoworld_' metric '_sparsities_diff'];
  figtag_jpeg = [figtag '.jpeg'];
  figtag_pdf = [figtag '.pdf'];
  print(figtag_jpeg, '-djpeg', '-cmyk', '-r500')
  print(figtag_pdf, '-dpdf', '-cmyk')
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
  caxis(cx);
end
