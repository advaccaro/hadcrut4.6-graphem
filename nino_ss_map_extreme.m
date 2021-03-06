%% nino_ss_extreme_map.m
% USC Climate Dynamics Lab
% Adam Vaccaro
% Fall 2018
% Notes: This script uses tight_subplot.m, cbrewer.m, and m_pcolor.m

%% Set Up
clear all
%close all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

%% Load datasets
load had46med.mat %HadCRUT4.6 Raw
load had46med_full_sp80_merra_krig.mat %HadCRUT4.6 GraphEM
load cw17.mat %Cowtan and Way Kriging

%% Set vars
H.t = H46med.tfrac;
G.t = H.t;
C.t = cw17.tfrac;

H.X = rawH46med;
G.X = SP1.X;
C.X = cw17.temp2d;

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
C.DJFind = find (C.t > dec - 1/100 & C.t < feb + 1/100);

H.DJFt = H.t(H.DJFind);
G.DJFt = H.DJFt;
C.DJFt = C.t(C.DJFind);

H.MAMind = find(H.t > mar - 1/100 & H.t < may + 1/100);
G.MAMind = H.MAMind;
C.MAMind = find(C.t > mar - 1/100 & C.t < may + 1/100);

H.MAMt = H.t(H.MAMind);
G.MAMt = H.MAMt;
C.MAMt = C.t(C.MAMind);

H.JJAind = find(H.t > jun - 1/100 & H.t < aug + 1/100); 
G.JJAind = H.JJAind;
C.JJAind = find(C.t > jun - 1/100 & C.t < aug + 1/100);

H.JJAt = H.t(H.JJAind);
G.JJAt = H.JJAt;
C.JJAt = C.t(C.JJAind);

%% Calculate means
%DJF
H.DJFm = H.X(H.DJFind, :);
G.DJFm = G.X(G.DJFind, :);
C.DJFm = C.X(C.DJFind, :);

H.DJF = nmean(H.DJFm);
G.DJF = nmean(G.DJFm);
C.DJF = nmean(C.DJFm);

%MAM
H.MAMm = H.X(H.MAMind, :);
G.MAMm = G.X(G.MAMind, :);
C.MAMm = C.X(C.MAMind, :);

H.MAM = nmean(H.MAMm);
G.MAM = nmean(G.MAMm);
C.MAM = nmean(C.MAMm);

%JJA
H.JJAm = H.X(H.JJAind, :);
G.JJAm = G.X(G.JJAind, :);
C.JJAm = C.X(C.JJAind, :);

H.JJA = nmean(H.JJAm);
G.JJA = nmean(G.JJAm);
C.JJA = nmean(C.JJAm);

%% Set up for plotting
cmap = flipud(cbrewer('div','RdBu',31)); %Colormap

%DATA = cell{9,1};
DATA{1} = H.DJF; % Panel 1 - Raw DJF
%ax{1} = [1,4,7];
DATA{2} = H.MAM; % Panel 2 - Raw MAM
%ax{2} = [2,5,8];
DATA{3} = H.JJA; % Panel 3 - Raw JJA
%ax{3} = [3,6,9];
DATA{4} = G.DJF; % Panel 4 - GraphEM DJF
%ax{4} = [10,13,16];
DATA{5} = G.MAM; % Panel 5 - GraphEM MAM
%ax{5} = [11,14,17];
DATA{6} = G.JJA; % Panel 6 - GraphEM JJA
%ax{6} = [12,15,18];
DATA{7} = C.DJF; % Panel 7 - CW DJF
%ax{7} = [19,22,25];
DATA{8} = C.MAM; % Panel 8 - CW MAM
%ax{8} = [20,23,26];
DATA{9} = C.JJA; % Panel 9 - CW JJA
%ax{9} = [21,24,27];

nRows = 10;
nCols = 3;


% Panels 10:12 - Colorbar

%% Plotting

fig('NINO Snapshots'); clf;
%[ha,pos] = tight_subplot(3,3,[.00003 .03],[.003 .003],[.003 .003]);
for ii = 1:3
	k = ii + 3
	%subplot(nRows,nCols,ax{ii});
	subplot(2,3,ii);	
	D = reshape(DATA{k}',[nlon,nlat])';
	%non_nan = ~isnan(D);
	%axes(ha(ax{ii}));
	%axes(ha(ii));	
	m_proj('Robinson', 'clong', 0);
		m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
	
	%m_line(lons,lats);
	hold on;
	p = m_pcolor(lons, lats, D);
	set(p, 'EdgeColor', 'none');
	colormap(cmap);	
	hold off;
	caxis([-25 25]);
	m_coast('color','k');
	if ii == 1
		title('DJF');
	elseif ii == 2
		title('MAM');
	elseif ii == 3
		title('JJA');
	else
		title('');	
	end
end

% Colorbar
%axes(ha(10:12));
subplot(4,3,10:12)
cb = colorbar('north');
caxis([-25 25]);
axis('off');


otagf = './figs/nino1878_1x3_extreme.jpeg';
otag = './figs/nino1878_1x3_extreme.pdf';
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk')

























