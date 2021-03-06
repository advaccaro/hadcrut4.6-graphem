function [NAME_EXP] = had_explore(grid_2d,lon_in,lat_in,time_in,loc)
%% nino_explore.m
% INPUTS: sst_in - 3d sst data (lonxlatxtime)
% 		  lon_in - vector of longitudes
%		  lat_in - vector of latitudes
%		  time_in - time axis in standard serial time (days since Jan-0-0000)



[nmon,nloc] = size(grid_2d);
%sst_3d = reshape(had4med',[nlon, nlat, nmon]);
%sst_3d = sst_in;

% fix grids
lon  = double(lon_in); lon(lon<0) = lon(lon<0) + 360;
lat=double(lat_in); 
nlat = length(lat); nlon = length(lon);

grid_3d = reshape(grid_2d', [nlon nlat nmon]);


%tr = double(cobe.time); % raw time, in units of days since 1891-1-1 00:00:00
%tn = tr + datenum(1891,1,15);  % convert to standard serial date (i.e. add 1800 years)
tn = time_in; %time in standard serial date (days since jan-0-0000)
tv = datevec(tn); 
t = tv(:,1)+tv(:,2)/12-1/12;
%sstr  = double(sst_3d); % may need to increase Java Heap memory space to load (Preferences panel)
%keep everything out to 2013
%sst = sstr(:,:,t<2014);
%sst = sstr;

%t = t(t<2014);
% Dimensions
nx=length(lon); % 5 by 5 deg
ny=length(lat);
ns=nx*ny;
nt=length(t);  nyrs = floor(nt/12);


% GMMT
GRID = grid_2d;
temp = nan(nt,1);
temp_area = nan(nt,1);
tempsh = nan(nt,1);
tempnh = nan(nt,1);
weights = flipud(repmat(cosd(loc(:,2)),[1,nt]));
% weight by area
for i = 1:ns
	lat_center = loc(i,2);
	lon_center = loc(i,1);
	lat1 = lat_center-2.5;
	lat2 = lat_center+2.5;
	lon1 = lon_center-2.5;
	lon2 = lon_center+2.5;
	areas(i) = ((pi/180)*6371^2)*abs(sind(lat1)-sind(lat2))*abs(lon1-lon2);
end
area_weights = repmat(areas, [nt,1])';
nh = find(loc(:,2)>0);
sh = find(loc(:,2)<0);
%weights(isnan(GRID)) = 0;
%area_weights(isnan(GRID)) = 0;
%GRID(isnan(GRID)) = 0;
for i = 1:nt
	% normalize weights to sum to one
	%weights(:,i) = weights(:,i)/sum(weights(:,i));
	%area_weights(:,i) = area_weights(:,i)/sum(area_weights(:,i));
	%shweights = area_weights(sh,i)/sum(area_weights(sh,i));
	%nhweights = area_weights(nh,i)/sum(area_weights(nh,i));
	%area_weights(isnan(GRID(
	%weights(isnan(GRID(i,:))) = 0;
	%GRID(i,(isnan(GRID(i,:)))) = 0;
	%temp(i) = (GRID(i,:)*weights(:,i))/sum(weights(:,i));
	%temp_area(i) = (GRID(i,:)*area_weights(:,i))/sum(area_weights(:,i));
	%tempsh(i) = (GRID(i,sh)*area_weights(sh,i))/sum(area_weights(sh,i));
	%tempnh(i) = (GRID(i,nh)*area_weights(nh,i))/sum(area_weights(nh,i));
	%tempsh(i) = GRID(i,sh)*shweights;
	%tempnh(i) = GRID(i,nh)*nhweights;
	g = GRID(i,:);
	nn = ~isnan(g);
	gnn = g(nn);
	wnn = weights(nn,i);
	wnn = wnn/sum(wnn);
	temp(i) = gnn*wnn;
	aw = area_weights(:,i);
	awnn = aw(nn)/sum(aw(nn));
	temp_area(i) = gnn*awnn;
	gsh = g(sh);
	nnsh = ~isnan(gsh);
	awsh = aw(sh);
	awshnn = awsh(nnsh)/sum(awsh(nnsh));
	tempsh(i) = gsh(nnsh)*awshnn;
	gnh = g(nh);
	nnnh = ~isnan(gnh);
	awnh = aw(nh);
	awnhnn = awnh(nnnh)/sum(awnh(nnnh));
	tempnh(i) = gnh(nnnh)*awnhnn;
	
end
nhsh = (tempsh+tempnh)/2;
%GMMT = temp;
GMMT = nhsh;
GMTm = GMMT;

for i = 1:nyrs
	GMMTa_yr(i) = nmean(GMMT(12*(i-1)+1:12*i));
end


% compute climatoly
%ind = find(t >= 1961 & t < 1991); 
%sstp = permute(sst, [3 2 1]);
%sstp12 = sstp(1:nyrs*12,:,:);
%sst_clim = climatology(sstp(ind,:,:));  
%ssta = sstp12 - repmat(sst_clim,[nyrs 1 1]);
%ssta = sst; %already anomalies
grid_3dp = permute(grid_3d, [3 2 1]);

%  Find land points and replace by NaN's
%land = isnan(ssta);

% NINO3/4 computation
NINO3_x=find(lon >=210 & lon <=270);
NINO3_y=find(lat>=-5 & lat <=5);
NINO3=nmean(nmean(grid_3dp(:,NINO3_y,NINO3_x),2),3);
NINO34_x=find(lon >=190 & lon <=240);  % (170W to 120 W)
NINO34=nmean(nmean(grid_3dp(:,NINO3_y,NINO34_x),2),3);
NINO34m = NINO34;


%12 month mean
years12 = [t(1): t(1) + nyrs - 1];
for i = 1:nyrs
	NINO34a_yr(i) = nmean(NINO34(12*(i-1)+1:12*i));
end

% Latitude Band computations
LAT_90S_60S_y = find(lat>= -90 & lat <= -60);
LAT_90S_60S=nmean(nmean(grid_3dp(:,LAT_90S_60S_y,:),2),3);
LAT_60S_30S_y = find(lat>=-60 & lat <= -30);
LAT_60S_30S=nmean(nmean(grid_3dp(:,LAT_60S_30S_y,:),2),3);
LAT_30S_0_y = find(lat >= -30 & lat <= 0);
LAT_30S_0=nmean(nmean(grid_3dp(:,LAT_30S_0_y,:),2),3);
LAT_0_30N_y = find(lat >= 0 & lat <= 30);
LAT_0_30N=nmean(nmean(grid_3dp(:,LAT_0_30N_y,:),2),3);
LAT_30N_60N_y = find(lat >= 30 & lat <= 60);
LAT_30N_60N = nmean(nmean(grid_3dp(:,LAT_30N_60N_y,:),2),3);
LAT_60N_90N_y = find(lat >= 60 & lat <= 90);
LAT_60N_90N = nmean(nmean(grid_3dp(:,LAT_60N_90N_y,:),2),3);

% Lat Bands averaged overtime
lats = [-90:10:90]; nlats = length(lats);
%time_groups = ;

% flip it to most recent first
GRID_3DK=flipdim(grid_3dp,1);
tk=flipud(t);
NINO34f = flipud(NINO34); GMMTf = flipud(GMMT);

% convert time axis using datenum technology
year=floor(tk); 
month=round((tk-year)*12)+1;
tv=[year , month  , repmat(15,nt,1)];
tn=datenum(tv);
tm=datestr(tn);
%  declare arrays
ta=[max(year):-1:min(year)+1]'; na=length(ta);


% Average over DJF period (NH Winter, W)
for k=1:na
	feb=find(tn==datenum([ta(k),2,15,0,0,0]));
	dec=find(tn==datenum([ta(k)-1,12,15,0,0,0]));
	GRID_3DKw(k,:,:)= nmean(GRID_3DK(feb:dec,:,:),1); 
	%SST_Kw(k,:,:)	
	NINO34ka(k)=nmean(NINO34f(feb:dec));
	GMMTa_djf(k)=nmean(GMMTf(feb:dec));
end


NINO34a_djf = NINO34ka;
		
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
NINO34d_djf_in = hepta_smooth(NINO34a_djf(find(~isnan(NINO34a_djf)==1)),1/10);
NINO34d_yr_in = hepta_smooth(NINO34a_yr(find(~isnan(NINO34a_yr)==1)),1/10);
NINO34d_full_in = hepta_smooth(NINO34m(find(~isnan(NINO34m)==1)),1/120);
GMMTd_yr = hepta_smooth(GMMTa_yr,1/10);
GMMTd_full = hepta_smooth(GMMT,1/120);
GMTd_full = GMMTd_full;
GMMTd_djf = hepta_smooth(GMMTa_djf,1/10);

NINO34d_djf = nan(length(NINO34a_djf),1);
NINO34d_djf(find(~isnan(NINO34a_djf)==1)) = NINO34d_djf_in;
NINO34d_yr = nan(length(NINO34a_yr),1);
NINO34d_yr(find(~isnan(NINO34a_yr)==1)) = NINO34d_yr_in;
NINO34d_full = nan(length(NINO34m),1);
NINO34d_full(find(~isnan(NINO34m)==1)) = NINO34d_full_in;



%Trend lines
years = [floor(min(t)):floor(max(t))];
nyears = length(years) - 1;
trendcoeffs = polyfit(t,GMMT,1);
trendcoeff = trendcoeffs(1)*100;
trend = polyval(trendcoeffs,t);
LM = fitlm(t,GMMT);
CI = coefCI(LM);
trendcoeffsd = polyfit(t,GMMTd_full,1);
trendcoeffd = trendcoeffsd(1)*100;
trendd = polyval(trendcoeffsd,t);
LMd = fitlm(t,GMMTd_full);
CId = coefCI(LMd);

%Trend from 1998-end
years = [1998:floor(max(t))];
nyears = length(years) - 1;
trind = find(t >= 1998);
tmr=t(trind);
GMMTr = GMMT(trind,:);
trendcoeffsr = polyfit(tmr,GMMTr,1);
trendcoeffr = trendcoeffsr(1)*100;
trendr = polyval(trendcoeffsr,tmr);
LMr = fitlm(tmr,GMMTr);
GMTrd = GMMTd_full(trind,:);
trendcoeffsrd = polyfit(tmr,GMTrd,1);
trendcoeffrd = trendcoeffsrd(1)*100;
trendrd = polyval(trendcoeffsrd,tmr);
%LMrd = fitlm(tmr, GMMTd_full);


%hiatus trend
years = [1998:2013];
nyears = length(years);
thind = find (t >= 1998 & t < 2014);
tmh = t(thind);
GMTmh = GMTm(thind);
trendcoeffsh = polyfit(tmh, GMTmh, 1);
trendcoeffh = trendcoeffsh(1) * 100;
trendh = polyval(trendcoeffsh, tmh);
LMh = fitlm(tmh, GMTmh);
GMTdh = GMTd_full(thind,:);
trendcoeffshd = polyfit(tmh, GMTdh, 1);
trendcoeffhd = trendcoeffshd(1)*100;
trendhd = polyval(trendcoeffshd, tmh);
LMhd = fitlm(tmh, GMTdh);

%20th century trend
nyears = 100;
t20ind = find(t >= 1900 & t< 2000);
tm20 = t(t20ind);
GMT20=GMMT(t20ind,:);
trendcoeffs20 = polyfit(tm20,GMT20,1);
trendcoeff20 = trendcoeffs20(1)*100;
trend20 = polyval(trendcoeffs20,tm20);
LM20 = fitlm(tm20, GMT20);

%1951-2000
years = [1951:2000]; nyears = length(years);
t1951 = find(t >= 1951 & t < 2001);
tm1951 = t(t1951);
GMT1951 = GMMT(t1951,:);
trendcoeffs1951 = polyfit(tm1951,GMT1951,1);
trendcoeff1951 = trendcoeffs1951(1)*100;
trend1951 = polyval(trendcoeffs1951,tm1951);
LM1951 = fitlm(tm1951, GMT1951);

% common
years = [1880:2017];
nyears = length(years);
tcom = find(t >= 1880 & t < 2018);
tmcom = t(tcom);
GMTcom = GMTm(tcom,:);
trendcoeffscom = polyfit(tmcom, GMTcom, 1);
trendcoeffcom = trendcoeffscom(1)*100;
trendcom = polyval(trendcoeffscom,tmcom);
LMcom = fitlm(tmcom, GMTcom);

% Graphic check
%fig('Kaplan sanity check')
%subplot(3,1,1:2)
%pcolor(s,ta,SSTo)
%subplot(3,1,3)
%plot(t,NINO3), hold on, axis tight
%plot(ta,NINO3w,'g-',ta,NINO3a,'r-','linewidth',[2]),hold off





%  Assign to structure and save
%
DATASET.SSTm=flipud(GRID_3DK); % monthly values
DATASET.SSTa_djf=flipud(GRID_3DKw);  %  DJF avg
DATASET.lon=lon;
DATASET.lat=lat;
DATASET.ta_yr = years12;
DATASET.ta_djf=ta;
DATASET.tm=flipud(tm(1:length(NINO34m),:));
DATASET.tmdn = flipud(datenum(DATASET.tm));
DATASET.tmfrac = t(1:length(NINO34m));
DATASET.tmr = tmr;
DATASET.tm20 = tm20;
DATASET.tm1951 = tm1951;
DATASET.td_djf = ta;
DATASET.td_yr = years12;
DATASET.td_full = t(1:length(NINO34d_full));
DATASET.NINO34m=NINO34m;
DATASET.NINO34a_djf=NINO34a_djf;
DATASET.NINO34a_yr = NINO34a_yr;
DATASET.NINO34d_djf = NINO34d_djf;
DATASET.NINO34d_yr = NINO34d_yr;
DATASET.NINO34d_full = NINO34d_full;
DATASET.GMTm = GMMT;
DATASET.GMTm_sh = tempsh;
DATASET.GMTm_nh = tempnh;
DATASET.GMTa_djf = GMMTa_djf;
DATASET.GMTa_yr = GMMTa_yr;
DATASET.GMTd_djf = GMMTd_djf;
DATASET.GMTd_yr =GMMTd_yr;
DATASET.GMTd_full = GMMTd_full;
DATASET.LAT_90S_60S = LAT_90S_60S;
DATASET.LAT_60S_30S = LAT_60S_30S;
DATASET.LAT_30S_0 = LAT_30S_0;
DATASET.LAT_0_30N = LAT_0_30N;
DATASET.LAT_30N_60N = LAT_30N_60N;
DATASET.LAT_60N_90N = LAT_60N_90N;
DATASET.trendcoeffs = trendcoeffs;
DATASET.trendcoeffsd = trendcoeffsd;
DATASET.trendcoeffsr = trendcoeffsr;
DATASET.trendcoeffsrd = trendcoeffsrd;
DATASET.trendcoeffs20 = trendcoeffs20;
DATASET.trendcoeffs1951 = trendcoeffs1951;
DATASET.trendcoeffsh = trendcoeffsh;
DATASET.trendcoeffshd = trendcoeffshd;
DATASET.trendcoeffscom = trendcoeffscom;
DATASET.trendcoeff = trendcoeff;
DATASET.trendcoeffd = trendcoeffd;
DATASET.trendcoeffr = trendcoeffr;
DATASET.trendcoeffrd = trendcoeffrd;
DATASET.trendcoeff20 = trendcoeff20;
DATASET.trendcoeff1951 = trendcoeff1951;
DATASET.trendcoeffh = trendcoeffh;
DATASET.trendcoeffhd = trendcoeffhd;
DATASET.trendcoeffcom = trendcoeffcom;
DATASET.trend = trend;
DATASET.trendd = trendd;
DATASET.trendr = trendr;
DATASET.trendrd = trendrd;
DATASET.trend20 = trend20;
DATASET.trend1951 = trend1951;
DATASET.trendh = trendh;
DATASET.trendhd = trendhd;
DATASET.trendcom = trendcom;
DATASET.LM = LM;
DATASET.LMd = LMd;
DATASET.LMr = LMr;
%DATASET.LMrd = LMrd;
DATASET.LMh = LMh;
DATASET.LMhd = LMhd;
DATASET.LM20 = LM20;
DATASET.LM1951 = LM1951;
DATASET.LMcom = LMcom;



%COBE.GMMT=GMMT;
NAME_EXP = DATASET;
