%min_max_map.m
% Find min and max temperatures for each grid cell and
% plot them.
function min_max_map(dataset)
%% Set up
%clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

%% Load datasets
load had46med.mat %HadCRUT4.6 Raw
%load had46med_full_sp80_merra_krig.mat %HadCRUT4.6 GraphEM
load(dataset)
load cw17.mat %Cowtan and Way Kriging

%% Set vars
lon = loc(:,1);
lat = loc(:,2);
lons = cw17.lon;
nlon = length(lons);
lats = cw17.lat;
nlat = length(lats);

%% Check if CR or SP
if ~isempty(strfind(dataset, 'cr'))
	SP1 = CR;
	tid = 'cr'
	tv = num2str(cutoff_radius);
	str_add = ['cutoff radius: ' tv];
	sprintf("Cut off radius: %.2f", cutoff_radius)
	
elseif ~isempty(strfind(dataset, 'sp'))
	tid = 'sp'
	tv = num2str(target_spars*100);
	str_add = ['target_sparsity: ' num2str(target_spars)];
	sprintf("Target sparsity: %.2f", target_spars)
else
	tid = 'raw'
	tv = 'med'
	str_add = 'Raw Median';
	SP1.X = rawH46med;

end


%% Set up for plotting
cmap = flipud(cbrewer('div', 'RdYlBu', 31)); %Colormap
MIN = min(SP1.X);
MIN = reshape(MIN', [nlon nlat])';
min_t = min(min(MIN));
min_str = ['Min map target sparsity: ' str_add];

MAX = max(SP1.X);
MAX = reshape(MAX', [nlon nlat])';
max_t = max(max(MAX));
max_str = ['Max map target sparsity: ' str_add];

ABS = max(abs(SP1.X));
ABS = reshape(ABS', [nlon nlat])';
abs_t = max(max(ABS));
abs_str = ['Abs map target sparsity: ' str_add];

%% Print to console
sprintf("Absolute maximum temperature: %.2f", abs_t)
sprintf("Maximum temperature: %.2f", max_t)
sprintf("Minimum temperature: %.2f", min_t)


%% Plotting
fig(min_str); clf;
subplot(4,3,1:9);
m_proj('Robinson', 'clong', 0);	m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
hold on;
p = m_pcolor(lons, lats, MIN);
set(p, 'EdgeColor', 'none');
colormap(cmap);
hold off;
caxis([-75 0]);
m_coast('color','k');
title('Minimum temperature in each grid cell');
ylabel('Temperature anomaly (\circC)')
subplot(4,3,10:12);
cb = colorbar('north');
caxis([-75 0]);
axis('off');
min_tag = ['./figs/min_map_' tid '_' tv '.jpeg']
print(min_tag, '-djpeg', '-cmyk', '-r500')

fig(max_str); clf;
subplot(4,3,1:9);
m_proj('Robinson', 'clong', 0);	m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
hold on;
p = m_pcolor(lons, lats, MAX);
set(p, 'EdgeColor', 'none');
colormap(cmap);
hold off;
caxis([1 32]);
m_coast('color','k');
title('Maximum temperature in each grid cell');
ylabel('Temperature anomaly (\circC)');
subplot(4,3,10:12);
cb = colorbar('north');
caxis([1 32]);
axis('off');
max_tag = ['./figs/max_map_' tid '_' tv '.jpeg']
print(max_tag, '-djpeg', '-cmyk', '-r500')

fig(abs_str); clf;
subplot(4,3,1:9);
m_proj('Robinson', 'clong', 0);	m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
hold on;
p = m_pcolor(lons, lats, ABS);
set(p, 'EdgeColor', 'none');
colormap(cmap);
hold off;
caxis([1.5 73.5]);
m_coast('color','k');
title('Maximum absolute temperature anomaly in each grid cell');
ylabel('Temperature anomaly (\circC)')
subplot(4,3,10:12);
cb = colorbar('north');
caxis([1.5 73.5]);
axis('off');
abs_tag = ['./figs/abs_map_' tid '_' tv '.jpeg']
print(abs_tag, '-djpeg', '-cmyk', '-r500')
