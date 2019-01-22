%% sp60_sp80_comparison.m
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
load had46med_full_sp60_merra_krig.mat %HadCRUT4.6 GLASSO 0.6% sparsity
G.X = SP1.X;
load had46med_full_sp80_merra_krig.mat % HadCRUT4.6 GLASSO 0.8% sparsity
G2.X = SP1.X;
load cw17.mat %Cowtan and Way Kriging
load had46med_full_cr1000_merra_krig.mat %HadCRUT4.3 Neighborhood GraphEM
D.X = G2.X - G.X;

%% Set vars
%H.t = H46med.tfrac;
G.t = H46med.tfrac;
G2.t = G.t;
%C.t = cw17.tfrac;
N.t = G.t;


%H.X = rawH46med;
%G.X = SP1.X;
%C.X = cw17.temp2d;
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
G.DJFind = find(G.t > dec - 1/100 & G.t < feb + 1/100);
G2.DJFind = G.DJFind;
N.DJFind = find(N.t > dec - 1/100 & N.t < feb + 1/100);
D.DJFind = G.DJFind;
%C.DJFind = find (C.t > dec - 1/100 & C.t < feb + 1/100);

G.DJFt = G.t(G.DJFind);
G2.DJFt = G.DJFt;
D.DJFt = G.DJFt;
N.DJFt = N.t(N.DJFind);
%C.DJFt = C.t(C.DJFind);

year = 1911;
mstep = 1/12;
nov = year - 2/12;
dec = year - 1/12;
feb = year + 1/12;
mar = year + 2/12;
may = year + 4/12;
jun = year + 5/12;
aug = year + 7/12;


G.MAMind = find(G.t > mar - 1/100 & G.t < may + 1/100);
G2.MAMind = G.MAMind;
D.MAMind = G.MAMind;
N.MAMind = find(N.t > mar - 1/100 & N.t < may + 1/100);
%C.MAMind = find(C.t > mar - 1/100 & C.t < may + 1/100);

G.MAMt = G.t(G.MAMind);
G2.MAMt = G.MAMt;
D.MAMt = G.MAMt;
N.MAMt = N.t(N.MAMind);
%C.MAMt = C.t(C.MAMind);

year = 1942;
mstep = 1/12;
nov = year - 2/12;
dec = year - 1/12;
feb = year + 1/12;
mar = year + 2/12;
may = year + 4/12;
jun = year + 5/12;
aug = year + 7/12;



G.JJAind = find(G.t > jun - 1/100 & G.t < aug + 1/100); 
G2.JJAind = G.JJAind;
D.JJAind = G.JJAind;
N.JJAind = find(N.t > jun - 1/100 & N.t < aug + 1/100);
%C.JJAind = find(C.t > jun - 1/100 & C.t < aug + 1/100);

G.JJAt = G.t(G.JJAind);
G2.JJAt = G.JJAt;
D.JJAt = G.JJAt;
N.JJAt = N.t(N.JJAind);
%C.JJAt = C.t(C.JJAind);

%% Calculate means
%DJF
G.DJFm = G.X(G.DJFind, :);
G2.DJFm = G2.X(G2.DJFind, :);
D.DJFm = D.X(D.DJFind, :);
N.DJFm = N.X(N.DJFind, :);
%C.DJFm = C.X(C.DJFind, :);

G.DJF = nmean(G.DJFm);
G2.DJF = nmean(G2.DJFm);
D.DJF = nmean(D.DJFm);
N.DJF = nmean(N.DJFm);
%C.DJF = nmean(C.DJFm);

%MAM
G.MAMm = G.X(G.MAMind, :);
G2.MAMm = G2.X(G2.MAMind, :);
D.MAMm = D.X(D.MAMind, :);
N.MAMm = N.X(N.MAMind, :);
%C.MAMm = C.X(C.MAMind, :);

G.MAM = nmean(G.MAMm);
G2.MAM = nmean(G2.MAMm);
D.MAM = nmean(D.MAMm);
N.MAM = nmean(N.MAMm);
%C.MAM = nmean(C.MAMm);

%JJA
G.JJAm = G.X(G.JJAind, :);
G2.JJAm = G2.X(G2.JJAind, :);
N.JJAm = N.X(N.JJAind, :);
D.JJAm = D.X(D.JJAind, :);

G.JJA = nmean(G.JJAm);
G2.JJA = nmean(G2.JJAm);
N.JJA = nmean(N.JJAm);
D.JJA = nmean(D.JJAm);

%% Set up for plotting
cmap = flipud(cbrewer('div','RdYlBu',31)); %Colormap

%DATA = cell{9,1};
DATA{1} = N.DJF; % Panel 1 - Raw DJF
%ax{1} = [1,4,7];
DATA{2} = N.MAM; % Panel 2 - Raw MAM
%ax{2} = [2,5,8];
DATA{3} = N.JJA; % Panel 3 - Raw JJA
%ax{3} = [3,6,9];
DATA{4} = G2.DJF; % Panel 4 - GraphEM GLASSO DJF
%ax{4} = [10,13,16];
DATA{5} = G2.MAM; % Panel 5 - GraphEM GLASSO MAM
%ax{5} = [11,14,17];
DATA{6} = G2.JJA; % Panel 6 - GraphEM GLASSO JJA
%ax{6} = [12,15,18];
DATA{7} = G.DJF; % Panel 7 - GraphEM Neigh DJF
DATA{8} = G.MAM; % Panel 8 - GraphEM Neigh MAM
DATA{9} = G.JJA; % Panel 9 - GraphEM Neigh JJA
DATA{10} = D.DJF; % Panel 10 - CW DJF
%ax{7} = [19,22,25];
DATA{11} = D.MAM; % Panel 11 - CW MAM
%ax{8} = [20,23,26];
DATA{12} = D.JJA; % Panel 12 - CW JJA
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
		title('DJF 1877');
	elseif ii == 2
		title('MAM 1911');
	elseif ii == 3
		title('JJA 1942');
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


otagf = './figs/comparison_4x3_sp60_sp80.jpeg';
otag = './figs/comparison_4x3_sp60_sp80.pdf';
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk')

























