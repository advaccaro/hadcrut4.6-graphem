%pseudoworld3_sst_graphem_cr800_2step.m

addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.2/'))

%load('ccsm4_5x5_global_fields_hist.mat') %contains ocean pts indices
%ocean = ocean;
%land = ones(size(ocean));
%land = land - ocean;



indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/pseudoworld3/data/';
inname = 'pseudoworld3_sst.mat';
inpath = [indir inname];
odir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/pseudoworld3/sst/data/';
%oname = 'pseudoworld3_sst_graphem_cr800.mat';
%opath = [odir oname];
onename = 'pseudoworld3_sst_graphem_cr800_step1.mat';
onepath = [odir onename];
twoname = 'pseudoworld3_sst_graphem_cr800_step2.mat';
twopath = [odir twoname];
%load pseudo world data
load(inpath)

%find ocean pts (> 20% data)
allvs = [1:2592]; nv = length(allvs);
clear n; n=1;
for i = 1:nv
if sum(~isnan(PW3_sst.grid_2d(:,i))) > .2*numel(PW3_sst.grid_2d(:,i))
ocean(n) = i;
n = n+1;
end
end

X = PW3_sst.grid_2d(:,ocean);
PW3_sst.ocean = ocean;
%PW3_sst.land = land;
PW3_sst.tser = double(PW3_sst.time) + datenum('1850-1-1');
PW3_sst.tvec = datevec(PW3_sst.tser);
PW3_sst.tfrac=PW3_sst.tvec(:,1)+PW3_sst.tvec(:,2)/12-1/12;
%separate into recent and historic
tfrac = PW3_sst.tfrac;
trec = tfrac(tfrac >= 1925);
thist = tfrac(tfrac < 1925);
indrec = ismember(tfrac,trec);
indhist = ismember(tfrac,thist);
Xrec = X(indrec,:);
Xhist = X(indhist,:);


%cutoff radius
target_cr = 800;

%Coordinates
lonlat = double(PW3_sst.loc(ocean,:));
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
[Xout, Mout, Cout] = graphem_JW(Xrec,opt);
Xcon = vertcat(Xhist,Xout);

save(onepath, 'Xcon','Xout', 'Mout', 'Cout', 'PW3_sst')

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

save(twopath, 'Xf', 'Mf', 'Cf', 'PW3_sst')



