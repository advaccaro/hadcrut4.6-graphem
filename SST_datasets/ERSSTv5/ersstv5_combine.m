%ERSSTv5_combine.m
%Opens individual monthly ERSSTv5 data .mat files and combines into single matrix


indir = '/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/ERSSTv5/data/';
addpath(indir)
folder = indir;
filelist = dir([folder 'ERSSTv5_mon*.mat']);
nfiles = length(filelist); ntime = nfiles;

%load first file to obtain metadata
load(filelist(1).name)
E1 = ERSSTv5_mon; clear ERSSTv5_mon

Ef.lon = E1.lon; nlon = length(E1.lon);
Ef.lat = E1.lat; nlat = length(E1.lat); clear E1
nspace = nlat * nlon;

%time0 = datenum('15-Jan-1854'); %raw time axis is saved as units since jan 15 1854 -- no longer true as of ERSSTv5


%preallocate space for matrices and axes
%Ef.sst_2d = nan(ntime,nspace); %2D SST
%Ef.ssta_2d = nan(ntime,nspace); %2D SSTA
Ef.sst_3d = nan([nlon nlat ntime]); %3D SST
Ef.ssta_3d = nan([nlon nlat ntime]); %3D SSTA
Ef.tser = nan([ntime 1]);


%load monthly data files and save to structure
for i = 1:nfiles
	filename = filelist(i).name;
	load(filename); %all are named ERSSTv5_mon regardless of month
	Em = ERSSTv5_mon; clear ERSSTv5_mon
	%Ef.tser(i) = Em.time + time0;
	Ef.tser(i) = Em.tmdn;	
	Ef.sst_3d(:,:,i) = double(Em.sst);
	Ef.ssta_3d(:,:,i) = double(Em.anom);
	clear Em
end
Ef.sst_3d(Ef.sst_3d <= -999) = NaN;
Ef.ssta_3d(Ef.ssta_3d <= -999) = NaN;
Ef.sst_2d = reshape(Ef.sst_3d, [nspace ntime])'; %time x space
Ef.ssta_2d = reshape(Ef.sst_3d, [nspace ntime])'; %time x space
[x,y] = meshgrid(Ef.lat,Ef.lon);
loc = [y(:),x(:)];  Ef.loc = loc;
ERSSTv5 = Ef; 
clear Ef x y loc

%save
odir = '/home/geovault-02/avaccaro/hadCRUT4.6/SST_datasets/ERSSTv5/data/';
oname = 'ERSSTv5.mat';
opath = [odir oname];
save(opath, 'ERSSTv5')
