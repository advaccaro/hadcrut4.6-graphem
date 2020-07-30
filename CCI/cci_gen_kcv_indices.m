% cci_gen_kcv_indices.m

% Initialize

% addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))
indir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
infile = 'cci_combined_include_ice.mat';
inpath = [indir infile];

% output directory
odir = indir;

% Load data
C = load(inpath);
xraw = C.cci_anom;
[nt,ns] = size(xraw);

% select points with > (1/Kcv)% coverage to prevent failure
Kcv = 10;
test = ~isnan(xraw);
test_sum = sum(test,1);
index = find(test_sum > (1/Kcv)*nt);
n_index = length(index);

xgrid = nan(ntime,n_index);
for i = 1:nt
	xgrid(i,:) = xraw(1,index);
end


% get KCV indices
Kcv = 10;
[Xcv,cv_in,cv_out] = kcv_indices2d(xgrid,Kcv);

% Save indices to file
cv_indices_tag = 'cci_kcv_indices.mat';
cv_indices_path = [odir cv_indices_tag];
save(cv_indices_path, 'Xcv', 'cv_in', 'cv_out', 'index')