%hadsst3nobs_opennc.m
clear all
working_dir = '/home/geovault-02/avaccaro/hadCRUT4.6/';
data_dir = [working_dir 'observations/data/'];
addpath(genpath(working_dir))
infile = [data_dir 'CRUTEM.4.6.0.0.nobs.nc'];

% Explore variables in netCDF file
H = cfdataset(infile);

% unpack netCDF file
ncidin = netcdf.open(infile); %open netCDF file

%netCDF var names
field_status_name = 'field_status';
nobs_name = 'number_of_observations';
time_name = 'time';
lat_name = 'latitude';
lon_name = 'longitude';

%find correct indices for each variable
field_status_indx = netcdf.inqVarID(ncidin, field_status_name);
nobs_indx = netcdf.inqVarID(ncidin, nobs_name);
time_indx = netcdf.inqVarID(ncidin, time_name);
lat_indx = netcdf.inqVarID(ncidin, lat_name);
lon_indx = netcdf.inqVarID(ncidin, lon_name);


%now import
CRUTEM4nobs.field_status = netcdf.getVar(ncidin, field_status_indx);
CRUTEM4nobs.nobs = netcdf.getVar(ncidin, nobs_indx);
CRUTEM4nobs.time = netcdf.getVar(ncidin, time_indx);
CRUTEM4nobs.lat = netcdf.getVar(ncidin, lat_indx);
CRUTEM4nobs.lon = netcdf.getVar(ncidin, lon_indx);


%encode NaN's
CRUTEM4nobs.nobs(CRUTEM4nobs.nobs < -9999) = NaN;

%Reshape to 2d
[nlon, nlat, ntime] = size(CRUTEM4nobs.nobs);
nloc = nlat * nlon;
nobs2d = reshape(CRUTEM4nobs.nobs, [nloc, ntime]);
CRUTEM4nobs.nobs2d = double(nobs2d');

[x,y] = meshgrid(CRUTEM4nobs.lat, CRUTEM4nobs.lon);
CRUTEM4nobs.loc = [y(:), x(:)];

%put on common time axis
starttime = datenum('Jan-0-1850');
htime = starttime + double(CRUTEM4nobs.time);
htvec = datevec(htime);
CRUTEM4nobs.htfrac = htvec(:,1) + htvec(:,2)/12 - 1/12;
CRUTEM4nobs.tvec = htvec;
CRUTEM4nobs.tser = htime;

ofile = 'crutem4nobs.mat';
opath = [data_dir ofile];

%save
save(opath, 'CRUTEM4nobs')

