%load_nino_datasets.m

%HadCRUT4.6 raw explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MED_EXP.mat');


%HadCRUT4.6 graphem infilled (sparsity 0.8%) explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MED_SP80_MERRA_KRIG_EXP.mat');

%HadCRUT4.6 graphem infilled (sparsity 0.6%) explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MED_SP60_MERRA_KRIG_EXP.mat');

%Kaplan ext explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/SST_datasets/KAPLANext/data/KAPLANext_NINO.mat');

%COBE
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/SST_datasets/cobe/COBE_NINO.mat');

%Bunge & Clarke
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/SST_datasets/Bunge/data/BUNGE_NINO.mat');

%ERSSTv5
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/SST_datasets/ERSSTv5/data/ERSSTv5_NINO.mat');

%Cowtan & Way explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/C46MED_EXP.mat');

%GraphEM ensemble
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/ensemble/data/ENS_sp60.mat');
