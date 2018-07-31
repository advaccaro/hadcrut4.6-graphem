% Plot neighborhood graph 

% Load adjacency matrix
load('/home/geovault-02/avaccaro/hadCRUT4.6/ensemble/data/had46med_cr1500_adj.mat')
% Load geographic coordinates
load('/home/geovault-02/avaccaro/hadCRUT4.6/data/had46med_sp80_merra_krig.mat')
lon = loc(:,1);
lon(lon<0) = lon(lon<0) + 360;
lat = loc(:,2);

% Assemble graph, get degree matrix, and Laplacian
G = graph(adjR);
D = degree(G);
n = length(D);
D_mat = D - zeros(n,n);


% plot Degrees
fig('Neighborhood graph Degrees'); clf;
m_proj('Robinson','clong',180);
m_pcolor(lon, lat, D_mat);
m_coast('color','k');
m_grid('tickdir','out','linewi',2, 'edgecolor', 'none');
colormap(flipud(hot))

% Make colorbar
hcb = colorbar('northoutside');
title(hcb, 'Degree of Neighborhood Graph');
set(hcb, 'pos' ,get(hcb,'pos')+[.2 .05 -.4 0], 'tickdir', 'out')

% Print figure
outfile = '/home/geovault-02/avaccaro/hadCRUT4.6/figs/had46med_cr1500_degrees.jpeg';
print(outfile,'-djpeg','-r500');
