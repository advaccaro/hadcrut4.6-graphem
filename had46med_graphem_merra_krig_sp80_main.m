%had46med_graphem_merra_krig_sp80_step2.m
%USC Climate Dynamics Lab - Spring 2018
%Author: Adam Vaccaro
%Purpose: Run GraphEM infilling on HadCRUT4.3 median starting with Cowtan & Way's
%kriging-infilled version to estimate the covariance structure of the field
%that is required input for the GLASSO-based GraphEM imputations.

tic;
%% Add paths to necessary functions
%addpath(genpath('/home/geovault-00/rverna/hadCRUT4.6/'))
%addpath(genpath('/home/scec-02/avaccaro/hadCRUT4.6/'))
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
%homedir = '/home/geovault-00/rverna/hadCRUT4.6/'
%homedir = '/home/scec-02/avaccaro/hadCRUT4.6/';
homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
indir = [homedir 'data/'];
infile = 'had46med.mat';
inpath = [indir infile];
load(inpath)

cwpath = [homedir 'cw17/data/cw17.mat'];
cwspath = [homedir 'cw17/data/cw17_short.mat'];
load(cwpath)
load(cwspath)

%% Set script parameters and outpaths
target_spars = .8; %target sparsity
outdir = indir;
adjtag = [outdir 'had46med_sp' num2str(target_spars*100) '_merra_krig_adj.mat'];
sptag = [outdir 'had46med_50p_sp' num2str(target_spars*100) '_merra_krig.mat'];

%% Load adjacency matrix and "well"-conditioned C
load(adjtag)

%% Assign X
X = rawH46med; %raw HadCRUT4.6 median
[n,p] = size(X);

%% Setup for X0
navail = sum(~isnan(X));
%nstation = find(navail < n/5); %find cells with less than 20% coverage
%nstation = find(navail < n/2); %less than 50% coverage
nstation = find(navail < .8*n); %less than 80% coverage
[cn, ~] = size(cw17.temp2d);
X0 = X; 
X0(1:cn,nstation) = cw17.temp2d(:,nstation);


%% GraphEM 
%GraphEM options
%opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.useggm = 1;
opt.adj = adjM;
opt.C0 = Cg;
opt.Xmis0 = X0;


[SP1.X, SP1.M, SP1.C, SP1.kavl, SP1.kmisr, SP1.iptrn, SP1.peff, SP1.D, SP1.Cf] = graphem(X, opt);

runtime = toc; %runtime in seconds
	
save(sptag, 'SP1', 'loc', 'H46med', 'target_spars', 'spars_f', 'runtime')
clear SP1 opt




