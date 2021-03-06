%pseudoworld1_combine.m
%combines lsat and sst into global dataset
indir = '/home/scec-02/avaccaro/HadCRUT4.2/pseudo_world/data/';
odir = indir;
sstfile = 'pseudoworld1_sst.mat';
lsatfile = 'pseudoworld1_lsat.mat';

sstpath = [indir sstfile];
lsatpath = [indir lsatfile];

load(sstpath)
load(lsatpath)

[nlon,nlat,nmon] = size(PW1_sst.grid); nloc = nlon * nlat;

if isequal(PW1_sst.lat,PW1_lsat.lat) == 1
PW1.lat = PW1_sst.lat;
else
display('error: different latitudes')
end

if isequal(PW1_sst.lon,PW1_lsat.lon) == 1
PW1.lon = PW1_sst.lon;
else
display('error: different longitudes')
end

if isequal(PW1_sst.time,PW1_lsat.time) == 1
PW1.time = PW1_sst.time;
else
display('error: different time axes')
end

if isequal(PW1_sst.loc,PW1_lsat.loc) == 1
PW1.loc = PW1_sst.loc;
else
display('error: different locs')
end


allvs = [1:2592]; nv = length(allvs);
clear n; n=1;
for i = 1:nv
if sum(isnan(PW1_lsat.grid_2d(:,i))) == numel(PW1_lsat.grid_2d(:,i))
ocean1(n) = i;
n=n+1;
end
end
land1 = setdiff(allvs,ocean1);

clear m; m=1;
for i = 1:nv
if sum(isnan(PW1_sst.grid_2d(:,i))) == numel(PW1_sst.grid_2d(:,i))
land2(m) = i;
m=m+1;
end
end
ocean2 = setdiff(allvs,land2);




PW1.grid_2d = nan(nmon,nloc);
PW1.uncorr_2d = nan(nmon,nloc);
PW1.grid_2d(:,land1) = PW1_lsat.grid_2d(:,land1);
PW1.uncorr_2d(:,land1) = PW1_lsat.uncorr_2d(:,land1);
PW1.grid_2d(:,ocean2) = PW1_sst.grid_2d(:,ocean2);
PW1.uncorr_2d(:,ocean2) = PW1_sst.grid_2d(:,ocean2);

%PW1.uncorr = nan(nlon,nlat,nmon);
%PW1.grid = nan(nlon,nlat,nmon);
%PW1.grid_2d = nan(nmon,nloc);

%indu1 = find(isnan(PW1_sst.uncorr) == 1);
%indu2 = find(isnan(PW1_lsat.uncorr) == 1);

%%PW1.uncorr = PW1_sst.uncorr;
%PW1.uncorr(indu1) = PW1_lsat.uncorr(indu1);
%PW1.uncorr(indu2) = PW1_sst.uncorr(indu2);

%indg1 = find(isnan(PW1_sst.grid) == 1);
%indg2 = find(isnan(PW1_lsat.grid) == 1);

%%PW1.grid = PW1_sst.grid;
%PW1.grid(indg1) = PW1_lsat.grid(indg1);
%PW1.grid(indg2) = PW1_sst.grid(indg2);

%indgd1 = find(isnan(PW1_sst.grid_2d) == 1); 
%indgd2 = find(isnan(PW1_lsat.grid_2d) == 1);

%%PW1.grid_2d = PW1_sst.grid_2d;
%PW1.grid_2d(indgd1) = PW1_lsat.grid_2d(indgd1);
%PW1.grid_2d(indgd2) = PW1_sst.grid_2d(indgd2);


%PW1.uncorr = ones(nlon,nlat,nmon)*-999999;
%PW1.grid = ones(nlon,nlat,nmon)*-999999;
%PW1.grid_2d = ones(nmon,nloc)*-999999;

