%pseudoworld_graphem_sp_CV_step1.m

function [Xcr_k,Mcr_k,Ccr_k] = pseudoworld_graphem_sp_CV_step1(dataset,datatype,worldnum,truth,Kfold)

%% Initialize
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
Kfold = Kfold
truth = truth
worldname = ['pseudoworld' num2str(worldnum)];
fullname = [worldname '_' datatype];
truthname = [fullname '_truth'];
basedir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/';
odir = [basedir worldname '/' datatype '/data/'];

%Load raw data
raw = load(dataset);
if truth == 1
	PW = identifyPWtruth(raw, worldnum, datatype);
	finalname = truthname;
elseif truth == 0
	PW = identifyPW(raw,worldnum,datatype);
	finalname = fullname;
end

%Load KCV indices
CVindicestag = [finalname '_KCV_INDICES.mat'];
CVindicespath = [odir CVindicestag];
load(CVindicespath)

%select non empty grid points (actually, select points w/ >20% coverage)
[ntime,nspace] = size(PW.grid_2d);
test = ~isnan(PW.grid_2d);
Stest = sum(test,1);

index = find(Stest > (1/10)*ntime); %select points w/ > (1/Kcv)% coverage (to prevent failure due to empty columns during GraphEM)

%Calculate adjacency matrix for neighborhood graph
lonlat = double(PW.loc(index,:)); %lonlat_red = lonlat(1:300,:);
target_cr = 900; %cutoff radius for neighborhood graph
adjR = neigh_radius_adj(lonlat,target_cr);

%% GraphEM stage

%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.useggm = 1;
opt.adj = adjR;

[Xcr_k,Mcr_k,Ccr_k] = graphem_JW(Xcv{Kfold},opt);

CRkfoldtag = [finalname '_SPCV_cr' num2str(target_cr) '_k' num2str(Kfold) '.mat'];
CRkfoldpath = [odir CRkfoldtag];
save(CRkfoldpath, 'Xcr_k', 'target_cr', 'Kfold')

