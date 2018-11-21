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
load had46med_full_cr1000_merra_krig.mat %HadCRUT4.3 Neighborhood GraphEM

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

H.MAMind = find(H.t > mar - 1/100 & H.t < may + 1/100);
G.MAMind = H.MAMind;
N.MAMind = find(N.t > mar - 1/100 & N.t < may + 1/100);
C.MAMind = find(C.t > mar - 1/100 & C.t < may + 1/100);

H.MAMt = H.t(H.MAMind);
G.MAMt = H.MAMt;
N.MAMt = N.t(N.MAMind);
C.MAMt = C.t(C.MAMind);

H.JJAind = find(H.t > jun - 1/100 & H.t < aug + 1/100); 
G.JJAind = H.JJAind;
N.JJAind = find(N.t > jun - 1/100 & N.t < aug + 1/100);
C.JJAind = find(C.t > jun - 1/100 & C.t < aug + 1/100);

H.JJAt = H.t(H.JJAind);
G.JJAt = H.JJAt;
N.JJAt = N.t(N.JJAind);
C.JJAt = C.t(C.JJAind);

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

%MAM
H.MAMm = H.X(H.MAMind, :);
G.MAMm = G.X(G.MAMind, :);
N.MAMm = N.X(N.MAMind, :);
C.MAMm = C.X(C.MAMind, :);

H.MAM = nmean(H.MAMm);
G.MAM = nmean(G.MAMm);
N.MAM = nmean(N.MAMm);
C.MAM = nmean(C.MAMm);

%JJA
H.JJAm = H.X(H.JJAind, :);
G.JJAm = G.X(G.JJAind, :);
N.JJAm = N.X(N.JJAind, :);
C.JJAm = C.X(C.JJAind, :);

H.JJA = nmean(H.JJAm);
G.JJA = nmean(G.JJAm);
N.JJA = nmean(N.JJAm);
C.JJA = nmean(C.JJAm);

%% Set up for plotting
cmap = flipud(cbrewer('div','RdYlBu',31)); %Colormap

%DATA = cell{9,1};
DATA{1} = H.DJF; % Panel 1 - Raw DJF
%ax{1} = [1,4,7];
DATA{2} = H.MAM; % Panel 2 - Raw MAM
%ax{2} = [2,5,8];
DATA{3} = H.JJA; % Panel 3 - Raw JJA
%ax{3} = [3,6,9];
DATA{4} = G.DJF; % Panel 4 - GraphEM GLASSO DJF
%ax{4} = [10,13,16];
DATA{5} = G.MAM; % Panel 5 - GraphEM GLASSO MAM
%ax{5} = [11,14,17];
DATA{6} = G.JJA; % Panel 6 - GraphEM GLASSO JJA
%ax{6} = [12,15,18];
DATA{7} = N.DJF; % Panel 7 - GraphEM Neigh DJF
DATA{8} = N.MAM; % Panel 8 - GraphEM Neigh MAM
DATA{9} = N.JJA; % Panel 9 - GraphEM Neigh JJA
DATA{10} = C.DJF; % Panel 10 - CW DJF
%ax{7} = [19,22,25];
DATA{11} = C.MAM; % Panel 11 - CW MAM
%ax{8} = [20,23,26];
DATA{12} = C.JJA; % Panel 12 - CW JJA
%ax{9} = [21,24,27];

nRows = 10;
nCols = 3;


% Panels 10:12 - Colorbar

%% Plotting

fig('NINO Snapshots'); clf;
%[ha,pos] = tight_subplot(3,3,[.00003 .03],[.003 .003],[.003 .003]);
for ii = 1:12
	%subplot(nRows,nCols,ax{ii});
	subplot(5,3,ii);	
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
subplot(5,3,13:15)
cb = colorbar('north');
ylabel(cb, '\circC')
caxis([-3 3]);
axis('off');


otagf = './figs/nino1878_4x3_sp60.jpeg';
otag = './figs/nino1878_4x3_sp60.pdf';
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk')

























