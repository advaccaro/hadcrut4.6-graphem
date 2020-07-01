% pseudoworld1_sst_graphem_sp_CM.m
% Cross-validation of target sparsity for GraphEM
%tic
%% Initialize
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
%addpath('/home/scec-02/julieneg/matlib/graphem')

Scases = [.25:.25:3];
%Scases2 = [1.25:.25:3];
%Scases = horzcat(Scases,Scases2);
Ncases = length(Scases);


% Load raw data
raw = load('pseudoworld1_sst.mat');

Xraw = raw.PW1_sst.grid_2d; %raw 2D data matrix (w/ missing vals)
Xraw = center(Xraw); [ntime,nspace] = size(Xraw);
loc = raw.PW1_sst.loc; lats = loc(:,2);
lats_2d = repmat(lats, [1 ntime]);
lats_2d = lats_2d'; %time x space


%Load infilled example to obtain useful meta data
infilled = load('pseudoworld1_sst_graphem_sp25_step2.mat');
index = infilled.PW1_sst.ocean; %index of non-empty grid points
nstations = length(index);
%test_ind = randi(nstations,100,1);
test_ind = index(1:100); ntest = length(test_ind);
indCol_test = [1:ntest];
[train,test,nin] = kcv_indices(indCol_test,10,'blocks');
%indCol = [1:nstations];
%[train,test,nin] = kcv_indices(indCol,10,'blocks');



%Set variables
Kcv = 10; %number of folds

%for j = 1:Nsteps
for r = 1:Ncases
	for i = 1:Kcv
		% Load infilled data
		loadtag = ['pseudoworld1_sst_graphem_sp' num2str(Scases(r)*100) '_step2.mat'];
		h4inf{r} = load(loadtag);
		%display(['h4inf{' num2str(r) '} = ' loadtag])
		h4inf{r}.Xc = center(h4inf{r}.Xf);
		ocean = h4inf{r}.PW1_sst.ocean;
		%Xin = Xraw(:,ocean); %select non-empty grid cells
		Xin = Xraw(:,test_ind);	
		[nt,np] = size(Xin);
		indavl1 = ~isnan(Xin);
		ida = train{i}; idm = test{i};
		%ida = randsample(np,floor(np/Kcv)); %index of available
		%idm = setdiff([1:np],ida); %index of missing

		%X_a = Xin(:,ida); %training sample
		%indavl_a = ~isnan(X_a);
		%lats_a = lats_2d(:,ida); %lats_in = lats_k(indavl2);
		lats_m = lats_2d(:,ocean); lats_m = lats_m(:,idm);
		%lats_in = lats_2d(idm,;);
		X_m = Xin(:,idm);

		%% Prediction stage (predict withheld data)
		B = ols(h4inf{r}.Cf, ida, idm);

		Y{r} = h4inf{r}.Xc(:,ida)*B;





		%mse0 = (X_k(indavl2)-Y{r}(indavl2)).^2;
		mse0 = (X_m - Y{r}).^2;
		indavl_t = ~isnan(mse0);
		lats_t = lats_m(indavl_t);
		mse_t = mse0(indavl_t);
		f_num(r,i) = nsum(nsum(mse_t.*cosd(lats_t)));
		f_den(r,i) = nsum(nsum(cosd(lats_t)));
		f_mse(r,i) = f_num(r,i)/f_den(r,i);

	end
end
%err(r,i) = nmean(nmean((X_k(indavl2)-Y{r}(indavl2)).^2));
%err(r,i) = nmean(nmean((X_k(indavl2) - Y{r}(indavl2)).^2)); %MSE

%err3(r,i) = nsum(nsum((X_k(indavl2)-Y{r}(indavl2)).^2
%err3(r,i) = nsum(err0*cos(lats_in)
%[bias(r,i),varsig(r,i),err2(r,i)] = MSE_decomp(X_k(indavl2), Y{r}(indavl2));


for r = 1:Ncases
	%% Cross-validation stage
	%epe(r) = (1/Kcv) * sum(err(r,:));
	%epe2(r) = (1/Kcv) * sum(err2(r,:));
	epe3(r) = (1/Kcv) * sum(f_mse(r,:));
	%epv(r) = (1/Kcv) * sum(varsig(r,:))/10;
	%epvs(r) = (epv(r))^(.5);
	%sigg(r) = std(err(r,:));
	%sigg2(r) = std(err2(r,:));
	sigg3(r) = std(f_mse(r,:));
	%epe(r) = (1/Kcv) * sum(err(r,:));
	%epe2(r) = (1/Kcv) * sum(err2(r,:));
	%epv(r) = (1/Kcv) * sum(varsig(r,:))/10;
	%epvs(r) = (epv(r))^(.5);
	%sigg(r) = std(err(r,:));

end
%end
%end
%for r = 1:Ncases
%epef(r) = (1/nit) * sum(epe(r,:));
%epe2f(r) = (1/nit) * sum(epe2(r,:));
%epvf(r) = (1/nit) * sum(epv(r,:));
%epvsf(r) = (1/nit) * sum(epvs(r,:));
%siggf(r) = (1/nit) * sum(sigg(r,:));
%siggf(r) = std(epe(r,:));
%end

%for r = 1:Ncases
%siggf(r) = std(epe(r,:));
%end

%plot(Rcases,epe,Rcases,epe+2*epvs,Rcases,epe-2*epvs)
fig('pseudoworld1 sst CV scores')
hold on
%plot(Scases,epe,'ko-')
%plot(Scases,epe-sigg,'k--')
%plot(Scases,epe+sigg,'k--')
%plot(Scases,epe2,'ro-')
%plot(Scases,epe2-sigg2,'r--')
%plot(Scases,epe2+sigg2,'r--')
plot(Scases,epe3,'go-')
plot(Scases,epe3-sigg3,'g--')
plot(Scases,epe3+sigg3,'g--')
fancyplot_deco('10-fold Cross-validation scores for choosing target sparsity (Pseudo-world 1 sst)', 'Target sparsity', 'Average MSE', 14, 'Helvetica');
%hepta_figprint('had4med_graphemsp_co_rr_all_CVscores.eps')

%fig('3')
%hold on
%plot(Scases,epef,'ko-')
%plot(Scases,epef-siggf,'k--')
%plot(Scases,epef+siggf,'k--')
%fancyplot_deco('10-fold Cross-validation scores for choosing target sparsity', 'Target sparsity', 'Average MSE', 14, 'Helvetica');
%hepta_figprint('had4med_graphemsp_co_rr_all_CVscores_MC100_v3.eps')


savedir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/pseudoworld1/sst/data/';
savetag = 'pseudoworld1_sst_CVscores10.mat';
savepath = [savedir savetag];
save(savepath,'Scases', 'epe3', 'sigg3', 'train', 'test')
%save(savepath, 'epe', 'sigg', 'err', 'Scases', 'epe3', 'sigg3')

%toc

