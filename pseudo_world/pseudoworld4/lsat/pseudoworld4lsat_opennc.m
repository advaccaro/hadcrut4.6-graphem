%pseudoworld4lsat_opennc.m
%opens .nc file and saves as .mat

indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/raw/';
odir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';

inname = 'world_4_historical_pseudo_world_185912-200511_lsat_1961-1990.nc';

inpath = [indir inname];

ncidin = netcdf.open(inpath);

%Var IDs
latname = 'latitude';
lonname = 'longitude';
timename = 'time';
gridname = 'grid_data';
uncorrname = 'uncorrelated';

%find correct indices for vars
lat_indx = netcdf.inqVarID(ncidin,latname);
lon_indx = netcdf.inqVarID(ncidin,lonname);
time_indx = netcdf.inqVarID(ncidin,timename);
grid_indx = netcdf.inqVarID(ncidin,gridname);
uncorr_indx = netcdf.inqVarID(ncidin,uncorrname);


%now import
PW4.lat = netcdf.getVar(ncidin,lat_indx);
PW4.lon = netcdf.getVar(ncidin,lon_indx);
PW4.time = netcdf.getVar(ncidin,time_indx);
PW4.grid = netcdf.getVar(ncidin,grid_indx);
PW4.uncorr = netcdf.getVar(ncidin,uncorr_indx);

%encode NaN's
PW4.grid(PW4.grid < -99999) = NaN;
PW4.uncorr(PW4.uncorr < -99999) = NaN;

%get dims
[nlon, nlat, ntime] = size(PW4.grid);
nloc = nlat*nlon;

%reshape for GraphEM
PW4.grid_2d = reshape(PW4.grid, [nloc ntime]);
PW4.grid_2d = PW4.grid_2d'; %time x space
PW4.grid_2d = double(PW4.grid_2d);

PW4.uncorr_2d = reshape(PW4.uncorr, [nloc ntime]);
PW4.uncorr_2d = PW4.uncorr_2d';
PW4.uncorr_2d = double(PW4.uncorr_2d);

%make loc
[x,y] = meshgrid(PW4.lat,PW4.lon);
PW4.loc = [y(:),x(:)];

PW4_lsat = PW4;

%save as .mat
oname = 'pseudoworld4_lsat.mat';
opath = [odir oname];
save(opath, 'PW4_lsat');
