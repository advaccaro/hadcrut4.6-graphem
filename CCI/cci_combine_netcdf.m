% combine_netcdf.m
function CCI = combine_netcdf(indir)
	% find netCDF files
	nc_files = dir([indir '*.nc']);
	nc_files = {nc_files.name};
	nc_files = sort(nc_files); %sort so files are in chronological order

	% number of files (also number of time steps)
	nfiles = len(nc_files);

	% Set first element flag
	first = true;
	% Initialize storage structure
	% CCI.sst3 = zeros()

	% loop through netCDF files
	for tx = 1:nfiles
		if first
			% Extract spatial metadata and initialze storage structure
			
			% turn off first flag
			first = false;