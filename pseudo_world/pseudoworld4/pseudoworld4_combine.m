%pseudoworld4_combine.m
%combines lsat and sst into global dataset
indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
odir = indir;
sstfile = 'pseudoworld4_sst.mat';
lsatfile = 'pseudoworld4_lsat.mat';

sstpath = [indir sstfile];
lsatpath = [indir lsatfile];

load(sstpath)
load(lsatpath)


if isequal(PW4_sst.lat,PW4_lsat.lat) == 1
PW4.lat = PW4_sst.lat;
else
display('error: different latitudes')
end

if isequal(PW4_sst.lon,PW4_lsat.lon) == 1
PW4.lon = PW4_sst.lon;
else
display('error: different longitudes')
end

if isequal(PW4_sst.time,PW4_lsat.time) == 1
PW4.time = PW4_sst.time;
else
display('error: different time axes')
tind = ismember(PW4_sst.time,PW4_lsat.time);
PW4.time = PW4_sst.time(tind);
end

if isequal(PW4_sst.loc,PW4_lsat.loc) == 1
PW4.loc = PW4_sst.loc;
else
display('error: different locs')
end

%resize sst to match lsat size
PW4_sst.uncorr = PW4_sst.uncorr(:,:,tind);
PW4_sst.grid = PW4_sst.grid(:,:,tind);
PW4_sst.grid_2d = PW4_sst.grid_2d(tind,:)


indu1 = find(isnan(PW4_sst.uncorr) == 1);
indu2 = find(isnan(PW4_lsat.uncorr) == 1);

PW4.uncorr = PW4_sst.uncorr;
PW4.uncorr(indu1) = PW4_lsat.uncorr(indu1);
PW4.uncorr(indu2) = PW4_sst.uncorr(indu2);

indg1 = find(isnan(PW4_sst.grid) == 1);
indg2 = find(isnan(PW4_lsat.grid) == 1);

PW4.grid = PW4_sst.grid;
PW4.grid(indg1) = PW4_lsat.grid(indg1);
PW4.grid(indg2) = PW4_sst.grid(indg2);

indgd1 = find(isnan(PW4_sst.grid_2d) == 1); 
indgd2 = find(isnan(PW4_lsat.grid_2d) == 1);

PW4.grid_2d = PW4_sst.grid_2d;
PW4.grid_2d(indgd1) = PW4_lsat.grid_2d(indgd1);
PW4.grid_2d(indgd2) = PW4_sst.grid_2d(indgd2);

oname = 'pseudoworld4.mat';
opath = [odir oname];
save(opath, 'PW4')

