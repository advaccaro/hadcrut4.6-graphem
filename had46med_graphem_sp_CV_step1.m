%had43med_graphem_sp_CV_step1.m
%Do CR infilling for k-folds

function [Xcr_k,Mcr_k,Ccr_k] = had46med_graphem_sp_CV_step1(Kfold)

%% Initialize
Kfold = Kfold
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
%addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/data/';

%Load raw data
raw = load('had46med.mat'); Xraw = raw.had46med; [ntime, nspace] = size(Xraw);



%Load CV indices
CVindicestag = 'H46MED_KCV_INDICES.mat';
CVindicespath = [odir CVindicestag];
load(CVindicespath)

%Calculate adjacency matrix for neighborhood graph
lonlat = double(raw.loc); lats = lonlat(:,2);
lats_2d = repmat(lats, [1 ntime]);
lats_2d = lats_2d'; %time x space
target_cr = 1000;


%% GraphEM stage

%GraphEM optons
adjR = neigh_radius_adj(lonlat,target_cr);
opt.adj = adjR;
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.useggm = 1;
opt %display options

[Xcr_k,Mcr_k,Ccr_k] = graphem_JW(Xcv{Kfold},opt);

CRkfoldtag = ['H43MED_SPCV_cr' num2str(target_cr) '_k' num2str(Kfold) '.mat'];
CRkfoldpath = [odir CRkfoldtag];
save(CRkfoldpath, 'Xcr_k', 'target_cr', 'Kfold')
