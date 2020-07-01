%pseudoworld3_opennc.m
%opens .nc file and saves as .mat

indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/raw/';
odir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';

inname = 'world_3_historical_pseudo_world_1850-2005_sst_1961-1990.nc';
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
PW3.lat = netcdf.getVar(ncidin,lat_indx);
PW3.lon = netcdf.getVar(ncidin,lon_indx);
PW3.time = netcdf.getVar(ncidin,time_indx);
PW3.grid = netcdf.getVar(ncidin,grid_indx);
PW3.uncorr = netcdf.getVar(ncidin,uncorr_indx);

%encode NaN's
PW3.grid(PW3.grid < -99999) = NaN;
PW3.uncorr(PW3.uncorr < -99999) = NaN;

%get dims
[nlon, nlat, ntime] = size(PW3.grid);
nloc = nlat*nlon;

%reshape for GraphEM
PW3.grid_2d = reshape(PW3.grid, [nloc ntime]);
PW3.grid_2d = PW3.grid_2d'; %time x space
PW3.grid_2d = double(PW3.grid_2d);

%make loc
[x,y] = meshgrid(PW3.lat,PW3.lon);
PW3.loc = [y(:),x(:)];


%save as .mat
oname = 'pseudoworld3.mat';
opath = [odir oname];
save(opath, 'PW3');
