%pseudoworld_graphem_sp_CV_step2.m
function [Xg_k] = pseudoworld_graphem_sp_CV_step2(dataset,datatype,worldnum,truth,sparsity, Kfold)

tic;

%% Initialize
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
Kfold = Kfold
truth = truth
target_spars = sparsity
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

%convert time axis to fractional and select calibration period
sertime1850 = double(PW.time); %serial time in days since Jan-0-1850
time0 = datenum('Jan-0-1850');
sertime0 = time0 + sertime1850; %serial time in days since Jan-0-0000
tvec = datevec(sertime0); %date vector
tfrac = tvec(:,1) + tvec(:,2)/12 - 1/12; %convert date vector to fractional time axis
tcal = tfrac(tfrac >= 1960 & tfrac < 1991); %calibration period
calib = ismember(tfrac,tcal); %calibration index

%Load KCV indices
CVindicestag = [finalname '_KCV_INDICES.mat'];
CVindicespath = [odir CVindicestag];
load(CVindicespath)


%select non empty grid points (actually, select points w/ >20% coverage)
[ntime,nspace] = size(PW.grid_2d);
test = ~isnan(PW.grid_2d);
Stest = sum(test,1);

index = find(Stest > (1/10)*ntime); %select points w/ > (1/Kcv)% coverage (to prevent failure due to empty columns during GraphEM)

%% GraphEM stage

%GraphEM options
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.useggm = 1;

% GraphEM part 1: Neighborhood graph (900km)
target_cr = 900;
CRkfoldtag = [finalname '_SPCV_cr' num2str(target_cr) '_k' num2str(Kfold) '.mat'];
CRkfoldpath = [odir CRkfoldtag];
load(CRkfoldpath)

% GraphEM part 2: GLASSO
N = 100; %number of iterations for greedy search
Xcal = Xcr_k(calib,:); %select calibration period
S = corrcoef(Xcal); %sample covariance matrix
[spars,adj] = greedy_search_TT(S,target_spars,N);
spars_f = spars(end); adjM = adj{end};
opt.adj = adjM;
[Xg_k, Mg_k, Cg_k] = graphem_JW(Xcv{Kfold},opt);
SPkfoldtag = [finalname '_SPCV_sp' num2str(target_spars*100) '_k' num2str(Kfold) '.mat'];
SPkfoldpath = [odir SPkfoldtag];
runtime = toc;
save(SPkfoldpath, 'Xg_k', 'target_spars', 'adjM', 'spars_f', 'runtime');





