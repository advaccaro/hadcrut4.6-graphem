%had46ens_master.m
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))

%% Initialize (define vars, preallocate, etc.)

%Load raw data (median)
raw = load('/home/geovault-02/avaccaro/hadcrut4.6-graphem/data/had46med.mat');
[nlon,nlat,nmon] = size(raw.H46med.x);
%nm = 1973; %nmons defined explicitly! (ONLY FOR INFILLED ENS MEMBERS, NOT MEDIAN)
lon = raw.H46med.lon;
lat = raw.H46med.lat;
[nt,ns] = size(raw.had46med); %nmonths x nstations
ny = floor(nt/12); %nyears
years = [1850:2017];
nm = ny*12; %number of months

%[x,y] = meshgrid(raw.H46med.lon,raw.H46med.lat);
%loc = [x(:),y(:)];
loc = raw.loc;
time = raw.H46med.tser;
%time = zeros(1973,1);
%time(1:1972) = 675700 + raw.H46med.time;
%time(end) = time(end-1)+30.5;

%weights = repmat(cosd(loc(:,2)), [1 ny]); %weights by lat for global mean
weights = repmat(cosd(loc(:,2)), [1 nmon]);


%% Unpack .mat files/Assemble 100-member ensemble
datadir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/ensemble/data/';
datalist = dir([datadir '/*sp60_merra_krig.mat']); %list of .mat files
ndata = length(datalist);

%ENS.globalmean = nan(ny,ndata);
%ENS.globalmean = nan(nmon,ndata);
%ENS.nino34 = nan(nmon,ndata);

ENS.globalmean = nan(nm,ndata);
ENS.nino34 = nan(nm,ndata);

for i = 1:ndata
filename = datalist(i).name;
E = had46ens_explore(filename); %function: had43ens_explore computes GMMT and NINO3.4 for each file
ENS.globalmean(:,i) = E.GMTm;
ENS.nino34(:,i) = E.NINO34m;
clear filename E
end

%E = load(filename); %Load ensemble member

%%% Global Annual mean

% %Annualize
% had43ens_ann = nan(ny,ns);
% for k = 1:ns
% for j = 1:ny
% had43ens_ann(j,k) = mean(E.Xf_sp(1+(j-1)*12:12*j,k));
% end
% end

%%Create global monthly mean time series
%temp = nan(nmon,1);
%for j = 1:nmon
%temp(j) = (E.Xf_sp(j,:)*weights(:,j))/sum(weights(:,j));
%end


% %Create global annual mean time series
% temp = nan(ny,1);
% for j = 1:ny
% temp(j) = (had43ens_ann(j,:)*weights(:,j))/sum(weights(:,j));
% end

%ENS.globalmean(:,i) = temp;

%% Nino3.4
%[nm,~] = size(E.Xf_sp);
%Xc = center(E.Xf_sp);
%Xc_3d = reshape(Xc', [nlon,nlat,nm]);
%[nino12,nino3,nino4,nino34] = nino_indices(Xc_3d, lon, lat);
%ENS.nino34(:,i) = nino34(1:end-1); %WARNING: ***EXTREMELY AD-HOC!!!***

%clear E filename temp had4ens_ann Xc Xc_3d
%end

%save ENS.mat ENS

%% Calculate quantiles, median, mean
% %Global annual mean
% for i = 1:ny
% globalmean_sum(i,:) = quantile(ENS.globalmean(i,:),[.05 .25 .5 .75 .95]);
% end

%global monthly mean temperature
for i = 1:nm
globalmean_sum(i,:) = quantile(ENS.globalmean(i,:),[.025 .25 .5 .75 .975]);
end


%Nino34
for i = 1:nm
nino34_sum(i,:) = quantile(ENS.nino34(i,:),[.025 .25 .5 .75 .975]);
end

ENS.globalmean_sum = globalmean_sum;
ENS.nino34_sum = nino34_sum;

ENS.tser = raw.H46med.tser;
ENS.tfrac = raw.H46med.tfrac;

odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/ensemble/data/';
ofile = 'ENS_sp60.mat';

opath = [odir ofile];
save(opath, 'ENS')


%% Plotting
%fig(1)
%hold on;
%plot(years,globalmean_sum)
%fancyplot_deco('12-Month Global Mean Temperature over Land & Ocean','Year','deg C')
%hepta_figprint('had4ens_globalmean')


%fig(2)
%hold on;
%plot(time,nino34_sum)
%datetick('x','yyyy')
%hleg = legend('')
%set(hleg, 'Location', 'SouthEast')
%legend('boxoff')
%fancyplot_deco('NINO3.4 SST Anomaly', 'Year', 'deg C')
%hepta_figprint('had4ens_nino34')




