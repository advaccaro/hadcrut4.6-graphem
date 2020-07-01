%had43med_graphem_4step_CW_GL.m
%USC Climate Dynamics Lab - Spring 2018
%Author: Adam Vaccaro
%Purpose: Run GraphEM infilling on HadCRUT4.3 median starting with Cowtan & Way's
%kriging-infilled version to estimate the covariance structure of the field
%that is required input for the GLASSO-based GraphEM imputations.


%% Add paths to necessary functions
addpath(genpath('/home/scec-02/avaccaro/hadcrut4.6-graphem/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')


%% Open HadCRUT4 and CW datasets
homedir = '/home/scec-02/avaccaro/hadcrut4.6-graphem/'
%indir = '/home/scec-02/avaccaro/hadcrut4.6-graphem/data/';
indir = [homedir 'data/'];
%infile = ['HadCRUT.4.3.0.0.anomalies.' num2str(filenum) '.mat'];
infile = 'had43med.mat';
inpath = [indir infile];
load(inpath)

cwpath = [homedir 'cw2013/data/cw2013.mat'];
load(cwpath)

%% Set script parameters and outpaths
target_spars = .8; %target sparsity
outdir = '/home/scec-02/avaccaro/hadcrut4.6-graphem/graphem_sp/data/';
spadjtag = [outdir 'had43med_sp' num2str(target_spars*100) '_CW_GL_adj.mat'];
sponetag = [outdir 'had43med_sp' num2str(target_spars*100) '_CW_GL_step1.mat'];
sptwotag = [outdir 'had43med_sp' num2str(target_spars*100) '_CW_GL_step2.mat'];

%% Get calibration data from CW
cwtfrac = cw13.tfrac;
tcal = cwtfrac(cwtfrac >= 1960 & cwtfrac < 1991); %calibration period
calib = ismember(cwtfrac,tcal); %calibration index
Xcal = cw13.temp2d(calib,:);

%% Estimate covariance matrix
S = corrcoef(Xcal); %estimate correlation coefficients matrix
N = 150; %maximum iterations
[spars, adj] = greedy_search_TT(S,target_spars,N); %estimate adjacency matrix using greedy search
spars_f = spars(end); adjM = adj{end}; %estimated sparsity and adjacency matrix
save(spadjtag, 'spars_f', 'adjM', 'target_spars');
clear adj spars

% Coordinates
np = length(loc);
lonlat = loc;

%time axes (split into recent/historical)
tfrac = H43med.tfrac;
trec = tfrac(tfrac >= 1925);
thist = tfrac(tfrac < 1925);
indrec = ismember(tfrac,trec);
indhist = ismember(tfrac,thist);
%split temperature data into recent/historical
X = rawH;
Xrec = X(indrec,:);
Xhist = X(indhist,:);


%% GraphEM (GLASSO)
%% GraphEM SP Part 1
%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.useggm = 1;
opt.adj = adjM;
opt.lonlat = lonlat;

[Xo,SP1.M,Co,SP1.B,SP1.S,SP1.kavl,SP1.kmisr,SP1.iptrn,SP1.peff,SP1.D,SP1.Cf] = graphem_JW(Xrec,opt);
Xcon_sp = vertcat(Xhist,Xo);
%assign to structure and save
SP1.X = Xcon_sp; SP1.C = Co;
	
save(sponetag, 'Xrec','Xhist', 'Xcon_sp', 'SP1', 'loc', 'H43med', 'target_spars', 'spars_f')
clear SP1 opt


%% GraphEM SP Part 2
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 40;
opt.useggm = 1;
%opt.err_export = 0;
opt.adj = adjM;
opt.C0 = Co;
opt.lonlat = lonlat;

	[Xf_sp,SP2.Mf,SP2.C,SP2.B,SP2.S,SP2.kavlr,SP2.kmisr,SP2.iptrn,SP2.peff,SP2.D,SP2.Cf] = graphem_JW(Xcon_sp,opt);
%assign to structure and save
SP2.X = Xf_sp; 

save(sptwotag, 'Xf_sp','SP2','target_spars','loc','spars_f','H43med')



