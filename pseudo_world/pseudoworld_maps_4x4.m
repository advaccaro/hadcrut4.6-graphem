% pseudoworld_maps_4x4.m

addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))

datatypes = {'sst', 'lsat'};
ndt = length(datatypes);
worldnums = [1:4];
nw = length(worldnums);
metrics = {'bias2', 'var', 'MSE'};
nm = length(metrics);
cxs = {};
cxs{1} = {[0 .05], [0 1], [0 1]};
cxs{2} = {[0 .1], [0 2], [0 2]};

indices = {};

for di = 1:ndt
  datatype = datatypes{di};
  DATA = {};
  BIAS2 = {};
  VAR = {};
  MSE = {};
  for worldnum = 1:nw
    idx = 1 + nw*(worldnum-1);
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
    indices{worldnum} = index;
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
    BIAS2{idx} = null.bias2;
    VAR{idx} = null.var;
    MSE{idx} = null.MSE;
    idx = idx + 1;

    %krig
    krigtag = [fullname '_krig.mat'];
    krig = load(krigtag);
    [krig.bias2, krig.var, krig.MSE] = MSE_decomp1d(truth_r, krig.X_k);
    BIAS2{idx} = krig.bias2;
    VAR{idx} = krig.var;
    MSE{idx} = krig.MSE;
    idx = idx + 1;

    %cr
    crtag = [fullname '_cr1000.mat'];
    cr = load(crtag);
    [cr.bias2, cr.var, cr.MSE] = MSE_decomp1d(truth_r, cr.Xg);
    BIAS2{idx} = cr.bias2;
    VAR{idx} = cr.var;
    MSE{idx} = cr.MSE;
    idx = idx + 1;

    %sp60
    sptag = [fullname '_sp60.mat'];
    sp = load(sptag);
    [sp.bias2, sp.var, sp.MSE] = MSE_decomp1d(truth_r, sp.Xg);
    BIAS2{idx} = sp.bias2;
    VAR{idx} = sp.var;
    MSE{idx} = sp.MSE;
    idx = idx + 1;
  end
  DATAS = {BIAS2, VAR, MSE};
  %% Plotting
  for mi = 1:nm
    metric = metrics{mi};
    DATA = DATAS{mi};

    %% Plotting
    figtitle = [datatype ' ' metric ' snapshots'];
    fig(figtitle); clf;
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
    q.pack(4,4);
    q.margin = 4;

    col_labels = {'PW1', 'PW2', 'PW3', 'PW4'};
    cmap = brewermap(27,'*RdBu');
    cx = cxs{di}{mi};
    clong = 0; %180;

    for ji = 1:4
      for jj = 1:4
        % ii = jj + (ji-1)*4;
        ii = ji + (jj-1)*4;
        q(ji,jj).select();
        D = nan(ns,1);
        index = indices{ji};
        D(index) = DATA{ii};
        D = reshape(D',[nlon,nlat])';
        map_sst(D, lons, lats, cmap, cx, clong);
        if ji == 1
          title(col_labels{jj}, 'FontWeight','bold');
        end
      end
    end

    % Colorbar
    p(2,2).select()
    cbax = gca;
    set(cbax, 'xtick', [], 'ytick', [],'visible','off');
    caxis(cbax, cx);

    c = colorbar('peer', cbax, 'southoutside');
    pos = c.Position;
    c.Position = [.3 pos(2)-.03 0.6 0.03];
    c.Label.String = 'SST anomaly (\circC^{2})';

    figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/figs/';
    figtag = [figdir 'pseudoworld_' datatype '_' metric '_4x4'];
    figtag_jpeg = [figtag '.jpeg'];
    figtag_pdf = [figtag '.pdf'];
    print(figtag_jpeg, '-djpeg', '-cmyk', '-r500')
    print(figtag_pdf, '-dpdf', '-cmyk')
  end
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
