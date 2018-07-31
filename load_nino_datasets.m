%load_nino_datasets.m

%HadCRUT4.6 raw explored
load('/home/geovault-02/avaccaro/hadCRUT4.6/data/H46MED_EXP.mat');


%HadCRUT4.6 graphem infilled (sparsity 0.8%) explored
load('/home/geovault-02/avaccaro/hadCRUT4.6/data/H46MED_SP80_MERRA_KRIG_EXP.mat');

%Kaplan ext explored
load('/home/scec-02/avaccaro/HadCRUT4.3/SST_datasets/KAPLANext/data/KAPLANext_NINO.mat');

%COBE
load('/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/cobe/COBE_NINO.mat');

%Bunge & Clarke
load('/home/scec-02/avaccaro/HadCRUT4.3/SST_datasets/Bunge/data/BUNGE_NINO.mat');

%ERSSTv5
load('/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/ERSSTv5/data/ERSSTv5_NINO.mat');

%Cowtan & Way explored
load('/home/geovault-02/avaccaro/hadCRUT4.6/data/C46MED_EXP.mat');

%GraphEM ensemble
load('/home/geovault-02/avaccaro/hadCRUT4.6/ensemble/data/ENS.mat');
