% cci_gen_kcv_indices.m

% Initialize

% addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))
indir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/'
infile = 'cci_combined_include_ice.mat';
inpath = [indir infile];

% output directory
odir = indir;

% Load data
C = load(inpath);
xraw = C.cci_anom;
[nt,ns] = size(xraw);

% get KCV indices
Kcv = 10;
[Xcv,cv_in,cv_out] = kcv_indices2d(xraw,Kcv);

% Save indices to file
cv_indices_tag = 'cci_kcv_indices.mat';
cv_indices_path = [odir cv_indices_tag];
save(cv_indices_path, 'Xcv', 'cv_in' 'cv_out')