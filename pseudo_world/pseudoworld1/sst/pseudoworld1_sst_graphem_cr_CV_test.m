% pseudoworld1_sst_graphem_cr_CV_test.m
% Cross-validation of target sparsity for GraphEM
%tic
%% Initialize
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
addpath('/home/scec-02/jianghaw/pseudoproxy/graphem_test/graphem/')
%addpath('/home/scec-02/julieneg/matlib/graphem')

%Crcases = [250:500:3250]; %sparsities tested 
Crcases = [250,500,1000,1250,1500,2500,4000]; %5000,7500];
Ncases = length(Crcases);
%target_cr = 800; %cutoff radius for neighborhood graph

odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/pseudoworld1/sst/data/';
%cradjname = ['pseudoworld1_sst_adj_cr' num2str(target_cr) 'test.mat'];
%cradjpath = [odir cradjname];
%crname = ['pseudoworld1_sst_graphem_cr' num2str(target_cr) 'test.mat'];
%crpath = [odir crname];
testname = ['pseudoworld1_sst_graphem_cr_CV_test.mat'];
testpath = [odir testname];

% Load full data data matrix (and get some useful meta data)
%raw = load('pseudoworld1_sst.mat');
truth = load('pseudoworld1_sst_truth.mat');
[ntime,nspace] = size(truth.PW1_sst_truth.grid_2d);
time = double(truth.PW1_sst_truth.time);
startdate = datenum('0-Jan-1850');
tser = time + startdate; %serial time axis
tvec = datevec(tser); %time vector
tfrac = tvec(:,1) + tvec(:,2)/12 - 1/12; %fractional time axis
tcal = tfrac(tfrac >= 1960 & tfrac < 1991); %calibration period (1960-1990)
calib = ismember(tfrac,tcal);

%select non empty grid points (actually, select points w/ >20% coverage)
test = ~isnan(truth.PW1_sst_truth.grid_2d);
Stest = sum(test,1);
%index = zeros(1,nspace); %preallocate space
%for i = 1:nspace
%	if Stest(i) > 0
%	index(i) = 1; 
%	end
%end
%index = find(Stest == ntime/5); %select points w/ >= 20% coverage
index = find(Stest == ntime); %select COMPLETE rows
Nindex = length(index);

Xgrid = nan(ntime,Nindex); %preallocate space

for i = 1:ntime
	Xgrid(i,:) = truth.PW1_sst_truth.grid_2d(i,index); %matrix of non empty grid boxes
end

Xgrid_red = Xgrid(1:220,1:300); %select first 100 grid points for testing
Kcv = 10; indCol = [1:100]; 
%[in,out,nin] = kcv_indices(indCol,Kcv,'blocks'); %k-fold CV indices
N = 25; %number of iterations for greedy search (quick search for now)
[Xcv,cv_in,cv_out] = kcv_indices2d_test(Xgrid_red,Kcv);


%calculate adjacency matrix for neighborhood graph
lonlat = double(truth.PW1_sst_truth.loc(index,:));
lonlat_red = lonlat(1:300,:);
lats = lonlat(:,2); %needed later on for computing global average
lats_2d = repmat(lats, [1 ntime]); lats_2d = lats_2d'; %time x space
lats_2d_red = lats_2d(1:220,1:300);
%target_cr = 800; %target cutoff radius
%adjR = neigh_radius_adj(lonlat,target_cr); %800 km
%save(cradjpath, 'adjR', 'target_cr')

%% GraphEM stage
for k = 1:Kcv
	%Xcv{k} = Xgrid100;
	%Xcv{k}(:,out{k}) = NaN;
	% GraphEM part 1: neighborhood graph
	%GraphEM options:
	opt.regress = 'ols';
	opt.stagtol = 5e-3;
	opt.maxit = 15;
	opt.useggm = 1;
	%opt.adj = adjR;
	opt %display options
	%[Xcr{k},Mcr{k},Ccr{k}] = graphem_JW(Xcv{k},opt); %transposed?
	%save
	%opt = rmfield(opt,'adj'); %clear opt.adj
	for n = 1:Ncases
	target_cr = Crcases(n);
	opt.adj = neigh_radius_adj(lonlat_red,target_cr);
	[Xcr{k,n},Mcr{k,n},Ccr{k,n}] = graphem_JW(Xcv{k},opt);
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

%% Cross-validation stage
for k = 1:Kcv
	for n = 1:Ncases
	mse0{k,n} = (Xcr{k,n} - Xgrid_red).^2;
	f_num(k,n) = nsum(nsum(mse0{k,n}.*cosd(lats_2d_red)));
	f_den(k,n) = nsum(nsum(cosd(lats_2d_red)));
	f_mse(k,n) = f_num(k,n)/f_den(k,n);
	end
end

for n = 1:Ncases
	epe(n) = (1/Kcv) * sum(f_mse(:,n));
	sigg(n) = std(f_mse(:,n));
end

%% Plotting
fig('pseudoworld1 sst CV scores (test)')
plot(Crcases,epe,'ko-'); hold on;
plot(Crcases,epe-sigg,'ko--'); plot(Crcases,epe+sigg,'ko--');
fancyplot_deco('10-fold Cross-validation scores for choosing target sparsity (Pseudo-world 1 sst)', 'Target sparsity', 'Average MSE', 14, 'Helvetica');

CVtag = 'pseudoworld1_sst_cr_CVscores_test_reduced.mat';
savepath = [odir CVtag];
save(savepath, 'Crcases', 'epe', 'sigg', 'cv_in', 'cv_out')

		
