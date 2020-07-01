% pseudoworld1_lsat_graphem_sp_2step.m
% ******WARNING******: target_spars must be defined in .pbs script!!!

addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))

%load('ccsm4_5x5_global_fields_hist.mat') %contains ocean pts indices
%ocean = ocean;
%land = ones(size(ocean));
%land = land - ocean;



indir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/pseudoworld1/data/';
inname = 'pseudoworld1_lsat.mat';
inpath = [indir inname];
odir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/pseudoworld1/lsat/data/';
%oname = 'pseudoworld1_lsat_graphem_cr800.mat';
%opath = [odir oname];
%onename = 'pseudoworld1_lsat_graphem_cr800_step1.mat';
onepath = [odir 'pseudoworld1_lsat_graphem_sp' num2str(target_spars*100) '_step1.mat'];
%twoname = 'pseudoworld1_lsat_graphem_cr800_step2.mat';
twopath = [odir 'pseudoworld1_lsat_graphem_sp' num2str(target_spars*100) '_step2.mat'];

adjdir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/pseudoworld1/lsat/data/';
adjtag = [adjdir 'pseudoworld1_lsat_adj_sp' num2str(target_spars*100) '.mat'];
load(adjtag)

%load pseudo world data
load(inpath)

%find land pts
allvs = [1:2592]; nv = length(allvs);
clear n; n=1;
for i = 1:nv
if sum(~isnan(PW1_lsat.grid_2d(:,i))) > .2*numel(PW1_lsat.grid_2d(:,i))
land(n) = i;
n=n+1;
end
end

X = PW1_lsat.grid_2d(:,land);
PW1_lsat.land = land;
PW1_lsat.tser = double(PW1_lsat.time) + datenum('1850-1-1');
PW1_lsat.tvec = datevec(PW1_lsat.tser);
PW1_lsat.tfrac=PW1_lsat.tvec(:,1)+PW1_lsat.tvec(:,2)/12-1/12;
%separate into recent and historic
tfrac = PW1_lsat.tfrac;
trec = tfrac(tfrac >= 1925);
thist = tfrac(tfrac < 1925);
indrec = ismember(tfrac,trec);
indhist = ismember(tfrac,thist);
Xrec = X(indrec,:);
Xhist = X(indhist,:);


%cutoff radius
target_cr = 800;

%Coordinates
lonlat = double(PW1_lsat.loc(land,:));
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

save(onepath, 'Xcon','Xout', 'Mout', 'Cout', 'PW1_lsat')

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

save(twopath, 'Xf', 'Mf', 'Cf', 'PW1_lsat')



