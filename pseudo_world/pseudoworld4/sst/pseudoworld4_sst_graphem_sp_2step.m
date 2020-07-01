% pseudoworld4_sst_graphem_sp_2step.m
% ******WARNING******: target_spars must be defined in .pbs script!!!

addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))

%load('ccsm4_5x5_global_fields_hist.mat') %contains ocean pts indices
%ocean = ocean;
%land = ones(size(ocean));
%land = land - ocean;



indir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/pseudoworld4/data/';
inname = 'pseudoworld4_sst.mat';
inpath = [indir inname];
odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/pseudoworld4/sst/data/';
%oname = 'pseudoworld4_sst_graphem_cr800.mat';
%opath = [odir oname];
%onename = 'pseudoworld4_sst_graphem_cr800_step1.mat';
onepath = [odir 'pseudoworld4_sst_graphem_sp' num2str(target_spars*100) '_step1.mat'];
%twoname = 'pseudoworld4_sst_graphem_cr800_step2.mat';
twopath = [odir 'pseudoworld4_sst_graphem_sp' num2str(target_spars*100) '_step2.mat'];

adjdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/pseudoworld4/sst/data/';
adjtag = [adjdir 'pseudoworld4_sst_adj_sp' num2str(target_spars*100) '.mat'];
load(adjtag)

%load pseudo world data
load(inpath)

%find ocean pts (> 20% data)
allvs = [1:2592]; nv = length(allvs);
clear n; n=1;
for i = 1:nv
if sum(~isnan(PW4_sst.grid_2d(:,i))) > .2*numel(PW4_sst.grid_2d(:,i))
ocean(n) = i;
n = n+1;
end
end

X = PW4_sst.grid_2d(:,ocean);
PW4_sst.ocean = ocean;
PW4_sst.tser = double(PW4_sst.time) + datenum('1850-1-1');
PW4_sst.tvec = datevec(PW4_sst.tser);
PW4_sst.tfrac=PW4_sst.tvec(:,1)+PW4_sst.tvec(:,2)/12-1/12;
%separate into recent and historic
tfrac = PW4_sst.tfrac;
trec = tfrac(tfrac >= 1925);
thist = tfrac(tfrac < 1925);
indrec = ismember(tfrac,trec);
indhist = ismember(tfrac,thist);
Xrec = X(indrec,:);
Xhist = X(indhist,:);




%Coordinates
lonlat = double(PW4_sst.loc(ocean,:));
lon = lonlat(:,1);
lat = lonlat(:,2);

%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 100;
%opt.lonlat = lonlat;
opt.useggm = 1;
opt.adj = adjM;
%adjR = neigh_radius_adj(lonlat,target_cr);
%opt.adj = adjR;

[Xout, Mout, Cout] = graphem_JW(Xrec,opt);
Xcon = vertcat(Xhist,Xout);

save(onepath, 'Xcon','Xout', 'Mout', 'Cout', 'PW4_sst')

clear opt

%% Step 2
%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 100;
opt.lonlat = lonlat;
opt.useggm = 1;
opt.adj = adjM;
opt.C0 = Cout;

[Xf,Mf,Cf] = graphem_JW(Xcon,opt);

save(twopath, 'Xf', 'Mf', 'Cf', 'PW4_sst')



