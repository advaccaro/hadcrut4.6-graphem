function had46med_graphem_merra_krig_sp_full(sparsity)
%had46med_graphem_merra_krig_sp_full.m
%USC Climate Dynamics Lab - Fall 2018
%Author: Adam Vaccaro
%Purpose: Run GraphEM infilling on HadCRUT4.6 median starting with Cowtan & Way's
%kriging-infilled version to estimate the covariance structure of the field
%that is required input for the GLASSO-based GraphEM imputations.

tic;
%% Add paths to necessary functions
homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(homedir))
%addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
indir = [homedir 'data/'];
infile = 'had46med.mat';
inpath = [indir infile];
load(inpath)

cwpath = [homedir 'cw17/data/cw17.mat'];
cwspath = [homedir 'cw17/data/cw17_short.mat'];
load(cwpath)
load(cwspath)

%% Set script parameters and outpaths
target_spars = sparsity; %target sparsity
outdir = indir;
adjtag = [outdir 'had46med_sp' num2str(target_spars*100) '_merra_krig_adj.mat'];
sptag = [outdir 'had46med_full_sp' num2str(target_spars*100) '_merra_krig.mat'];

%% Estimate correlation matrix
C0 = corrcoef(cw17s.temp2d); %estimate correlation coefficients matrix
N = 50; %maximum iterations
[spars, adj] = greedy_search_TT(C0,target_spars,N); %estimate adjacency matrix using greedy search
spars_f = spars(end); adjM = adj{end}; %estimated sparsity and adjacency matrix

clear adj spars
%load(adjtag)

% Produce a "well"-conditioned C
opt.ggm_tol = 5e-3;
opt.ggm_maxit = 200;
opt.ggm_thre  = 50;
opt.adj = adjM;
[Cg,sp_level] = Sigma_G(C0,opt);

save(adjtag, 'spars_f', 'adjM', 'Cg', 'target_spars');

%load(adjtag);

%% GraphEM (GLASSO)
X = rawH46med;

%% Setup for X0
[cn, ~] = size(cw17.temp2d);
X0 = X; 
X0(1:cn,:) = cw17.temp2d; %


%% GraphEM
%GraphEM options
%opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 100;
opt.useggm = 1;
opt.adj = adjM;
opt.C0 = Cg;
opt.Xmis0 = X0;

[SP1.X, SP1.M, SP1.C, SP1.kavl, SP1.kmisr, SP1.iptrn, SP1.peff, SP1.D, SP1.Cf] = graphem(X, opt);

runtime = toc; %runtime in seconds
	
save(sptag, 'SP1', 'loc', 'H46med', 'target_spars', 'spars_f', 'runtime')





