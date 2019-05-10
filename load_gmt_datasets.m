%load GMT datasets

%HadCRUT4.6 raw explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MED_EXP.mat');

%HadCRUT4.6 graphem infilled (sparsity 0.8%) explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46M80_EXP.mat');

%HadCRUT4.6 graphem infilled (sparsity 0.6%) explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/H46MED_SP60_MERRA_KRIG_EXP.mat');


%GISTEMP explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/GISTEMP/data/GISTEMP_GMT.mat');

%Cowtan & Way explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/C46MED_EXP.mat');

%NOAA explored
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/NOAA_GMT/data/NOAA_GMT_EXP.mat');

%GraphEM ensemble
load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/ensemble/data/ENS_sp60.mat');
