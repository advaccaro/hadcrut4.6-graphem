%min_max_map.m
% Find min and max temperatures for each grid cell and
% plot them.
function p = abs_map(datafile)

%% Set up
%clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

%% Load datasets
load had46med.mat %HadCRUT4.6 Raw
load(datafile) %HadCRUT4.6 GraphEM
load cw17.mat %Cowtan and Way Kriging

%% Set vars
lon = loc(:,1);
lat = loc(:,2);
lons = cw17.lon;
nlon = length(lons);
lats = cw17.lat;
nlat = length(lats);


%% Set up for plotting
cmap = flipud(cbrewer('div', 'RdYlBu', 31)); %Colormap

ABS = max(abs(SP1.X));
ABS = reshape(ABS', [nlon nlat])';

title_str = ['Abs map ' num2str(target_spars) ' % sparsity'];

%% Plotting

fig(title_str); clf;
subplot(4,3,1:9);
m_proj('Robinson', 'clong', 0);	m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
m_coast('color','k');
hold on;
p = m_pcolor(lons, lats, ABS);
set(p, 'EdgeColor', 'none');
colormap(cmap);
hold off;
caxis([1.5 73.5]);
title('Maximum absolute temperature anomaly in each grid cell');
subplot(4,3,10:12);
cb = colorbar('north');
caxis([1.5 73.5]);
axis('off');

