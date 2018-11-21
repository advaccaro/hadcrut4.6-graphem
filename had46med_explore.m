%% Explore the HadCRUT4.6 median to produce GMT and NINO time series

clear all


% Load in GraphEM-infilled data:
data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/';
infile = 'had46med_full_sp60_merra_krig.mat';
inpath = [data_dir infile];
load(inpath)

% Set variables to feed to the explore functions:
grid_2d = SP1.X;
lon_in = H46med.lon;
lat_in = H46med.lat;
time_in = H46med.tser;
loc = loc;

% Run explore function to calculate GMT, NINO, and more:
H46M60_EXP = had_explore(grid_2d,lon_in,lat_in,time_in,loc);

% Save explored file:
outfile = 'H46MED_SP60_MERRA_KRIG_EXP.mat';
outpath = [data_dir outfile];
save(outpath, 'H46M60_EXP')
