% had43med_graphem_sp_CV.m
% Cross-validation for cutoff radius for GraphEM
function had46med_graphem_sp_CV(sparsity)

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


for k = 1:Kcv
	SPkfoldtag = ['H46MED_SPCV_sp' num2str(target_spars*100) '_k' num2str(k) '.mat'];
	SPkfoldpath = [odir SPkfoldtag];
	%save(SPkfoldpath, 'Xg_k', 'target_spars', 'adjM', 'Xcv_k', 'spars_f');
	load(SPkfoldpath)	
	%clear Xg_k;
	%clear Xcr_k Xcv_k;
	Xg{k} = Xg_k;
end

%indavl_t = ~isnan(Xraw);
%lats_t = lats_2d(indavl_t);
%lats_t = lats_2d_red(indavl_t);
%weights = cosd(lats_t);	
%normfac = nsum(nsum(weights));

%lat = lats; %assign latitudes
%nlat = length(lat); %number of latitudes
latStep = 20; %latitude step size
latBounds = fliplr([-90:latStep:90]); %define boundaries for latitude bands
nBands = length(latBounds) - 1 %number of latitude bands
%zonalMSE = zeros(Kcv,nBands);
%zonalEPE = zeros(nBands,1);
avail = ~isnan(Xraw);
for k = 1:Kcv

	outAvail = logical(avail.*cv_out{k});
	[Bias(k),Var(k),MSE(k)] = MSE_decomp(Xraw(outAvail), Xg{k}(outAvail));

	for j = 1:nBands
		latUpper = latBounds(j);
		latLower = latBounds(j+1);
		latsIn = lats_2d;
		latsIn(latsIn > latUpper | latsIn <= latLower) = NaN;
		latsIn(~isnan(latsIn)) = 1;
		latsIn(isnan(latsIn)) = 0;
		alat = logical(latsIn .* outAvail);
		[zBias(k,j), zVar(k,j), zMSE(k,j)] = MSE_decomp(Xraw(alat), Xg{k}(alat));
	

	end
end

CVtag = ['H46MED_SP' num2str(target_spars*100) '_CVscores_v2.mat'];
savepath = [odir CVtag];
save(savepath, 'Bias', 'Var','MSE', 'zBias','zVar','zMSE','target_spars', 'spars_f')





%fig('MSE plot');




%for j = 1:nBands
%	zonalEPE1(j) = (1/Kcv) * sum(f_mse_z(:,j));
%	zonalEPE2(j) = (1/Kcv) * sum(zMSE2(:,j));
%	zonalEPE3(j) = (1/Kcv) * nsum(zMSE3(:,j));
%	zonalSigg1(j) = std(f_mse_z(:,j));
%	zonalSigg2(j) = std(zMSE2(:,j));
	%zonalSigg3(j) = std(zMSE3(:,j)(~isnan(zMSE(:,j))));
%end

%epe1 = (1/Kcv) * sum(f_mse(:));
%EPE = (1/Kcv) * sum(MSE(:));
%EPE2 = (1/Kcv) * sum(MSE2(:));

%sigg1 = std(f_mse(:));
%SIGG = std(MSE);
%SIGG2 = std(MSE2);
%runtime = toc;
	%clear spaceInd spaceIndAvl zWeights zLats zNormFac
	%get space index:
			%latBounds(j)
			%latBounds(j+1)
			%spaceInd{j} = find(lat <= latBounds(j) & lat >= latBounds(j+1));
			%spaceIndAvl{j} = indavl_t(:,spaceInd{j});
			%spaceIndAvl{j} = ind2(:,spaceInd{j});
			%zLats{j} = lats_2d(spaceIndAvl{j});
			%zWeights{j} = cosd(zLats{j});
			%zNormFac(j) = nsum(nsum(zWeights{j}));
			%zMSE{k,j} = mse0{k}(spaceIndAvl{j});
			%f_num_z(k,j) = nsum(nsum(zMSE{k,j}.*zWeights{j}));
			%f_mse_z(k,j) = f_num_z(k,j)/zNormFac(j);
			%[zBias1(k,j), zVar1(k,j), zMSE1(k,j)] = MSE_decomp(Xraw(spaceIndAvl{j}), Xg{k}(spaceIndAvl{j}));
			%[zBias2(k,j), zVar2(k,j), zMSE2(k,j)] = MSE_decomp(Xraw(:,spaceInd{j}), Xg{k}(:,spaceInd{j}));
			%[zBias3(k,j) zVar3(k,j), zMSE3(k,j)] = MSE_decomp(Xraw(ind2(:,spaceInd{j})), Xg{k}(ind2(:,spaceInd{j})));
	%mse0{k} = (Xg{k} - Xraw).^2;
	%mse_t{k} = mse0{k}(indavl_t);
	%f_num(k) = nsum(nsum(mse_t{k}.*weights));
	%f_mse(k) = f_num(k)/normfac;
	%mse1(k) = MSE_decomp(Xraw(cv_out{k}), Xg{k}(cv_out{k}));
	%ind1 = ~isnan(Xraw);
	%ind2 = logical(cv_out{k}.*ind1);
	%mse2(k) = MSE_decomp(Xraw(ind2), Xg{k}(ind2));
	%ind2 = ~isnan(Xg{k});
	%ind3 = ind1.*ind2;
	%mse(k) = MSE_decomp(Xcv{k}(ind1), Xg{k}(ind1));
	%mse_f(k) = MSE_decomp(Xraw, Xg{k});
	%[Bias(k), Var(k), MSE(k)] = MSE_decomp(Xraw(indavl_t), Xg{k}(indavl_t));
	%[Bias1(k), Var1(k), MSE1(k)] = MSE_decomp(Xraw, Xg{k});
	%[Bias2(k), Var2(k), MSE2(k)] = MSE_decomp(Xraw(ind2), Xg{k}(ind2));
%end
%% Plotting
%figtitle = [worldname ' ' datatype ' CV scores'];
%fig(figtitle)
%plot(Crcases,epe,'ko-'); hold on;
%plot(Crcases,epe-sigg,'ko--'); plot(Crcases,epe+sigg,'ko--');
%fancyplot_deco('10-fold Cross-validation scores for choosing target sparsity (Pseudo-world 1 sst)', 'Target sparsity', 'Average MSE', 14, 'Helvetica');

%CVtag = 'pseudoworld1_sst_cr_CVscores_test_raw_reduced.mat';


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
