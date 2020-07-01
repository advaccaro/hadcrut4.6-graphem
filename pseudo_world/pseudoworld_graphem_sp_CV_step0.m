% pseudoworld_graphem_sp_CV_step0.m
% Get CV indices for pseudo-world cross-validation
function [Xcv, cv_in, cv_out] = pseudoworld_graphem_sp_CV_step0(dataset,datatype,worldnum,truth,Kcv)




%% Initialize
addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3/'))
truth = truth;
worldname = ['pseudoworld' num2str(worldnum)];
fullname = [worldname '_' datatype];
truthname = [fullname '_truth'];
basedir = '/home/scec-02/avaccaro/HadCRUT4.3/pseudo_world/';
odir = [basedir worldname '/' datatype '/data/'];



% Load raw data
raw = load(dataset);
if truth == 1
	PW = identifyPWtruth(raw, worldnum, datatype);
	finalname = truthname;
elseif truth == 0
	PW = identifyPW(raw,worldnum,datatype);
	finalname = fullname;
end

[ntime,nspace] = size(PW.grid_2d);


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

%get KCV indices
[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid,Kcv);
CVindicestag = [finalname '_KCV_INDICES.mat'];
CVindicespath = [odir CVindicestag];
save(CVindicespath, 'Xcv', 'cv_in', 'cv_out')

