% had43med_graphem_sp_CV.m
% Cross-validation for cutoff radius for GraphEM
function [Xg_k] = had46med_graphem_sp_CV_step2(sparsity,Kfold)

tic;

%% Initialize
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
addpath(genpath('/home/scec-02/avaccaro/GraphEM/'))
%addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/data/';
target_spars = sparsity
Kfold = Kfold


% Load raw data
raw = load('had46med.mat'); Xraw = raw.had46med; [ntime, nspace] = size(Xraw);
tfrac = raw.H46med.tfrac; %fractional time axis

% Load cowtan and way
load('cw17.mat')
load('cw17_short.mat')

% %select non empty grid points (actually, select points w/ >20% coverage)
%test = ~isnan(Xraw); Stest = sum(test,1);
%index = find(Stest > (.2) * ntime); %(all points have >20% coverage thanks to CW update --> this step is unnecessary in this context)

%get KCV indices (KCV indices determined prior to running this script --> LOAD KCV indices)


CVindicestag = 'H46MED_KCV_INDICES.mat';
CVindicespath = [odir CVindicestag];
load(CVindicestag)

%calculate adjacency matrix for neighborhood graph

%% Estimate correlation matrix
C0 = corrcoef(cw17s.temp2d); %estimate correlation coefficients matrix
%N = 50; %number of max iterations for greedy search
%[spars, adj] = greedy_search_TT(C0, target_spars, N);
%spars_f = spars(end); adjM = adj{end}; %estimated sparsity and adjacency matrix

%Load ADJ
load('had46med_sparse_adjs.mat')
%adjs = [.5:.05:1.1]; for some reason, this doesn't work for values greater than .8
adjs = [.5, .55, .6, .65, .7, .75, .8, .85, .9, .95, 1, 1.05, 1.1];
adj_ind = find(adjs == target_spars);
adjM = ADJ(adj_ind).adjacency_matrix;
spars_f = ADJ(adj_ind).estimated_sparsity;
%Cg = ADJ(adj_ind).Cg;

%% GraphEM stage

opt.ggm_tol = 5e-3;
opt.ggm_maxit = 200;
opt.ggm_thre  = 50;
opt.adj = adjM;
[Cg, sp_level] = Sigma_G(C0, opt);

%opt %display options

% GraphEM: GLASSO
X = Xraw;
[n, p] = size(X);

%% Setup for X0
navail = sum(~isnan(X));
nstation = find(navail <.8*n); %less tahn 80% coverage
[cn, ~] = size(cw17.temp2d);
X0 = X;
X0(1:cn, nstation) = cw17.temp2d(:,nstation);

%GraphEM optons
%opt.regress = 'ols';
opt.useggm = 1;
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.adj = adjM;
opt.C0 = Cg;
opt.Xims0 = X0;

[CV.X, CV.M, CV.C, CV.kavl, CV.kmisr, CV.iptrn, CV.peff, CV.D, CV.Cf] = graphem(Xcv{Kfold},opt); 
Xg_k = CV.X;
SPkfoldtag = ['H46MED_SPCV_sp' num2str(target_spars*100) '_k' num2str(Kfold) '.mat'];
SPkfoldpath = [odir SPkfoldtag];
runtime = toc;
save(SPkfoldpath, 'Xg_k', 'CV', 'target_spars', 'adjM', 'spars_f', 'runtime', 'Kfold');
