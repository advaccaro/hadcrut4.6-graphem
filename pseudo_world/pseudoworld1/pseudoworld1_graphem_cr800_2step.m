%pseudoworld1_graphem_cr800_2step.m

addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.2/'))

load('ccsm4_5x5_global_fields_hist.mat') %contains ocean pts indices
ocean = ocean;
land = ones(size(ocean));
land = land - ocean;



indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
inname = 'pseudoworld1.mat';
inpath = [indir inname];
odir = indir;
%oname = 'pseudoworld1_sst_graphem_cr800.mat';
%opath = [odir oname];
onename = 'pseudoworld1_graphem_cr800_step1.mat';
onepath = [odir onename];
twoname = 'pseudoworld1_graphem_cr800_step2.mat';
twopath = [odir twoname];
%load pseudo world data
load(inpath)
X = PW1.grid_2d(:,ocean);
PW1.ocean = ocean;
PW1.tser = double(PW1.time) + datenum('1850-1-1');
PW1.tvec = datevec(PW1.tser);
PW1.tfrac=PW1.tvec(:,1)+PW1.tvec(:,2)/12-1/12;
%separate into recent and historic
tfrac = PW1.tfrac;
trec = tfrac(tfrac >= 1960);
thist = tfrac(tfrac < 1960);
indrec = ismember(tfrac,trec);
indhist = ismember(tfrac,thist);
Xrec = X(indrec,:);
Xhist = X(indhist,:);


%cutoff radius
target_cr = 800;

%Coordinates
lonlat = double(PW1.loc(ocean,:));
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
[Xout, Mout, Cout] = graphem_JW(X,opt);
Xcon = vertcat(Xhist,Xout);

save(onepath, 'Xcon','Xout', 'Mout', 'Cout', 'PW1')

clear opt

%% Step 2
%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 100;
opt.lonlat = lonlat;
opt.useggm = 1;
opt.adj = adjR;
opt.C0 = Cout;

[Xf,Mf,Cf] = graphem_JW(Xcon,opt);

save(twopath, 'Xf', 'Mf', 'Cf', 'PW1')



