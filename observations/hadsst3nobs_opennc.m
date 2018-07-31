%hadsst3nobs_opennc.m
clear all
working_dir = '/home/geovault-02/avaccaro/hadCRUT4.6/';
data_dir = [working_dir 'observations/data/'];
addpath(genpath(working_dir))
infile = [data_dir 'HadSST.3.1.1.0.number_of_observations.nc'];

% Explore variables in netcdf file
H = cfdataset(infile);

% unpack netCDF file
ncidin = netcdf.open(infile); %open netCDF file

%netCDF var names
time_bnds_name = 'time_bnds';
field_status_name = 'field_status';
nobs_name = 'nobs';
time_name = 'time';
lat_name = 'latitude';
lon_name = 'longitude';

%find correct indices for each variable
time_bnds_indx = netcdf.inqVarID(ncidin, time_bnds_name);
field_status_indx = netcdf.inqVarID(ncidin, field_status_name);
nobs_indx = netcdf.inqVarID(ncidin, nobs_name);
time_indx = netcdf.inqVarID(ncidin, time_name);
lat_indx = netcdf.inqVarID(ncidin, lat_name);
lon_indx = netcdf.inqVarID(ncidin, lon_name);


%now import
HadSST3nobs.time_bnds = netcdf.getVar(ncidin, time_bnds_indx);
HadSST3nobs.field_status = netcdf.getVar(ncidin, field_status_indx);
HadSST3nobs.nobs = netcdf.getVar(ncidin, nobs_indx);
HadSST3nobs.time = netcdf.getVar(ncidin, time_indx);
HadSST3nobs.lat = netcdf.getVar(ncidin, lat_indx);
HadSST3nobs.lon = netcdf.getVar(ncidin, lon_indx);

%encode NaN's
HadSST3nobs.nobs(HadSST3nobs.nobs < -9999) = NaN;

%Reshape to 2d
[nlon, nlat, ntime] = size(HadSST3nobs.nobs);
nloc = nlat * nlon;
nobs2d = reshape(HadSST3nobs.nobs, [nloc, ntime]);
HadSST3nobs.nobs2d = double(nobs2d');

[x,y] = meshgrid(HadSST3nobs.lat, HadSST3nobs.lon);
HadSST3nobs.loc = [y(:), x(:)];

%put on common time axis
starttime = datenum('Jan-0-1850');
htime = starttime + double(HadSST3nobs.time);
htvec = datevec(htime);
HadSST3nobs.htfrac = htvec(:,1) + htvec(:,2)/12 - 1/12;
HadSST3nobs.tvec = htvec;
HadSST3nobs.tser = htime;

ofile = 'hadsst3nobs.mat';
opath = [data_dir ofile];

%save
save(opath, 'HadSST3nobs')






