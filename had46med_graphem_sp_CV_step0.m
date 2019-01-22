% had46med_graphem_sp_CV_step0.m
% Get CV indices for H46med cross-validation

%% Initialize
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))


odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/data/';

% Load raw data
raw = load('had46med.mat');
X = raw.had46med;

% Load Cowtan And Way
load('cw17.mat')
load('cw17_short.mat')
navail = sum(~isnan(X));
[n,p] = size(X);
nstation = find(navail < .8*n); %less than 80% coverage
[cn, ~] = size(cw17.temp2d);
X0 = X; 
X0(1:cn,nstation) = cw17.temp2d(:,nstation);

%get KCV indices
Kcv = 10;
[Xcv,cv_in,cv_out] = kcv_indices2d(X0,Kcv);
CVindicestag = 'H46MED_KCV_INDICES.mat';
CVindicespath = [odir CVindicestag];
save(CVindicespath, 'Xcv', 'cv_in', 'cv_out')

