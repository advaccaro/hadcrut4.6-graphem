%pseudoworld2lsat_opennc.m
%opens .nc file and saves as .mat

indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/raw/';
odir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';

inname = 'world_2_historical_pseudo_world_1850-2005_lsat_1961-1990.nc';
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
PW2.lat = netcdf.getVar(ncidin,lat_indx);
PW2.lon = netcdf.getVar(ncidin,lon_indx);
PW2.time = netcdf.getVar(ncidin,time_indx);
PW2.grid = netcdf.getVar(ncidin,grid_indx);
PW2.uncorr = netcdf.getVar(ncidin,uncorr_indx);

%encode NaN's
PW2.grid(PW2.grid < -99999) = NaN;
PW2.uncorr(PW2.uncorr < -99999) = NaN;

%get dims
[nlon, nlat, ntime] = size(PW2.grid);
nloc = nlat*nlon;

%reshape for GraphEM
PW2.grid_2d = reshape(PW2.grid, [nloc ntime]);
PW2.grid_2d = PW2.grid_2d'; %time x space
PW2.grid_2d = double(PW2.grid_2d);

PW2.uncorr_2d = reshape(PW2.uncorr, [nloc ntime]);
PW2.uncorr_2d = PW2.uncorr_2d';
PW2.uncorr_2d = double(PW2.uncorr_2d);
%make loc
[x,y] = meshgrid(PW2.lat,PW2.lon);
PW2.loc = [y(:),x(:)];

PW2_lsat = PW2;

%save as .mat
oname = 'pseudoworld2_lsat.mat';
opath = [odir oname];
save(opath, 'PW2_lsat');
