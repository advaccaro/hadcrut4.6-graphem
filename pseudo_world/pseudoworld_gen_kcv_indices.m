function pseudoworld_gen_kcv_indices(dataset,datatype,worldnum,Kcv)
	addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))
	raw = load(dataset);
	PW = identifyPW(raw, worldnum, datatype);

	[nt,ns] = size(PW.grid_2d);

	% select poitns w/ > (1/Kcv)% coverage
	test = ~isnan(PW.grid_2d);
	Stest = sum(test,1);
	index = find(Stest > (1/Kcv)*nt);
	Nindex = length(index);
	Xgrid = nan(nt,Nindex);

	Xgrid = PW.grid_2d(:,index);

	[Xcv,cv_in,cv_out] = kcv_indices2d(Xgrid,Kcv);
	% for i = 1:nt
	% 	Xgrid(i,:) = PW.grid_2d(i,index);
	% end

	worldname = ['pseudoworld' num2str(worldnum)];
	fullname = [worldname '_' datatype];
	basedir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/';
	odir = [basedir worldname '/' datatype '/data/'];

	cv_indices_tag = [worldname '_' datatype '_kcv_indices.mat'];
	cv_indices_path = [odir cv_indices_tag];
	save(cv_indices_path, 'Xcv', 'cv_in', 'cv_out', 'index', 'Xgrid')
