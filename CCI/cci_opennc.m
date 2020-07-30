function CCI = cci_opennc(inpath, save_flag)
	%% Check for optional argument
	if ~exist('save_flag', 'var')
		save_flag = false;
	end

	%% Unpack netCDF file
	ncidin = netcdf.open(inpath);

	% find correct indices for each variable
	% time_indx = netcdf.inqVarID(ncidin,'time'); %What to do with time?
	lat_indx = netcdf.getVarID(ncidin,'lat');
	lon_indx = netcdf.getVarID(ncidin,'lon');
	sst_indx = netcdf.getVarID(ncidin,'sst');
	uncertainty_indx = netcdf.getVarID(ncidin,'sst_uncertainty');
	sea_ice_fraction_indx = netcdf.getVarID(ncidin,'sea_ice_fraction');
	sea_fraction_indx = netcdf.getVarID(ncidin,'sea_fraction');
	year_indx = netcdf.getVarID(ncidin,'calendar_year');
	month_indx = netcdf.getVarID(ncidin,'calendar_month');

	% extract from netCDF
	CCI.lat = netcdf.getVar(ncidin,lat_indx);
	CCI.lon = netcdf.getVar(ncidin,lon_indx);
	CCI.sst = netcdf.getVar(ncidin,sst_indx);
	CCI.uncertainty = netcdf.getVar(ncidin,uncertainty_indx);
	CCI.sea_ice_fraction = netcdf.getVar(ncidin,sea_ice_fraction_indx);
	CCI.sea_fraction = netcdf.getVar(ncidin,sea_fraction_indx);
	CCI.year = netcdf.getVar(ncidin,year_indx);
	CCI.month = netcdf.getVar(ncidin,month_indx);

	% encode NaN's
	CCI.sst(CCI.sst < - 30000) = NaN;

	if save_flag
		opath = [inpath(1:end-2) 'mat'] %replace .nc with .mat
		save(opath, 'CCI')
	end
end
