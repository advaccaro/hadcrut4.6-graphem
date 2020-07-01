%pseudoworld2_combine.m
%combines lsat and sst into global dataset
indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
odir = indir;
sstfile = 'pseudoworld2_sst.mat';
lsatfile = 'pseudoworld2_lsat.mat';

sstpath = [indir sstfile];
lsatpath = [indir lsatfile];

load(sstpath)
load(lsatpath)


if isequal(PW2_sst.lat,PW2_lsat.lat) == 1
PW2.lat = PW2_sst.lat;
else
display('error: different latitudes')
end

if isequal(PW2_sst.lon,PW2_lsat.lon) == 1
PW2.lon = PW2_sst.lon;
else
display('error: different longitudes')
end

if isequal(PW2_sst.time,PW2_lsat.time) == 1
PW2.time = PW2_sst.time;
else
display('error: different time axes')
end

if isequal(PW2_sst.loc,PW2_lsat.loc) == 1
PW2.loc = PW2_sst.loc;
else
display('error: different locs')
end

indu1 = find(isnan(PW2_sst.uncorr) == 1);
indu2 = find(isnan(PW2_lsat.uncorr) == 1);

PW2.uncorr = PW2_sst.uncorr;
PW2.uncorr(indu1) = PW2_lsat.uncorr(indu1);
PW2.uncorr(indu2) = PW2_sst.uncorr(indu2);

indg1 = find(isnan(PW2_sst.grid) == 1);
indg2 = find(isnan(PW2_lsat.grid) == 1);

PW2.grid = PW2_sst.grid;
PW2.grid(indg1) = PW2_lsat.grid(indg1);
PW2.grid(indg2) = PW2_sst.grid(indg2);

indgd1 = find(isnan(PW2_sst.grid_2d) == 1); 
indgd2 = find(isnan(PW2_lsat.grid_2d) == 1);

PW2.grid_2d = PW2_sst.grid_2d;
PW2.grid_2d(indgd1) = PW2_lsat.grid_2d(indgd1);
PW2.grid_2d(indgd2) = PW2_sst.grid_2d(indgd2);

oname = 'pseudoworld2.mat';
opath = [odir oname];
save(opath, 'PW2')

