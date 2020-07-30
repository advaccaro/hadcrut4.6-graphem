% combine_netcdf.m
function CCI = combine_netcdf(indir, ofile, odir)
	% Check for optional arguments
	if ~exist('odir', 'var')
		odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/'
	end

	if ~exist('ofile', 'var')
		ofile = 'combined.nc'
	end

	% find netCDF files
	nc_files = dir([indir '*.nc']);
	nc_files = {nc_files.name};
	nc_files = sort(nc_files); %sort so files are in chronological order

	% number of files (also number of time steps)
	nfiles = len(nc_files);


	% initialize storage structure time axis
	CCI.tfrac = zeros(nfiles);

	% Set first element flag
	first = true;

	nloc = 0; %this will be updated below

	% loop through netCDF files
	for tx = 1:nfiles
		inpath = [indir nc_files{tx}];
		C = cci_opennc(inpath);
		if first
			% Extract spatial metadata and initialze storage structure
			CCI.lon = C.lon;
			CCI.lat = C.lat;
			nlon = length(C.lon);
			nlat = length(C.lat);

			% Initialize 3-dimensional storage arrays
			CCI.sst = zeros(nlon, nlat, nfiles);
			CCI.uncertainty = zeros(nlon, nlat, nfiles);
			CCI.sea_fraction = zeros(nlon, nlat, nfiles);
			CCI.sea_ice_fraction = zeros(nlon, nlat, nfiles);

			% turn off first flag
			first = false;
		end

		% Store annual data in structure
		CCI.tfrac(tx) = double(C.year) + (double(C.month) - 1)/12;
		CCI.sst(:,:,tx) = double(C.sst);
		CCI.uncertainty(:,:,tx) = double(C.uncertainty);
		CCI.sea_fraction(:,:,tx) = double(C.sea_fraction);
		CCI.sea_ice_fraction(:,:,tx) = double(C.sea_ice_fraction);
	end

	% omit points with >80% sea ice
	tmp = CCI.sst;
	tmp(CCI.sea_ice_fraction > .8) = NaN;

	% reshape to 2d
	nloc = nlon * nlat;
	cci2d = reshape(tmp, [nloc, nfiles]);
	cci2d = cci2d';

	% convert to anomaly (1982 - 2010)
	clim = calc_clim(cci2d(CCI.tfrac >= 1982 & CCI.tfrac < 2011, :));
	ny = floor(nfiles/12);
	cci_anom = cci2d - repmat(clim, [ny, 1]);

	% make loc (2d locations)
	[x,y] = meshgrid(CCI.lat,CCI.lon);
	loc = [y(:),x(:)];

	% save raw and updated combined CCI data
	if odir(end) == '/'
		opath = [odir ofile];
	else
		opath = [odir '/' ofile];
	end
	save(opath, 'CCI', 'cci_anom', 'loc')
end


