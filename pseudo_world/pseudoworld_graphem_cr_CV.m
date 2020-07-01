%pseudoworld_graphem_cr_CV.m
function [epe,sigg] = pseudoworld_graphem_cr_CV(dataset,datatype,worldnum,Crcases,Kcv)


% pseudoworld1_sst_graphem_cr_CV_test.m
% Cross-validation of target sparsity for GraphEM
tic

%% Initialize
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')

worldname = ['pseudoworld' num2str(worldnum)];
basedir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/';
odir = [basedir worldname '/' datatype '/data/'];



%Crcases = [250:500:3250]; %radii tested 
%Kcv = 10;


Ncases = length(Crcases);



testname = [worldname '_' datatype '_graphem_cr_CV_test.mat'];
testpath = [odir testname];

% Load raw data data matrix
raw = load(dataset);
PW = identifyPW(raw, worldnum, datatype);

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

N = 25; %number of iterations for greedy search (quick search for now)

[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid,Kcv);
CVindicestag = [truthname '_CVindices.mat'];
CVindicespath = [odir CVindicestag];
save(CVindicespath, 'Xcv', 'cv_in', 'cv_out');
%[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid_red,Kcv);


%calculate adjacency matrix for neighborhood graph
lonlat = double(PW.loc(index,:)); %lonlat_red = lonlat(1:300,:);
lats = lonlat(:,2); %needed later on for computing global average
lats_2d = repmat(lats, [1 ntime]); lats_2d = lats_2d'; %time x space
%lats_2d_red = lats_2d(:,1:300);




%% GraphEM stage
for k = 1:Kcv
	% GraphEM part 1: neighborhood graph
	%GraphEM options:
	opt.regress = 'ols';
	opt.stagtol = 5e-3;
	opt.maxit = 30;
	opt.useggm = 1;
	opt %display options
	%opt = rmfield(opt,'adj'); %clear opt.adj
	for n = 1:Ncases
	target_cr = Crcases(n);
	opt.adj = neigh_radius_adj(lonlat,target_cr);
	%opt.adj = neigh_radius_adj(lonlat_red,target_cr);	
	[Xcr{k,n},Mcr{k,n},Ccr{k,n}] = graphem_JW(Xcv{k},opt);
	
	%Xf = Xcr{k,n};
	%crtag = [worldname '_' datatype '_graphem_cr' num2str(target_cr) '.mat'];	
	%crpath = [odir crtag];
	%save(crpath, 'Xf', 'target_cr')
	%clear crpath Xf
	end
end


	% GraphEM part 2: GLASSO
	%calculate adjacency matrix for GLASSO
	%target_spars = Scases(n);
	%Xcal = Xcr{k}(calib,:); %select calibration period
	%S = corrcoef(Xcal); %sample covariance matrix (transposed?)
	%[spars,adj] = greedy_search_TT(S,target_spars,N);
	%spars_f = spars(end); adjM = adj{end};
	%save adj
	%clear spars adj
	%opt.adj = adjM;
	%[Xg{k,n},Mg{k,n},Cg{k,n}] = graphem_JW(Xcr{k},opt); %transposed?
	%end
%end
%save(testpath, 'Xg', 'Xcr', 'Xgrid', 'in', 'out');
%save(testpath, 'Xcr', 'Xgrid100', 'cv_in', 'cv_out');


indavl_t = ~isnan(Xgrid);
lats_t = lats_2d(indavl_t);
%lats_t = lats_2d_red(indavl_t);	
normfac = nsum(nsum(cosd(lats_t)));

%% Cross-validation stage
for k = 1:Kcv
	for n = 1:Ncases
		mse0{k,n} = (Xcr{k,n} - Xgrid).^2;
		%mse0{k,n} = (Xcr{k,n} - Xgrid_red).^2;
		mse_t = mse0{k,n}(indavl_t);
		f_num(k,n) = nsum(nsum(mse_t.*cosd(lats_t)));	
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
CVtag = [worldname '_' datatype '_cr_CVscores_test1.mat'];
savepath = [odir CVtag];
save(savepath, 'Crcases', 'epe', 'sigg', 'cv_in', 'cv_out','runtime')

		
