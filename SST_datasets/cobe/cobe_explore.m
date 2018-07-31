%   LOADS in temperature Data from raw HadCRUT4.2 median w/ UAH satellite data and makes it usable

%   
%    History : Created 02/3/15 from  Kaplan_SST_explore_v3.m
addpath(genpath('/home/geovault-00/rverna/hadCRUT4.6/'))


load('cobe_sst.mat')
%  (time unit in months since 1960).
tser = [datenum(1891,1,15) + cobe.time];


[COBE_NINO] = nino_explore(cobe.sst,cobe.lon,cobe.lat,tser);


odir = '/home/geovault-00/rverna/hadCRUT4.6/SST_datasets/cobe/';
savetag = 'COBE_NINO.mat';
savefile = [odir savetag];

save(savefile, 'COBE_NINO')


%% OLD VERSION BELOW

%reshape data to 3d
%[nlon,nlat,nmon] = size(cobe.sst);
%%sst_3d = reshape(had4med',[nlon, nlat, nmon]);
%sst_3d = cobe.sst;

% fix grids
%lon  = double(cobe.lon); lon(lon<0) = lon(lon<0) + 360;
%lat=double(cobe.lat); 
%tr = double(cobe.time); % raw time, in units of days since 1891-1-1 00:00:00
%tn = tr + datenum(1891,1,15);  % convert to standard serial date (i.e. add 1800 years)
%tv = datevec(tn); 
%t = tv(:,1)+tv(:,2)/12-1/12;
%sstr  = double(sst_3d); % may need to increase Java Heap memory space to load (Preferences panel)
%keep everything out to 2013
%%sst = sstr(:,:,t<2014);
%sst = sstr;

%%t = t(t<2014);
% Dimensions
%nx=length(lon); % 5 by 5 deg
%ny=length(lat);
%ns=nx*ny;
%nt=length(t);  nyrs = floor(nt/12);


% compute climatoly
%ind = find(t >= 1961 & t < 1991); 
%sstp = permute(sst, [3 2 1]);
%sstp12 = sstp(1:nyrs*12,:,:);
%sst_clim = climatology(sstp(ind,:,:));  
%ssta = sstp12 - repmat(sst_clim,[nyrs 1 1]);

%  Find land points and replace by NaN's
%%land = isnan(ssta);

% NINO3/4 computation
%NINO3_x=find(lon >=210 & lon <=270);
%NINO3_y=find(lat>=-5 & lat <=5);
%NINO3=nmean(nmean(ssta(:,NINO3_y,NINO3_x),2),3);
%NINO34_x=find(lon >=190 & lon <=240);  % (170W to 120 W)
%NINO34=nmean(nmean(ssta(:,NINO3_y,NINO34_x),2),3);
%NINO34m = NINO34;

%12 month mean
%nyear12 = (floor(nt/12)); years12 = [t(1): t(1) + nyear12 - 1];
%for i = 1:nyear12
%	NINO34a_yr(i) = nmean(NINO34(12*(i-1)+1:12*i));
%end


% flip it to most recent first
%SST_K=flipdim(ssta,1);
%tk=flipud(t);
%NINO3f = flipud(NINO3); NINO34f = flipud(NINO34);

% convert time axis using datenum technology
%year=floor(tk); 
%month=round((tk-year)*12)+1;
%tv=[year , month  , repmat(15,nt,1)];
%tn=datenum(tv);
%tm=datestr(tn);
%  declare arrays
%ta=[max(year):-1:min(year)+1]'; na=length(ta);
%SST_Kw = zeros(na,ny,nx);
%NINO3a = zeros(na,1);
% Average over DJF period (NH Winter, W)
%for k=1:na
%	feb=find(tn==datenum([ta(k),2,15,0,0,0]));
%	dec=find(tn==datenum([ta(k)-1,12,15,0,0,0]));
%	SST_Kw(k,:,:)= nmean(SST_K(feb:dec,:,:),1); 
%	%SST_Kw(k,:,:)	
%	NINO3ka(k)=nmean(NINO3f(feb:dec));
%	NINO34ka(k)=nmean(NINO34f(feb:dec));
%end

%NINO3a_djf = NINO3ka;
%NINO34a_djf = NINO34ka;
		
% Time convention  DJF[n]=Dec[n-1] + Jan[n] + Feb[n] , n from 1857 to 2000.

%%%%%%%%%%%%%%%%%%%%%%%%%
% select ocean points and reshape
%tmp=reshape(SST_Kw,na,ns);
%ocean=~isnan(tmp(1,:));
%SSTo=tmp(:,ocean); 
%[nyears,nr]=size(SSTo);
%s=[1:nr];


% NINO3 check
%NINO3w=nmean(nmean(SST_Kw(:,NINO3_y,NINO3_x),2),3);


% Decadal smoothing
%NINO34d_djf = hepta_smooth(NINO34a_djf,1/10);
%NINO34d_yr = hepta_smooth(NINO34a_yr,1/10);
%NINO34d_full = hepta_smooth(NINO34m,1/120);


% Graphic check
%fig('Kaplan sanity check')
%subplot(3,1,1:2)
%pcolor(s,ta,SSTo)
%subplot(3,1,3)
%plot(t,NINO3), hold on, axis tight
%plot(ta,NINO3w,'g-',ta,NINO3a,'r-','linewidth',[2]),hold off





%  Assign to structure and save
%
%DATASET.SSTm=flipud(SST_K); % monthly values
%DATASET.SSTa_djf=flipud(SST_Kw);  %  DJF avg
%DATASET.SSTo_djf=flipud(SSTo);    %   DJF avg on ocean pts only (no NaNs)
%DATASET.lon=lon;
%DATASET.lat=lat;
%DATASET.ta_yr = years12;
%DATASET.ta_djf=ta;
%DATASET.tm=tm;
%DATASET.tmdn = datenum(tm);
%DATASET.tmfrac = t;
%DATASET.td_djf = ta;
%DATASET.td_yr = years12;
%DATASET.td_full = t;
%DATASET.NINO3=NINO3a;
%DATASET.NINO34m=NINO34m;
%DATASET.NINO34a_djf=NINO34a_djf;
%DATASET.NINO34a_yr = NINO34a_yr;
%DATASET.NINO34d_djf = NINO34d_djf;
%DATASET.NINO34d_yr = NINO34d_yr;
%DATASET.NINO34d_full = NINO34d_full;
%DATASET.ocean_pts=ocean;
%%COBE.GMMT=GMMT;
%COBE = DATASET;








