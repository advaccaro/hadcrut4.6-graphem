%% nino_ss_map.m
% USC Climate Dynamics Lab
% Adam Vaccaro
% Summer 2018
% Notes: This script uses tight_subplot.m, cbrewer.m, and m_pcolor.m

%% Set Up
clear all
%close all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

%% Load datasets
load had46med.mat %HadCRUT4.6 Raw
load had46med_full_sp60_merra_krig.mat %HadCRUT4.6 GLASSO GraphEM
load cw17.mat %Cowtan and Way Kriging
load had46med_full_cr1000_merra_krig.mat %HadCRUT4.6 Neighborhood GraphEM

%% Set vars
H.t = H46med.tfrac;
G.t = H.t;
C.t = cw17.tfrac;
N.t = H.t;


H.X = rawH46med;
G.X = SP1.X;
C.X = cw17.temp2d;
N.X = CR.X;

lon = loc(:,1);
lat = loc(:,2);
lons = cw17.lon;
nlon = length(lons);
lats = cw17.lat;
nlat = length(lats);

%% Get time axes (fractional)
year = 1878;
mstep = 1/12;
nov = year - 2/12;
dec = year - 1/12;
feb = year + 1/12;
mar = year + 2/12;
may = year + 4/12;
jun = year + 5/12;
aug = year + 7/12;

% Need to shift fractional months to account for rounding errors
H.DJFind = find(H.t > dec - 1/100 & H.t < feb + 1/100);
G.DJFind = H.DJFind;
N.DJFind = find(N.t > dec - 1/100 & N.t < feb + 1/100);
C.DJFind = find (C.t > dec - 1/100 & C.t < feb + 1/100);

H.DJFt = H.t(H.DJFind);
G.DJFt = H.DJFt;
N.DJFt = N.t(N.DJFind);
C.DJFt = C.t(C.DJFind);

%% Calculate means
%DJF
H.DJFm = H.X(H.DJFind, :);
G.DJFm = G.X(G.DJFind, :);
N.DJFm = N.X(N.DJFind, :);
C.DJFm = C.X(C.DJFind, :);

H.DJF = nmean(H.DJFm);
G.DJF = nmean(G.DJFm);
N.DJF = nmean(N.DJFm);
C.DJF = nmean(C.DJFm);


%% Set up for plotting
cmap = flipud(cbrewer('div','RdYlBu',31)); %Colormap

%DATA = cell{9,1};
DATA{1} = H.DJF; % Panel 1 - Raw DJF
DATA{2} = G.DJF; % Panel 4 - GraphEM GLASSO DJF
DATA{3} = C.DJF; % Panel 7 - GraphEM Neigh DJF
DATA{4} = H.DJF; % Panel 10 - CW DJF
DATA{4}(isnan(H.DJF)) = C.DJF(isnan(H.DJF));
DATA{5} = H.DJF;
for x = 1:length(DATA{5})
	if isnan(DATA{5}(x)) == 1
		DATA{5}(x) = randn/10;
	end
end

nRows = 5;
nCols = 1;


% Panels 10:12 - Colorbar

%% Plotting

fig('NINO Snapshots'); clf;
%[ha,pos] = tight_subplot(3,3,[.00003 .03],[.003 .003],[.003 .003]);
for ii = 1:5
	%subplot(nRows,nCols,ax{ii});
	subplot(6,1,ii);	
	D = reshape(DATA{ii}',[nlon,nlat])';
	%non_nan = ~isnan(D);
	%axes(ha(ax{ii}));
	%axes(ha(ii));	
	m_proj('Robinson', 'clong', 0);
	%m_line(lons,lats);
	hold on;
	p = m_pcolor(lons, lats, D);
	set(p, 'EdgeColor', 'none');
	colormap('default');
		m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
	m_coast('color','k');
	hold off;
	caxis([-3 3]);
end

% Colorbar
%axes(ha(10:12));
subplot(6,1,6)
cb = colorbar('north');
ylabel(cb, '\circC')
caxis([-3 3]);
axis('off');


otagf = './figs/nino1878_5x1.jpeg';
otag = './figs/nino1878_5x1.pdf';
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk')

























