%pseudoworld_graphem_sp_CV.m
function [epe,sigg] = pseudoworld_graphem_sp_CV(dataset,datatype,worldnum,Scases,Kcv)



% Cross-validation of target sparsity for GraphEM w/ GLASSO
tic

%% Initialize
homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/'
addpath(genpath(homedir))

worldname = ['pseudoworld' num2str(worldnum)];
fullname = [worldname '_' datatype];
basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
odir = [basedir worldname '/' datatype '/data/'];

Ncases = length(Scases);

% Set up output matrices
Xg = cell(Kcv, Ncases);
Mg = cell(Kcv, Ncases);
Cg = cell(Kcv, Ncases);

% Load raw data data matrix
raw = load(dataset);
PW = identifyPW(raw, worldnum, datatype);

%raw = load('pseudoworld1_sst.mat');
[ntime,nspace] = size(PW.grid_2d);
time = double(PW.time);
startdate = datenum('0-Jan-1850');
tser = time + startdate; %serial time axis
tvec = datevec(tser); %time vector
tfrac = tvec(:,1) + (tvec(:,2) - 1)/12; %fractional time axis
% tcal = tfrac(tfrac >= 1960 & tfrac < 1991); %calibration period (1960-1990)
% calib = ismember(tfrac,tcal);

%select non empty grid points (actually, select points w/ >20% coverage)
test = ~isnan(PW.grid_2d);
Stest = sum(test,1);
index = find(Stest > (1/Kcv)*ntime); %select points w/ > (1/Kcv)% coverage (to prevent failure due to empty columns during GraphEM)
%index = find(Stest == ntime); %select COMPLETE rows
Nindex = length(index);

Xgrid = nan(ntime,Nindex); %preallocate space

for i = 1:ntime
	Xgrid(i,:) = PW.grid_2d(i,index); %matrix of non empty grid boxes
end


[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid,Kcv);

%calculate adjacency matrix for neighborhood graph
lonlat = double(PW.loc(index,:));
lats = lonlat(:,2); %needed later on for computing global average
lats_2d = repmat(lats, [1 ntime]); lats_2d = lats_2d'; %time x space

% Load CW14 dataset
% cwpath = [homedir 'cw17/data/cw17.mat']
cwspath = [homedir 'cw17/data/cw17_short.mat']
load(cwspath)
% Correct tfrac (THIS IS MIGHT HAVE CAUSED PROBLEMS ELSE WHERE)
%cw17s.tfrac = double(cw17s.year) + (double(cw17s.month)-1)/12;
cw17s_red = cw17s.temp2d(:,index);

%% Estimate correlation matrix
'Estimating correlation matrix'
toc
C0 = corr(cw17s_red); %estimate correlation coefficients matrix
greedy_maxit = 50; %maximum iterations

%Sigma_G options
sigma_opt.ggm_tol = 5e-3;
sigma_opt.ggm_maxit = 200;
sigma_opt.ggm_thre = 50;
sigma_opt.adj = 0; %placeholder

% GraphEM options
opt.stagtol = 5e-3;
opt.maxit = 100;
opt.useggm = 1;
opt.adj = 0; % placeholder

%for k = 1:Kcv
%	for n = 1:Ncases
'Beginning loop'
toc
for n = 1:Ncases
	['n:' num2str(n)]
	target_spars = Scases(n);
	% Estimate concentration graph using greedy search
	'Estimate concentration graph using greedy search'
	toc
	'Update'
	[spars, adj] = greedy_search_TT(C0, target_spars, greedy_maxit);
	'Greedy search complete'
	spars_f = spars(end);
	adjM = adj{end};
	opt = rmfield(opt, 'adj');
	opt.adj = adjM;

	% Produce a well-conditioned C
	'Producing a well-conditioned C'
	sigma_opt = rmfield(sigma_opt, 'adj');
	sigma_opt.adj = adjM;
	[Cw,sp_level] = Sigma_G(C0,sigma_opt);
	'Sigma_G Complete'
	opt.C0 = Cw;

	for k = 1:Kcv
		['Fold:' num2str(k)]
		toc
		% save concentration graph
		adjtag = [fullname 'adj_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
		adjpath = [odir adjtag];
		save(adjpath, 'spars_f', 'adjM', 'Cg', 'target_spars')

		% Run GraphEM
		'Running GraphEM'
		toc
		[Xg{k,n},Mg{k,n},Cg{k,n}] = graphem(Xcv{k},opt);
		'Finished GraphEM'
		Xg_kn = Xg{k,n};
		'Extracted Xg_kn'
		SPkfoldtag = [fullname '_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
		SPkfoldpath = [odir SPkfoldtag];
		'Saving...'
		save(SPkfoldpath, 'Xg_kn', 'target_spars', 'adjM', 'index');
		'Saved results'
		toc
		clear Xg_kn;
	end
end
'Loop end'
toc

indavl_t = ~isnan(Xgrid);
lats_t = lats_2d(indavl_t);
weights = cosd(lats_t);
normfac = nsum(nsum(weights));

%% Cross-validation stage
'Cross-validaiton stage'
toc
for k = 1:Kcv
	for n = 1:Ncases
		mse0{k,n} = (Xg{k,n} - Xgrid).^2;
		mse_t{k,n} = mse0{k,n}(indavl_t);
		f_num(k,n) = nsum(nsum(mse_t{k,n}.*weights));
		f_mse(k,n) = f_num(k,n)/normfac;
	end
end

for n = 1:Ncases
	epe(n) = (1/Kcv) * sum(f_mse(:,n));
	sigg(n) = std(f_mse(:,n));
end
runtime = toc;

CVtag = [fullname '_sp_CVscores_v2.mat'];
savepath = [odir CVtag];
save(savepath, 'Scases', 'epe', 'sigg','runtime', 'cv_in', 'cv_out')
