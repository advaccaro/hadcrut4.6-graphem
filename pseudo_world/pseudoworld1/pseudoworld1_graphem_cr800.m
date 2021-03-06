%pseudoworld1_graphem_cr800.m

addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.2/'))

indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
inname = 'pseudoworld1.mat';
inpath = [indir inname];
odir = indir;
oname = 'pseudoworld1_graphem_cr800.mat';
opath = [odir oname];

%load pseudo world data
load(inpath)
X = PW1.grid_2d;
%cutoff radius
target_cr = 800;

%Coordinates
lonlat = double(PW1.loc);
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


