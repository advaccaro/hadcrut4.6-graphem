%generate_spar_adj_range.m
%USC Climate Dynamics Lab - Summer 2018
%Author: Adam Vaccaro
%Purpose: Generate a series of adjacency matrices from a range of target sparsities in order to visualize the effect of varying sparsity.

tic;
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
indir = [homedir 'data/'];
infile = 'had46med.mat';
inpath = [indir infile];
load(inpath)

cwdir = [homedir 'cw17/data/'];
cwpath = [cwdir 'cw17.mat'];
cwspath = [cwdir 'cw17_short.mat'];
load(cwpath)
load(cwspath)

%% Set script parameters and outpaths
target_spars = [1.25:.25:2.5];
nspars = length(target_spars);
outdir = indir;
outfile = 'had46med_sparse_adjs_large.mat';
outpath = [outdir outfile];

C0 = corrcoef(cw17s.temp2d); %estimate covariance matrix
N = 75; %maximum iterations

opt.ggm_tol = 5e-3;
opt.ggm_maxit = 200;
opt.ggm_thre  = 50;

%% Generate adjacency matrices
for ii = 1:nspars
	target = target_spars(ii);
	[spars, adj] = greedy_search_TT(C0, target, N); %estimate adjacency matrix using greedy search
	spars_f = spars(end); %estimated sparsity
	adjM = adj{end}; %estimated adjacency matrix
	ADJ(ii).target_sparsity = target;
	ADJ(ii).estimated_sparsity = spars_f;
	ADJ(ii).adjacency_matrix = adjM;
	opt.adj = adjM;
	ADJ(ii).Cg = Sigma_G(C0,opt);
	clear adj spars spars_f adjM target opt.adj
end

toc
%% Save output
save(outfile, 'ADJ');
	
	
	
