%had46med_graphem_4step_CW_GL.m
%USC Climate Dynamics Lab - Spring 2018
%Author: Adam Vaccaro
%Purpose: Run GraphEM infilling on HadCRUT4.6 median starting with Cowtan & Way's
%kriging-infilled version to estimate the covariance structure of the field
%that is required input for the GLASSO-based GraphEM imputations.

tic;
%% Add paths to necessary functions
%addpath(genpath('/home/geovault-00/rverna/hadCRUT4.6/'))
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
%addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
%homedir = '/home/geovault-00/rverna/hadCRUT4.6/'
%homedir = '/home/scec-02/avaccaro/hadCRUT4.6/';
homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
%indir = '/home/geovault-00/rverna/hadCRUT4.6/data/';
indir = [homedir 'data/'];
%infile = ['HadCRUT.4.3.0.0.anomalies.' num2str(filenum) '.mat'];
infile = 'had46med.mat';
inpath = [indir infile];
load(inpath)

cwpath = [homedir 'cw17/data/cw17.mat'];
cwspath = [homedir 'cw17/data/cw17_short.mat'];
load(cwpath)
load(cwspath)

%% Set script parameters and outpaths
%target_spars = .8; %target sparsity
%outdir = '/home/geovault-00/rverna/hadCRUT4.6/data/';
cutoff_radius = 1000; %1000km cutoff radius
outdir = indir;
adjtag = [outdir 'had46med_cr' num2str(cutoff_radius) '_merra_krig_adj.mat'];
crtag = [outdir 'had46med_full_cr' num2str(cutoff_radius) '_merra_krig.mat'];


%% Get calibration data from CW
%cwtfrac = cw13.tfrac;
%tcal = cwtfrac(cwtfrac >= 1960 & cwtfrac < 1991); %calibration period
%calib = ismember(cwtfrac,tcal); %calibration index
%Xcal = cw13.temp2d(calib,:);

%% Estimate correlation matrix
%C0 = corrcoef(cw17s.temp2d); %estimate correlation coefficients matrix
%N = 50; %maximum iterations
%[spars, adj] = greedy_search_TT(C0,target_spars,N); %estimate adjacency matrix using greedy search
%spars_f = spars(end); adjM = adj{end}; %estimated sparsity and adjacency matrix

%clear adj spars
%load(adjtag)

%% Produce a "well"-conditioned C
%opt.ggm_tol = 5e-3;
%opt.ggm_maxit = 200;
%opt.ggm_thre  = 50;
%opt.adj = adjM;
%[Cg,sp_level] = Sigma_G(C0,opt);

adjR = neigh_radius_adj(loc, 1000);
opt.adj = adjR;

save(adjtag, 'cutoff_radius', 'adjR');

%load(adjtag);

%% GraphEM (GLASSO)
X = rawH46med;

%% Setup for X0
[cn, ~] = size(cw17.temp2d);
X0 = X; 
X0(1:cn,:) = cw17.temp2d; %


%% GraphEM SP Part 1
%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 100;
opt.useggm = 1;
opt.adj = adjR;
%opt.C0 = Cg;
opt.Xmis0 = X0;

%[SP1.X,SP1.M,SP1.C,SP1.B,SP1.S,SP1.kavl,SP1.kmisr,SP1.iptrn,SP1.peff,SP1.D,SP1.Cf] = graphem_JW(X,opt);
[CR.X, CR.M, CR.C, CR.kavl, CR.kmisr, CR.iptrn, CR.peff, CR.D, CR.Cf] = graphem(X, opt);

runtime = toc; %runtime in seconds
	
save(crtag, 'CR', 'loc', 'H46med', 'cutoff_radius', 'adjR', 'runtime')
clear CR opt




