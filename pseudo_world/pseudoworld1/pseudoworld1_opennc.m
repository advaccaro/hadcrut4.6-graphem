%pseudoworld1_opennc.m
%opens .nc file and saves as .mat

indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/raw/';
odir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';

inname = 'world_1_historical_pseudo_world_1850-2005_sst_1961-1990.nc';
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
PW1.lat = netcdf.getVar(ncidin,lat_indx);
PW1.lon = netcdf.getVar(ncidin,lon_indx);
PW1.time = netcdf.getVar(ncidin,time_indx);
PW1.grid = netcdf.getVar(ncidin,grid_indx);
PW1.uncorr = netcdf.getVar(ncidin,uncorr_indx);

%encode NaN's
PW1.grid(PW1.grid < -99999) = NaN;
PW1.uncorr(PW1.uncorr < -99999) = NaN;

%get dims
[nlon, nlat, ntime] = size(PW1.grid);
nloc = nlat*nlon;

%reshape for GraphEM
PW1.grid_2d = reshape(PW1.grid, [nloc ntime]);
PW1.grid_2d = PW1.grid_2d'; %time x space
PW1.grid_2d = double(PW1.grid_2d);

%make loc
[x,y] = meshgrid(PW1.lat,PW1.lon);
PW1.loc = [y(:),x(:)];


%save as .mat
oname = 'pseudoworld1.mat';
opath = [odir oname];
save(opath, 'PW1');
