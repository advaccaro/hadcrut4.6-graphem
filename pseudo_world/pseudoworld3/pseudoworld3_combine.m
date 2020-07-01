%pseudoworld3_combine.m
%combines lsat and sst into global dataset
indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
odir = indir;
sstfile = 'pseudoworld3_sst.mat';
lsatfile = 'pseudoworld3_lsat.mat';

sstpath = [indir sstfile];
lsatpath = [indir lsatfile];

load(sstpath)
load(lsatpath)


if isequal(PW3_sst.lat,PW3_lsat.lat) == 1
PW3.lat = PW3_sst.lat;
else
display('error: different latitudes')
end

if isequal(PW3_sst.lon,PW3_lsat.lon) == 1
PW3.lon = PW3_sst.lon;
else
display('error: different longitudes')
end

if isequal(PW3_sst.time,PW3_lsat.time) == 1
PW3.time = PW3_sst.time;
else
display('error: different time axes')
end

if isequal(PW3_sst.loc,PW3_lsat.loc) == 1
PW3.loc = PW3_sst.loc;
else
display('error: different locs')
end

indu1 = find(isnan(PW3_sst.uncorr) == 1);
indu2 = find(isnan(PW3_lsat.uncorr) == 1);

PW3.uncorr = PW3_sst.uncorr;
PW3.uncorr(indu1) = PW3_lsat.uncorr(indu1);
PW3.uncorr(indu2) = PW3_sst.uncorr(indu2);

indg1 = find(isnan(PW3_sst.grid) == 1);
indg2 = find(isnan(PW3_lsat.grid) == 1);

PW3.grid = PW3_sst.grid;
PW3.grid(indg1) = PW3_lsat.grid(indg1);
PW3.grid(indg2) = PW3_sst.grid(indg2);

indgd1 = find(isnan(PW3_sst.grid_2d) == 1); 
indgd2 = find(isnan(PW3_lsat.grid_2d) == 1);

PW3.grid_2d = PW3_sst.grid_2d;
PW3.grid_2d(indgd1) = PW3_lsat.grid_2d(indgd1);
PW3.grid_2d(indgd2) = PW3_sst.grid_2d(indgd2);

oname = 'pseudoworld3.mat';
opath = [odir oname];
save(opath, 'PW3')

