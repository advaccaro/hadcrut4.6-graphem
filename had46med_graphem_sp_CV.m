% had43med_graphem_sp_CV.m
% Cross-validation for cutoff radius for GraphEM
function had46med_graphem_sp_CV(sparsity)

tic;

%% Initialize
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))

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
	Xg{k} = Xg_k;
end


latStep = 20; %latitude step size
latBounds = fliplr([-90:latStep:90]); %define boundaries for latitude bands
nBands = length(latBounds) - 1 %number of latitude bands
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



