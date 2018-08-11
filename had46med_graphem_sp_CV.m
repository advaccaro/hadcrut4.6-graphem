% had43med_graphem_sp_CV.m
% Cross-validation for cutoff radius for GraphEM
function [epe, sigg] = had46med_graphem_sp_CV(sparsity)

tic;

%% Initialize
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
%addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')

odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/data/';
target_spars = sparsity

% Load raw data
raw = load('had46med.mat'); 
Xraw = raw.had46med; 
[ntime, nspace] = size(Xraw);
tfrac = raw.H46med.tfrac; %fractional time axis
tcal = tfrac(tfrac >= 1960 & tfrac < 1991); %calibration period (1960-1990)
calib = ismember(tfrac,tcal);

% %select non empty grid points (actually, select points w/ >20% coverage)
%test = ~isnan(Xraw); Stest = sum(test,1);
%index = find(Stest > (.2) * ntime); %(all points have >20% coverage thanks to CW update --> this step is unnecessary in this context)

%get KCV indices (KCV indices determined prior to running this script --> LOAD KCV indices)
Kcv = 10;
%[Xcv,cv_in,cv_out] = kcv_indices2d(Xraw,Kcv);
CVindicestag = 'H46MED_KCV_INDICES.mat';
CVindicespath = [odir CVindicestag];
%save(CVindicespath, 'Xcv', 'cv_in', 'cv_out')
load(CVindicestag)

%calculate adjacency matrix for neighborhood graph
lonlat = double(raw.loc); lats = lonlat(:,2);
lats_2d = repmat(lats, [1 ntime]);
lats_2d = lats_2d'; %time x space
target_cr = 1000;
N = 100; %number of max iterations for greedy search

%% GraphEM stage

%GraphEM optons
adjR = neigh_radius_adj(lonlat,target_cr);
opt.regress = 'ols';
opt.stagtol = 5e-3;
opt.maxit = 50;
opt.useggm = 1;
opt %display options

for k = 1:Kcv
	% GraphEM part 1: Neighborhood graph (900km)
	%opt.adj = adjR;
	%[Xcr{k},Mcr{k},Ccr{k}] = graphem_JW(Xcv{k},opt);
	%Xcr_k = Xcr{k}; Xcv_k = Xcv{k};
	CRkfoldtag = ['H46MED_SPCV_cr' num2str(target_cr) '_k' num2str(k) '.mat'];
	CRkfoldpath = [odir CRkfoldtag];	
	%save(CRkfoldpath, 'Xcr_k', 'target_cr', 'Xcv_k');
	%load(CRkfoldpath)

	% GraphEM part 2: GLASSO
	%Xcal = Xcr{k}(calib,:); %select calibration period
	%S = corrcoef(Xcal); %sample covariance matrix
	%[spars,adj] = greedy_search_TT(S,target_spars,N);
	%spars_f = spars(end); adjM = adj{end};
	%opt = rmfield(opt,'adj');
	%opt.adj = adjM;
	%[Xg{k},Mg{k},Cg{k}] = graphem_JW(Xcv{k},opt); Xg_k = Xg{k}; 
	SPkfoldtag = ['H46MED_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
	SPkfoldpath = [odir SPkfoldtag];
	%save(SPkfoldpath, 'Xg_k', 'target_spars', 'adjM', 'Xcv_k', 'spars_f');
	load(SPkfoldpath)	
	%clear Xg_k;
	%clear Xcr_k Xcv_k;
	Xg{k} = Xg_k;
end

indavl_t = ~isnan(Xraw);
lats_t = lats_2d(indavl_t);
%lats_t = lats_2d_red(indavl_t);
weights = cosd(lats_t);	
normfac = nsum(nsum(weights));

%% Cross-validation stage
for k = 1:Kcv
		mse0{k} = (Xg{k} - Xraw).^2;
		%mse0{k,n} = (Xcr{k,n} - Xgrid_red).^2;
		mse_t{k} = mse0{k}(indavl_t);
		f_num(k) = nsum(nsum(mse_t{k}.*weights));	
		f_mse(k) = f_num(k)/normfac;	
end


epe = (1/Kcv) * sum(f_mse(:));
sigg = std(f_mse(:));

runtime = toc;


%% Plotting
%figtitle = [worldname ' ' datatype ' CV scores'];
%fig(figtitle)
%plot(Crcases,epe,'ko-'); hold on;
%plot(Crcases,epe-sigg,'ko--'); plot(Crcases,epe+sigg,'ko--');
%fancyplot_deco('10-fold Cross-validation scores for choosing target sparsity (Pseudo-world 1 sst)', 'Target sparsity', 'Average MSE', 14, 'Helvetica');

%CVtag = 'pseudoworld1_sst_cr_CVscores_test_raw_reduced.mat';
CVtag = ['H46MED_SP' num2str(target_spars*100) '_CVscores_v1.mat'];
savepath = [odir CVtag];
save(savepath, 'epe', 'sigg','runtime', 'target_spars', 'spars_f')

%% Old plotting and saving stuff below

%m_ind = find(epe == min(epe)); %m_ind2 = find(epe2 == min(epe2));

%save results
%savedir = '/home/scec-02/avaccaro/HadCRUT4.3/graphem_sp/data/';
%savetag = 'had43med_graphem_sp_CVscores.mat';
%savepath = [savedir savetag];
%save(savepath, 'epe' ,'sigg', 'Scases') %, 'epe2', 'sigg2') 


%plot(Rcases,epe,Rcases,epe+2*epvs,Rcases,epe-2*epvs)
%fig('had43med_graphem_sp_CVscores'); clf;
%hold on;
%plot(Scases,epe,'ko-')
%plot(Scases,epe-sigg,'k--')
%plot(Scases,epe+sigg,'k--')
%plot(Scases(m_ind),epe(m_ind),'kx','MarkerSize',20,'LineWidth',5)
%plot(Rcases,epe2,'ro-')
%plot(Rcases,epe2-sigg2,'r--')
%plot(Rcases,epe2+sigg2,'r--')
%plot(Rcases(m_ind2),epe2(m_ind2),'rx','MarkerSize',20,'LineWidth',5)
%plot(Rcases,epe,'r')
%plot(Rcases,epe-sigg,'r--')
%plot(Rcases,epe+sigg,'r--')
%fancyplot_deco('10-fold Cross-validation scores for choosing neighborhood graph', 'Target sparsity (%)', ['Average MSE (' char(176) 'C^{2})']);
%hepta_figprint('./figs/had43med_graphemcr_CV_all.eps')
%printdir = '/home/scec-02/avaccaro/HadCRUT4.3/graphem_sp/figs/';
%printtag = 'had43med_graphemsp_CVscores_60to80';
%printpath = [printdir printtag];
%print('-dtiff', '-noui', '-r250', printpath)
