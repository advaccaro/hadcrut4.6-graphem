homedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(homedir))
%addpath('/home/scec-02/avaccaro/GraphEM/')

%% Open HadCRUT4 and CW datasets
indir = [homedir 'data/'];
infile = 'had46med.mat';
inpath = [indir infile];
load(inpath)

cwpath = [homedir 'cw17/data/cw17.mat'];
cwspath = [homedir 'cw17/data/cw17_short.mat'];
load(cwpath)
load(cwspath)

C0 = corrcoef(cw17s.temp2d); %estimate correlation coefficients matrix

outpath = [indir 'cw17s_cov.mat'];

save(outpath, 'C0')

