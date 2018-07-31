%% neigh_glasso_graph_diff.m
clear all

working_dir = '/home/geovault-02/avaccaro/hadCRUT4.6/';
addpath(genpath(working_dir))

%% Load datasets
load had46med.mat %HadCRUT4.6 Raw
load had46med_full_sp80_merra_krig.mat
load had43med_graphem_cr1000_step2.mat
load cw17.mat

%% Set vars
H.t = H46med.tfrac;
G.t = H.t;
N.t = H43med.tfrac;

G.X = SP1.X;
N.X = Xf;

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

H.DJFt = H.t(H.DJFind);
G.DJFt = H.DJFt;
N.DJFt = N.t(N.DJFind);

H.MAMind = find(H.t > mar - 1/100 & H.t < may + 1/100);
G.MAMind = H.MAMind;
N.MAMind = find(N.t > mar - 1/100 & N.t < may + 1/100);

H.MAMt = H.t(H.MAMind);
G.MAMt = H.MAMt;
N.MAMt = N.t(N.MAMind);

H.JJAind = find(H.t > jun - 1/100 & H.t < aug + 1/100); 
G.JJAind = H.JJAind;
N.JJAind = find(N.t > jun - 1/100 & N.t < aug + 1/100);

H.JJAt = H.t(H.JJAind);
G.JJAt = H.JJAt;
N.JJAt = N.t(N.JJAind);

%% Calculate means
%DJF
G.DJFm = G.X(G.DJFind, :);
N.DJFm = N.X(N.DJFind, :);

G.DJF = nmean(G.DJFm);
N.DJF = nmean(N.DJFm);

%MAM
G.MAMm = G.X(G.MAMind, :);
N.MAMm = N.X(N.MAMind, :);

G.MAM = nmean(G.MAMm);
N.MAM = nmean(N.MAMm);

%JJA
G.JJAm = G.X(G.JJAind, :);
N.JJAm = N.X(N.JJAind, :);

G.JJA = nmean(G.JJAm);
N.JJA = nmean(N.JJAm);

D.DJF = G.DJF - N.DJF;
D.MAM = G.MAM - N.MAM;
D.JJA = G.JJA - N.JJA;

%% Set up for plotting
cmap = flipud(cbrewer('div','RdBu',31)); %Colormap

%DATA = cell{9,1};
DATA{1} = D.DJF; % Panel 1 - Difference DJF
%ax{1} = [1,4,7];
DATA{2} = D.MAM; % Panel 2 - Difference MAM
%ax{2} = [2,5,8];
DATA{3} = D.JJA; % Panel 3 - Difference JJA
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

nRows = 10;
nCols = 3;


% Panels 10:12 - Colorbar

%% Plotting

fig('NINO Snapshots'); clf;
%[ha,pos] = tight_subplot(3,3,[.00003 .03],[.003 .003],[.003 .003]);
for ii = 1:9
	%subplot(nRows,nCols,ax{ii});
	subplot(4,3,ii);	
	S = reshape(DATA{ii}',[nlon,nlat])';
	%non_nan = ~isnan(D);
	%axes(ha(ax{ii}));
	%axes(ha(ii));	
	m_proj('Robinson', 'clong', 0);
	m_grid('xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
	m_coast('color','k');
	%m_line(lons,lats);
	hold on;
	p = m_pcolor(lons, lats, S);
	set(p, 'EdgeColor', 'none');
	colormap(cmap);	
	hold off;
	caxis([-10 10]);
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
caxis([-10 10]);
axis('off');


otagf = './figs/nino1878_diff_3x3_6d.jpeg';
otag = './figs/nino1878_diff_3x3_6d.pdf';
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk')



