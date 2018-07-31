%cw17_ncopen.m
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
outfile = [odir 'cw17.mat'];

infile = [indir 'had4_krig_v2_0_0.nc'];

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
cw17.lat = netcdf.getVar(ncidin,lat_indx);
cw17.lon = netcdf.getVar(ncidin,lon_indx);
cw17.time = netcdf.getVar(ncidin, time_indx);
cw17.year = netcdf.getVar(ncidin, year_indx);
cw17.month = netcdf.getVar(ncidin, month_indx);
cw17.temp = netcdf.getVar(ncidin, temp_indx);

%reshape temperature matrix into 2 dimensions for GraphEM
[nlon, nlat, ntime] = size(cw17.temp);
nloc = nlon * nlat;
temp2d = reshape(cw17.temp, [nloc, ntime]);
temp2d = temp2d';
temp2d = double(temp2d);
cw17.temp2d = temp2d;

%reshape lon/lat
[x, y] = meshgrid(cw17.lat, cw17.lon);
cw17.loc = [y(:), x(:)];

%set up time axis
starttime = datenum('Jan-1-1850');
cwtime = starttime + double(cw17.time); %UNIX time axis
cw17.tvec = datevec(cwtime); %datevec time axis
cw17.tfrac = cw17.tvec(:,1) + cw17.tvec(:,2)/12 - 1/12; %fractional time axis


save(outfile, 'cw17')

netcdf.close(ncidin)
