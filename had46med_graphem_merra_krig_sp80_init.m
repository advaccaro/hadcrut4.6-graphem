%had46med_graphem_4step_CW_GL.m
%USC Climate Dynamics Lab - Spring 2018
%Author: Adam Vaccaro
%Purpose: Run GraphEM infilling on HadCRUT4.3 median starting with Cowtan & Way's
%kriging-infilled version to estimate the covariance structure of the field
%that is required input for the GLASSO-based GraphEM imputations.

tic;
%% Add paths to necessary functions
%addpath(genpath('/home/geovault-00/rverna/hadCRUT4.6/'))
%addpath(genpath('/home/scec-02/avaccaro/hadCRUT4.6/'))
addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))
addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
%homedir = '/home/geovault-00/rverna/hadCRUT4.6/'
%homedir = '/home/scec-02/avaccaro/hadCRUT4.6/';
homedir = '/home/geovault-02/avaccaro/hadCRUT4.6/';
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
%sptag = [outdir 'had46med_sp' num2str(target_spars*100) '_merra_krig.mat'];

%% Estimate correlation matrix
C0 = corrcoef(cw17s.temp2d); %estimate correlation coefficients matrix
N = 50; %maximum iterations
[spars, adj] = greedy_search_TT(C0,target_spars,N); %estimate adjacency matrix using greedy search
spars_f = spars(end); adjM = adj{end}; %estimated sparsity and adjacency matrix
clear adj spars
%load(adjtag)

%% Produce a "well"-conditioned C
opt.ggm_tol = 5e-3;
opt.ggm_maxit = 200;
opt.ggm_thre  = 50;
opt.adj = adjM;
[Cg,sp_level] = Sigma_G(C0,opt);
init_time=toc; %runtime in seconds
save(adjtag, 'spars_f', 'adjM', 'Cg', 'target_spars', 'sp_level', 'init_time');






