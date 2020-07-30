function CCI = cci_combined_opennc(inpath)

	%cci_combined_opennc.m
	%addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI'))

	%% Initialize
	%indir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
	%infile = ''

	%% Unpack netCDF file
	ncidin = netcdf.open(inpath); %open netCDF file

	% %netCDF var names
	% lat_name = 'lat';
	% lon_name = 'lon';
	% loc_name = 'loc';
	% tfrac_name ='tfrac';
	% sst3_name = 'sst3';
	% sst2_name = 'sst2';
	% uncertainty3_name = 'uncertainty3'
	% uncertainty

	%find correct indices for each variable
	lat_indx = netcdf.inqVarID(ncidin,'lat');
	lon_indx = netcdf.inqVarID(ncidin,'lon');
	loc_indx = netcdf.inqVarID(ncidin,'loc');
	tfrac_indx = netcdf.inqVarID(ncidin,'tfrac');
	sst3_indx = netcdf.inqVarID(ncidin, 'sst3');
	sst2_indx = netcdf.inqVarID(ncidin, 'sst2');
	uncertainty3_indx = netcdf.inqVarID(ncidin, 'uncertainty3');
	uncertainty2_indx = netcdf.inqVarID(ncidin, 'uncertainty2');
	mask3_indx = netcdf.inqVarID(ncidin,'mask3');
	mask2_indx = netcdf.inqVarID(ncidin,'mask2');
	sea_fraction3_indx = netcdf.inqVarID(ncidin,'sea_fraction3');
	sea_fraction2_indx = netcdf.inqVarID(ncidin,'sea_fraction2');
	sea_ice_fraction3_indx = netcdf.inqVarID(ncidin,'sea_ice_fraction3');
	sea_ice_fraction2_indx = netcdf.inqVarID(ncidin,'sea_ice_fraction2');

	%now import
	CCI.lat = netcdf.getVar(ncidin,lat_indx);
	CCI.lon = netcdf.getVar(ncidin,lon_indx);
	CCI.loc = netcdf.getVar(ncidin,loc_indx);
	CCI.tfrac = netcdf.getVar(ncidin,tfrac_indx);
	CCI.sst3 = netcdf.getVar(ncidin,sst3_indx);
	CCI.sst2 = netcdf.getVar(ncidin,sst2_indx);
	CCI.uncertainty3 = netcdf.getVar(ncidin,uncertainty3_indx);
	CCI.uncertainty2 = netcdf.getVar(ncidin,uncertainty2_indx);
	CCI.mask3 = netcdf.getVar(ncidin,mask3_indx);
	CCI.mask2 = netcdf.getVar(ncidin,mask2_indx);
	CCI.sea_ice_fraction3 = netcdf.getVar(ncidin,sea_ice_fraction3_indx);
	CCI.sea_ice_fraction2 = netcdf.getVar(ncidin,sea_ice_fraction2_indx);
	CCI.sea_fraction3 = netcdf.getVar(ncidin,sea_fraction3_indx);
	CCI.sea_fraction2 = netcdf.getVar(ncidin,sea_fraction2_indx);

	% encode missing numbers as NaN
	CCI.sst3(CCI.sst3 < -30000) = NaN;
	CCI.sst2(CCI.sst2 < -30000) = NaN;

	opath = [inpath(1:end-2) 'mat'];
	save(opath, 'CCI');
end