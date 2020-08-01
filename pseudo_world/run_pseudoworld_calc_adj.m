home_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world/'
addpath(genpath(home_dir))

datasets = cell(1,8);
datasets{1} = [home_dir 'pseudoworld1/data/pseudoworld1_sst.mat'];
datasets{2} = [home_dir 'pseudoworld1/data/pseudoworld1_lsat.mat'];
datasets{3} = [home_dir 'pseudoworld2/data/pseudoworld2_sst.mat'];
datasets{4} = [home_dir 'pseudoworld2/data/pseudoworld2_lsat.mat'];
datasets{5} = [home_dir 'pseudoworld3/data/pseudoworld3_sst.mat'];
datasets{6} = [home_dir 'pseudoworld3/data/pseudoworld3_lsat.mat'];
datasets{7} = [home_dir 'pseudoworld4/data/pseudoworld4_sst.mat'];
datasets{8} = [home_dir 'pseudoworld4/data/pseudoworld4_lsat.mat'];

for i = 1:length(datasets)
	dataset = datasets{i};
	pieces = split(dataset, '.mat');
	pieces2 = split(pieces{1}, '_');
	datatype = pieces2{end};
	worldnum = str2num(pieces2{end-1}(end));

	for spars = [1.1,1.25,1.5]
		pseudoworld_calc_adj(dataset, datatype, worldnum, spars);
	end
end