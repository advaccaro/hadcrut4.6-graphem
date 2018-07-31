%ERSSTv5_opennc.m

%opens ERSSTv5 netCDF files and saves as .mat file
%input is filename w/o directory

function [opath] = ERSSTv5_opennc(infile)

indir = '/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/ERSSTv5/data/raw/'; %in-directory
odir = '/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/ERSSTv5/data/'; %out-directory

inname = infile;
inpath = [indir inname]; %complete in-file path

%determine timestamp (format is yyyymm)
timestamp = inname(10:end-3); %this is a string


%define out-name and out-path
oname = ['ERSSTv5_mon' timestamp '.mat'];
opath = [odir oname];


ncidin = netcdf.open(inpath); %open netCDF file

%Var IDs (found prior using cfdataset)
%latbndsname = 'lat_bnds';
%lonbndsname = 'lon_bnds';
sstname = 'sst';
anomname = 'ssta';
timename = 'time';
zlevname = 'lev';
latname = 'lat';
lonname = 'lon';

%find indices for vars
%latbnds_indx = netcdf.inqVarID(ncidin,latbndsname);
%lonbnds_indx = netcdf.inqVarID(ncidin,lonbndsname);
sst_indx = netcdf.inqVarID(ncidin,sstname);
anom_indx = netcdf.inqVarID(ncidin,anomname);
time_indx = netcdf.inqVarID(ncidin,timename);
zlev_indx = netcdf.inqVarID(ncidin,zlevname);
lat_indx = netcdf.inqVarID(ncidin,latname);
lon_indx = netcdf.inqVarID(ncidin,lonname);

%Generate serial time
year = str2num(timestamp(1:4));
month = str2num(timestamp(5:6));
tmdn = datenum(year, month, 15);

%now import
%ERSSTv5_mon.latbnds = netcdf.getVar(ncidin,latbnds_indx);
%ERSSTv5_mon.lonbnds = netcdf.getVar(ncidin,lonbnds_indx);
ERSSTv5_mon.sst = netcdf.getVar(ncidin,sst_indx);
ERSSTv5_mon.anom = netcdf.getVar(ncidin,anom_indx);
%ERSSTv5_mon.time = netcdf.getVar(ncidin,time_indx);
ERSSTv5_mon.tmdn = tmdn;
ERSSTv5_mon.zlev = netcdf.getVar(ncidin,zlev_indx);
ERSSTv5_mon.lat = netcdf.getVar(ncidin,lat_indx);
ERSSTv5_mon.lon = netcdf.getVar(ncidin,lon_indx);

save(opath, 'ERSSTv5_mon');

%encode NaN's (are there NaNs/how are they designated?)




%save
save(opath, 'ERSSTv5_mon')

%close netCDF
netcdf.close(ncidin)


