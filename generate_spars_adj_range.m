%generate_spar_adj_range.m
%USC Climate Dynamics Lab - Summer 2018
%Author: Adam Vaccaro
%Purpose: Generate a series of adjacency matrices from a range of target sparsities in order to visualize the effect of varying sparsity.

tic;
addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))
addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
homedir = '/home/geovault-02/avaccaro/hadCRUT4.6/';
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
target_spars = [.5:.05:1.1];
nspars = length(target_spars);
outdir = indir;
outfile = 'had46med_sparse_adjs.mat';
outpath = [outdir outfile];

C0 = corrcoef(cw17s.temp2d); %estimate covariance matrix
N = 50; %maximum iterations

%% Generate adjacency matrices
for ii = 1:nspars
	target = target_spars(ii);
	[spars, adj] = greedy_search_TT(C0, target, N); %estimate adjacency matrix using greedy search
	spars_f = spars(end); %estimated sparsity
	adjM = adj{end}; %estimated adjacency matrix
	ADJ(ii).target_sparsity = target;
	ADJ(ii).estimated_sparsity = spars_f;
	ADJ(ii).adjacency_matrix = adjM;
	clear adj spars spars_f adjM target
end

toc
%% Save output
save(outfile, 'ADJ');
	
	
	
