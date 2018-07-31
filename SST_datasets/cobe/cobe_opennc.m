% Opens COBE SST .nc file, stores data in structure, and saves as .mat file
% A. Vaccaro, USC 2015

addpath(genpath('/home/geovault-00/rverna/hadCRUT4.6/'))

filedir = '/home/geovault-00/rverna/hadCRUT4.6/SST_datasets/cobe/';
filename = 'sst.mon.mean.nc';
inpath = [filedir filename];

%open file
ncidin = netcdf.open(inpath);

%find vars
% nvars=netcdf.inq(ncidin)+1;
% for i = nvars
% netcdf.inqVar(ncidin, i-1)
% end

%var names
latname = 'lat';
lonname = 'lon';
timename = 'time';
sstname = 'sst';

%find correct indices for each variable
lat_indx = netcdf.inqVarID(ncidin,latname);
lon_indx = netcdf.inqVarID(ncidin,lonname);
time_indx = netcdf.inqVarID(ncidin,timename);
sst_indx = netcdf.inqVarID(ncidin,sstname);

%now import
cobe.lat = netcdf.getVar(ncidin,lat_indx);
cobe.lon = netcdf.getVar(ncidin,lon_indx);
cobe.time = netcdf.getVar(ncidin,time_indx);
cobe.sst = netcdf.getVar(ncidin,sst_indx);

%save
outname = 'cobe_sst.mat';
outpath = [filedir outname];
save(outpath, 'cobe')


