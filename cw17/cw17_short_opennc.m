%cw17__short_ncopen.m
%opens the cowtan and way 2013 temperature series
%clear all; %close all; %clc;
%addpath(genpath('/Users/adam/Desktop/HadCRUT4.2.0.0'))
%addpath(genpath('/home/scec-02/avaccaro/HadCRUT4.3'))

%addpath(genpath('/Users/adam/Desktop/Treerings/matlib'))
%addpath(genpath('/home/geovault-02/avaccaro/matlib'))

%indir = '/Users/adam/Desktop/HadCRUT4.2.0.0/data/cw2013/';
indir = '/home/geovault-00/rverna/hadCRUT4.6/cw17/data/';

%odir = '/Users/adam/Desktop/HadCRUT4.2.0.0/data/';
%odir = '/home/scec-02/avaccaro/HadCRUT4.3/data/';
odir = indir;
outfile = [odir 'cw17_short.mat'];

infile = [indir 'had4_short_merra_v2_0_0.nc'];

latname = 'latitude';
lonname = 'longitude';
timename = 'time';
yearname = 'year';
monthname = 'month';
tempname = 'temperature_anomaly';


%open file
ncidin = netcdf.open(infile);

%find correct indices for each variable
lat_indx = netcdf.inqVarID(ncidin,latname);
lon_indx = netcdf.inqVarID(ncidin,lonname);
time_indx = netcdf.inqVarID(ncidin,timename);
year_indx = netcdf.inqVarID(ncidin,yearname);
month_indx = netcdf.inqVarID(ncidin,monthname);
temp_indx = netcdf.inqVarID(ncidin,tempname);

%now import
cw17s.lat = netcdf.getVar(ncidin,lat_indx);
cw17s.lon = netcdf.getVar(ncidin,lon_indx);
cw17s.time = netcdf.getVar(ncidin, time_indx);
cw17s.year = netcdf.getVar(ncidin, year_indx);
cw17s.month = netcdf.getVar(ncidin, month_indx);
cw17s.temp = netcdf.getVar(ncidin, temp_indx);

%reshape temperature matrix into 2 dimensions for GraphEM
[nlon, nlat, ntime] = size(cw17s.temp);
nloc = nlon * nlat;
temp2d = reshape(cw17s.temp, [nloc, ntime]);
temp2d = temp2d';
temp2d = double(temp2d);
cw17s.temp2d = temp2d;

%reshape lon/lat
[x, y] = meshgrid(cw17s.lat, cw17s.lon);
cw17s.loc = [y(:), x(:)];

%set up time axis
starttime = datenum('Jan-1-1850');
cwtime = starttime + double(cw17s.time); %UNIX time axis
cw17s.tvec = datevec(cwtime); %datevec time axis
cw17s.tfrac = cw17s.tvec(:,1) + cw17s.tvec(:,2)/12 - 1/12; %fractional time axis


save(outfile, 'cw17s')

netcdf.close(ncidin)