%for i = 1:nlon
%for j = 1:nlat
%for k = 1:nmon
%sstuncorr = isnan(PW1_sst.uncorr(i,j,k));
%lsatuncorr = isnan(PW1_lsat.uncorr(i,j,k));
%if sstuncorr == 0 & lsatuncorr == 1
%PW1.uncorr(i,j,k) = PW1_sst.uncorr(i,j,k);
%elseif sstuncorr == 1 & lsatuncorr == 0
%PW1.uncorr(i,j,k) = PW1_lsat.uncorr(i,j,k);
%elseif sstuncorr == 1 & lsatuncorr == 1
%PW1.uncorr(i,j,k) = NaN;
%elseif sstuncorr == 0 & lsatuncorr == 0
%equality = isequal(PW1_sst.uncorr(i,j,k),PW1_lsat.uncorr(i,j,k));
%if equality == 1
%PW1.uncorr(i,j,k) = PW1_sst.uncorr(i,j,k)
%else
%display(['error! at ijk:' num2str(i) num2str(j) num2str(k)])
%end
%end
%end
%end
%end

%for i = 1:nlon
%for j = 1:nlat
%for k = 1:nmon
%sstgrid = isnan(PW1_sst.grid(i,j,k));
%lsatgrid = isnan(PW1_lsat.grid(i,j,k));
%if sstgrid == 0 & lsatgrid == 1
%PW1.grid(i,j,k) = PW1_sst.grid(i,j,k);
%elseif sstgrid == 1 & lsatgrid == 0
%PW1.grid(i,j,k) = PW1_lsat.grid(i,j,k);
%elseif sstgrid == 1 & lsatgrid == 1
%PW1.grid(i,j,k) = NaN;
%elseif sstgrid == 0 & lsatgrid == 0
%display(['error! at ijk:' num2str(i) num2str(j) num2str(k)])
%end
%end
%end
%end

%for i = 1:nmon
%for j = 1:nloc
%sstgrid2d = isnan(PW1_sst.grid_2d(i,j));
%lsatgrid2d = isnan(PW1_lsat.grid_2d(i,j));
%if sstgrid2d == 0 & lsatgrid2d == 1
%PW1.grid_2d(i,j) = PW1_sst.grid_2d(i,j);
%elseif sstgrid2d == 1 & lsatgrid2d == 0
%PW1.grid_2d(i,j) = PW1_lsat.grid_2d(i,j);
%elseif sstgrid2d == 1 & lsatgrid2d == 1
%PW1.grid_2d(i,j) = NaN;
%elseif sstgrid2d == 0 & lsatgrid2d == 0
%display(['error! at ijk:' num2str(i) num2str(j) num2str(k)])
%end
%end
%end




%oname = 'pseudoworld1.mat';
%opath = [odir oname];
%save(opath, 'PW1')


%PW1.uncorr = nan(nlon,nlat,nmon);
%PW1.grid = nan(nlon,nlat,nmon);
%PW1.grid_2d = nan(nmon,nloc);

%for i = 1:nmon
%indu1 = ~isnan(PW1_sst.uncorr(:,:,i));
%indu2 = ~isnan(PW1_lsat.uncorr(:,:,i));
%PW1.uncorr([indu1 i]) = PW1_sst.uncorr(indu1);
%PW1.uncorr([indu2 i]) = PW1_lsat.uncorr(indu2);

%indg1 = ~isnan(PW1_sst.grid(:,:,i));
%indg2 = ~isnan(PW1_lsat.grid(:,:,i));
%PW1.grid([indg1 i]) = PW1_sst.grid(indg1);
%PW1.grid([indg2 i]) = PW1_lsat.grid(indg2);

%indgd1 = ~isnan(PW1_sst.grid_2d(i,:));
%indgd2 = ~isnan(PW1_lsat.grid_2d(i,:));
%PW1.grid_2d([indgd1 i]) = PW1_sst.grid_2d(indgd1);
%PW1.grid_2d([indgd2 i]) = PW1_lsat.grid_2d(indgd2);
%end


oname2 = 'pseudoworld1_recom.mat';
opath2 = [odir oname2];
save(opath2, 'PW1')

