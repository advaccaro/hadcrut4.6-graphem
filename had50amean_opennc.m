%had46med_opennc.m


%filenum = ; %filenum must be defined in pbs script!
%addpath('/home/geovault-00/jianghaw/pseudoproxy/graphem_test/graphem/')


%%Initialize (0th step) (open raw data netCDf, update  w/ cw2013, format)

indir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/raw/';
infile = ['HadCRUT.5.0.1.0.analysis.anomalies.ensemble_mean.nc'];
inpath = [indir infile];


%unpack netCDF file
ncidin = netcdf.open(inpath); %open netCDF file

%netCDF var names
latname = 'latitude'; 
lonname = 'longitude';
timename = 'time'; 
tname = 'tas_mean';
rname = 'realization';

%find correct indices for each variable
time_indx = netcdf.inqVarID(ncidin,timename);
lon_indx = netcdf.inqVarID(ncidin,lonname);
lat_indx = netcdf.inqVarID(ncidin,latname);
temp_indx = netcdf.inqVarID(ncidin,tname);
status_indx = netcdf.inqVarID(ncidin,rname);

%now import
H46med.lat = netcdf.getVar(ncidin,lat_indx);
H46med.lon = netcdf.getVar(ncidin,lon_indx);
H46med.time = netcdf.getVar(ncidin,time_indx);
H46med.x = netcdf.getVar(ncidin,temp_indx);
H46med.realization = netcdf.getVar(ncidin, status_indx);

%encode NaN's
H46med.x(H46med.x < -99999) = NaN;

%Reshape for GraphEM
[nlon, nlat, ntime] = size(H46med.x);
nloc = nlat * nlon;
had46med = reshape(H46med.x, [nloc, ntime]);
had46med = had46med';
had46med = double(had46med);

rawH46med = had46med;

[x,y] = meshgrid(H46med.lat,H46med.lon);
loc = [y(:),x(:)];


%put on common time axis
starttime = datenum('Jan-1-1850');


htime = starttime + double(H46med.time);
htvec = datevec(htime);
htfrac = htvec(:,1) + htvec(:,2)/12 - 1/12;
H46med.tser = htime;
H46med.tvec = htvec;
H46med.tfrac = htfrac;


H50amean = H46med;
had50amean = had46med;
rawH50amean = rawH46med;

odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/';
ofile = ['had50amean.mat'];
opath = [odir ofile];

%save raw and updated hadcrut4 ensemble member as .mat
save(opath, 'H50amean' , 'had50amean', 'loc', 'rawH50amean')


