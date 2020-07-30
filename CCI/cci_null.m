% cci_null.m


tic;
Kcv = 10;
data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
odir = data_dir; %writing to input directory, for now

% Load CCI data
datapath = [data_dir 'cci_combined_include_ice.mat'];
raw = load(datapath);
Xraw = raw.cci_anom;
[nt,ns] = size(Xraw);

% Set up output matrices
Xg = cell(Kcv);

% compute climatology
clim = calc_clim(Xgrid);
step_full =12*[0:1:ceil(nt/12)-1];



Xg = Xraw;
for t = 1:nt
	month = mod(t,12);
	if month == 0
		month = 12;
	end
	missing_ind = isnan(tmp(t,:));
	Xg(t, missing_ind) = clim(month, missing_ind);
end


otag = 'cci_combined_null.mat';
savepath = [odir otag];
save(savepath, 'Xg')
