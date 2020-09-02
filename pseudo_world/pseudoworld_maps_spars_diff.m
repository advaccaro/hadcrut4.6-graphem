% pseudoworld_maps_spars_diff.m

addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))

datatypes = {'sst', 'lsat'};
ndt = length(datatypes);
worldnums = [1:2];
nw = length(worldnums);
metrics = {'bias2', 'var', 'MSE'};
metric_strings = {'Bias^{2}', 'Variance', 'MSE'};
nm = length(metrics);
cxs = {};
cxs{1} = {[-.05 .05], [-1 1], [-1 1]};
cxs{2} = {[-.1 .1], [-2 2], [-2 2]};
sparsities = [40:20:120];
nspars = length(sparsities);

nsets = nw*ndt; %number of data sets ("fullnames")
nmethods = 1 + nspars; %null + sparsities

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
    col_labels{method_idx} = 'Null';


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
      col_labels{method_idx} = ['Null - ' sprintf('%.1f', sparsities(si)/100) '%'];
      % idx = idx + 1;
    end
  end
end
DATAS = {BIAS2, VAR, MSE};
[nsets, nmethods] = size(BIAS2); %should be same as at top
cmap = flipud(cbrewer('div','RdBu',31));
clong = 0; %180;
%% Plotting
for mi = 1:nm
  metric = metrics{mi};
  DATA = DATAS{mi};

  %% Plotting
  figtitle = [metric ' difference snapshots'];
  fig(figtitle); clf;
  p = panel();
  % p.pack('h', {1/7 []},'v',{9/10 []})
  p.pack({9/20 1/20 9/20 []}, {1/15 []})
  % set margins and properties
  p.de.margin = 1;
  p.fontsize = 7;

  % Labels in left column
  p(1,1).pack(nsets/2)
  for k = 1:2
    p(1,1,k).select();  text(-.2,.5,row_labels{k},'FontSize',7)
    set(gca, 'xtick', [], 'ytick', [],'visible','off');
  end

  p(3,1).pack(nsets/2)
  for k = 3:4
    ka = k-2;
    p(3,1,ka).select();  text(-.2,.5,row_labels{k},'FontSize',7)
    set(gca, 'xtick', [], 'ytick', [],'visible','off');
  end

  % SST
  q = p(1,2);
  q.pack(nsets/2,nmethods);
  q.margin = 1;
  q.de.margin = 1;



  %cx = cxs{1}{mi}/2; % 2 IS HARD-CODED
  % cx = [nanmedian(DATA{1,1})-2*nanstd(DATA{1,1}) nanmedian(DATA{1,1})+2*nanstd(DATA{1,1})];
  % amax = max(abs([nanmin(DATA{1,2}) nanmax(DATA{1,2})]));
  % cx = [-amax amax];
  cx = [nanmin(DATA{1,2}) nanmax(DATA{1,2})];
  for set_idx = 1:2
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
  p(2,2).select()
  cbax = gca;
  set(cbax, 'xtick', [], 'ytick', [],'visible','off');
  caxis(cbax, cx);

  c = colorbar('peer', cbax, 'south');
  pos = c.Position;
  c.Position = [.4 pos(2)-.01 0.4 0.015];
  c.Label.String = metric_strings{mi};

  % LSAT
  q = p(3,2);
  q.pack(nsets/2,nmethods);
  q.margin = 1;
  q.de.margin =1;

  % cx = cxs{2}{mi}/2; % 2 IS HARD-CODED
  % cx = [nanmedian( DATA{3,1} ) - 2*nanstd( DATA{3,1} ) nanmedian( DATA{3,1} ) + 2*nanstd(DATA{1,1} )];
  cx = [nanmin(DATA{3,2}) nanmax(DATA{3,2})];
  % amax = max(abs([nanmin(DATA{3,2}) nanmax(DATA{3,2})]));
  % cx = [-amax amax];
  for set_idx = 3:4
    for method_idx = 1:nmethods
      q(set_idx-2,method_idx).select();
      D = nan(ns,1);
      index = indices{set_idx};
      D(index) = DATA{set_idx, method_idx};
      D = reshape(D',[nlon,nlat])';
      map_sst(D, lons, lats, cmap, cx, clong);
    end
  end

  % Colorbar
  p(4,2).select()
  cbax = gca;
  set(cbax, 'xtick', [], 'ytick', [],'visible','off');
  caxis(cbax, cx);

  c = colorbar('peer', cbax, 'south');
  pos = c.Position;
  c.Position = [.4 pos(2)-.01 0.4 0.015];
  c.Label.String = metric_strings{mi};
  p.de.margin = 1;

  % h=gcf;
  % set(h,'PaperOrientation','landscape');
  % set(h,'PaperPosition', [1 1 28 19]);

  figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/figs/';
  figtag = [figdir 'pseudoworld_' metric '_sparsities_diff'];
  figtag_jpeg = [figtag '.jpeg'];
  figtag_pdf = [figtag '.pdf'];
  print(figtag_jpeg, '-djpeg', '-cmyk', '-r500')
  print(figtag_pdf, '-dpdf', '-cmyk', '-fillpage')
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
  colormap(cmap);
  m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
  m_coast('color','k');
  hold off;
  caxis(cx);
end
