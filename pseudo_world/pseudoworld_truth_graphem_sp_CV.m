%pseudoworld_truth_graphem_sp_CV.m
function [epe,sigg] = pseudoworld_truth_graphem_sp_CV(dataset,datatype,worldnum,Scases,Kcv)



% Cross-validation of target sparsity for GraphEM w/ GLASSO
tic

%% Initialize
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')

worldname = ['pseudoworld' num2str(worldnum)];
fullname = [worldname '_' datatype];
truthname = [fullname '_truth'];
basedir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/';
odir = [basedir worldname '/' datatype '/data/'];



%Crcases = [250:500:3250]; %radii tested 
%Kcv = 10;


Ncases = length(Scases);



% Load raw data data matrix
truth = load(dataset);
PW = identifyPWtruth(truth, worldnum, datatype);

%raw = load('pseudoworld1_sst.mat');
[ntime,nspace] = size(PW.grid_2d);
time = double(PW.time);
startdate = datenum('0-Jan-1850');
tser = time + startdate; %serial time axis
tvec = datevec(tser); %time vector
tfrac = tvec(:,1) + tvec(:,2)/12 - 1/12; %fractional time axis
tcal = tfrac(tfrac >= 1960 & tfrac < 1991); %calibration period (1960-1990)
calib = ismember(tfrac,tcal);

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

%Xgrid_red = Xgrid(1:220,1:300); %select reduced grid for testing
 %indCol = [1:100]; 



[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid,Kcv);
%[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid_red,Kcv);
CVindicestag = [truthname '_CVindices.mat'];
CVindicespath = [odir CVindicestag];
save(CVindicespath, 'Xcv', 'cv_in', 'cv_out');

%calculate adjacency matrix for neighborhood graph
lonlat = double(PW.loc(index,:)); %lonlat_red = lonlat(1:300,:);
lats = lonlat(:,2); %needed later on for computing global average
lats_2d = repmat(lats, [1 ntime]); lats_2d = lats_2d'; %time x space
%lats_2d_red = lats_2d(:,1:300);
target_cr = 900; %cutoff radius for neighborhood graph
N = 100; %number of iterations for greedy search 


%% GraphEM stage

%GraphEM options

opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 30;
opt.useggm = 1;
opt %display options
adjR = neigh_radius_adj(lonlat,target_cr);

for k = 1:Kcv
	% GraphEM part 1: Neighborhood graph (900km)
	opt.adj = adjR;
	[Xcr{k},Mcr{k},Ccr{k}] = graphem_JW(Xcv{k},opt);
	Xcr_k = Xcr{k}; Xcv_k = Xcv{k};
	CRkfoldtag = [truthname '_SPCV_cr' num2str(target_cr) '_k' num2str(k) '.mat'];
	CRkfoldpath = [odir CRkfoldtag];
	save(CRkfoldpath, 'Xcr_k', 'target_cr', 'Xcv_k', 'index');

	for n = 1:Ncases
	% GraphEM part 2: GLASSO
	target_spars = Scases(n);
	Xcal = Xcr{k}(calib,:); %select calibration period
	S = corrcoef(Xcal); %sample covariance matrix
	[spars,adj] = greedy_search_TT(S,target_spars,N);
	spars_f = spars(end); adjM = adj{end};
	opt = rmfield(opt,'adj');
	opt.adj = adjM;
	[Xg{k,n},Mg{k,n},Cg{k,n}] = graphem_JW(Xcv{k},opt);
	Xg_kn = Xg{k,n}; 
	SPkfoldtag = [truthname '_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
	SPkfoldpath = [odir SPkfoldtag];
	save(SPkfoldpath, 'Xg_kn', 'target_spars', 'adjM', 'Xcv_k', 'index');
	clear Xg_kn;
	end
	clear Xcr_k Xcv_k;
end

indavl_t = ~isnan(Xgrid);
lats_t = lats_2d(indavl_t);
%lats_t = lats_2d_red(indavl_t);
weights = cosd(lats_t);	
normfac = nsum(nsum(weights));

%% Cross-validation stage
for k = 1:Kcv
	for n = 1:Ncases
		mse0{k,n} = (Xg{k,n} - Xgrid).^2;
		%mse0{k,n} = (Xcr{k,n} - Xgrid_red).^2;
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


%% Plotting
%figtitle = [worldname ' ' datatype ' CV scores'];
%fig(figtitle)
%plot(Crcases,epe,'ko-'); hold on;
%plot(Crcases,epe-sigg,'ko--'); plot(Crcases,epe+sigg,'ko--');
%fancyplot_deco('10-fold Cross-validation scores for choosing target sparsity (Pseudo-world 1 sst)', 'Target sparsity', 'Average MSE', 14, 'Helvetica');

%CVtag = 'pseudoworld1_sst_cr_CVscores_test_raw_reduced.mat';
CVtag = [truthname '_sp_CVscores_v1.mat'];
savepath = [odir CVtag];
save(savepath, 'Scases', 'epe', 'sigg','runtime')

		
