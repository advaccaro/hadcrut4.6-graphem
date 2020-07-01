%pseudoworld2_sst_graphem_cr800.m

addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.2/'))

load('ccsm4_5x5_global_fields_hist.mat') %contains ocean pts indices
ocean = ocean;
land = ones(size(ocean));
land = land - ocean;



indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
inname = 'pseudoworld2_sst.mat';
inpath = [indir inname];
odir = indir;
oname = 'pseudoworld2_sst_graphem_cr800.mat';
opath = [odir oname];

%load pseudo world data
load(inpath)
X = PW1_sst.grid_2d(:,ocean);
%cutoff radius
target_cr = 800;

%Coordinates
lonlat = double(PW2_sst.loc(ocean,:));
lon = lonlat(:,1);
lat = lonlat(:,2);

%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 100;
opt.lonlat = lonlat;
opt.useggm = 1;

adjR = neigh_radius_adj(lonlat,target_cr);
opt.adj = adjR;
[Xout, M, C] = graphem_JW(X,opt);


save(opath, 'Xout', 'M', 'C', 'PW1')


