%had46ens_opennc.m


%filenum = ; %filenum must be defined in pbs script!
addpath(genpath('/home/geovault-00/rverna/hadCRUT4.6/'))
%addpath('/home/geovault-00/jianghaw/pseudoproxy/graphem_test/graphem/')


%%Initialize (0th step) (open raw data netCDf, update  w/ cw2013, format)
load('cw17.mat')
indir = '/home/geovault-00/rverna/hadCRUT4.6/ensemble/data/raw/';
infile = ['HadCRUT.4.6.0.0.anomalies.' num2str(filenum) '.nc'];
inpath = [indir infile];


%unpack netCDF file
ncidin = netcdf.open(inpath); %open netCDF file

%netCDF var names
latname = 'latitude'; 
lonname = 'longitude';
timename = 'time'; 
tname = 'temperature_anomaly';
statusname = 'field_status';

%find correct indices for each variable
time_indx = netcdf.inqVarID(ncidin,timename);
lon_indx = netcdf.inqVarID(ncidin,lonname);
lat_indx = netcdf.inqVarID(ncidin,latname);
temp_indx = netcdf.inqVarID(ncidin,tname);
status_indx = netcdf.inqVarID(ncidin,statusname);

%now import
H46ens.lat = netcdf.getVar(ncidin,lat_indx);
H46ens.lon = netcdf.getVar(ncidin,lon_indx);
H46ens.time = netcdf.getVar(ncidin,time_indx);
H46ens.x = netcdf.getVar(ncidin,temp_indx);
H46ens.stat = netcdf.getVar(ncidin, status_indx);

%encode NaN's
H46ens.x(H46ens.x < -99999) = NaN;

%Reshape for GraphEM
[nlon, nlat, ntime] = size(H46ens.x);
nloc = nlat * nlon;
had46ens = reshape(H46ens.x, [nloc, ntime]);
had46ens = had46ens';
had46ens = double(had46ens);

rawH46ens = had46ens;

[x,y] = meshgrid(H46ens.lat,H46ens.lon);
loc = [y(:),x(:)];

navail = sum(~isnan(had46ens));
station = find(navail >= ntime/5);
nstation = find(navail < ntime/5);

%load cw2013 data and update had4ens
%load('cw2013.mat') %interpolated data
[~,~,c_time] = size(cw17.temp); 

cw = reshape(cw17.temp, [nloc, c_time]);
cw = cw';
cw = double(cw);

%put on common time axis
starttime = datenum('Jan-1-1850');

cwtime = starttime + double(cw17.time);
cwtvec = datevec(cwtime);
cwtfrac = cwtvec(:,1) + cwtvec(:,2)/12 - 1/12;
cwendtime = cwtfrac(end);

htime = starttime + double(H46ens.time);
htvec = datevec(htime);
htfrac = htvec(:,1) + htvec(:,2)/12 - 1/12;
H46ens.tser = htime;
H46ens.tvec = htvec;
H46ens.tfrac = htfrac;

had46ens((htfrac >= 1979 & htfrac <= cwendtime), nstation) = cw(cwtfrac >= 1979, nstation);
navail2 = sum(~isnan(had46ens));
station2 = find(navail>=ntime/5);

odir = '/home/geovault-00/rverna/hadCRUT4.6/ensemble/data/';
ofile = [infile(1:end-3) '.mat'];
opath = [odir ofile];

%save raw and updated hadcrut4 ensemble member as .mat
save(opath, 'H46ens' , 'had46ens', 'loc', 'rawH46ens')


