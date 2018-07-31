%ERSSTv5_nino_explore.m
addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/'))


load('ERSSTv5.mat')

[ERSSTv5_NINO] = nino_explore(ERSSTv5.sst_3d,ERSSTv5.lon,ERSSTv5.lat,ERSSTv5.tser);


ERSSTv5_NINO.SSTm=ERSSTv5_NINO.SSTm;
ERSSTv5_NINO.SSTa_djf=ERSSTv5_NINO.SSTa_djf;
ERSSTv5_NINO.SSTo_djf=ERSSTv5_NINO.SSTo_djf;
ERSSTv5_NINO.NINO3=ERSSTv5_NINO.NINO3;
ERSSTv5_NINO.NINO34m=ERSSTv5_NINO.NINO34m;
ERSSTv5_NINO.NINO34a_djf=ERSSTv5_NINO.NINO34a_djf;
ERSSTv5_NINO.NINO34a_yr = ERSSTv5_NINO.NINO34a_yr;
ERSSTv5_NINO.NINO34d_djf = ERSSTv5_NINO.NINO34d_djf;
ERSSTv5_NINO.NINO34d_yr = ERSSTv5_NINO.NINO34d_yr;
ERSSTv5_NINO.NINO34d_full = ERSSTv5_NINO.NINO34d_full;



odir = '/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/ERSSTv5/data/';
savetag = 'ERSSTv5_NINO.mat';
savefile = [odir savetag];

save(savefile, 'ERSSTv5_NINO')
