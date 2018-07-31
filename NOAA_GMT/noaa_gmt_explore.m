%noaa_explore.m

addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))


load('NOAA.mat')

%extract stuff from data structure
tfrac = NOAA.tfrac; tmdn = NOAA.tm; nt = length(tfrac);
temp = NOAA.GMTm; mon = NOAA.mon;

%need to compute climatology (there's got to be a better way to do this)
dv = datevec(tmdn);
indJan = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 1);
indFeb = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 2);
indMar = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 3);
indApr = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 4);
indMay = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 5);
indJun = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 6);
indJul = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 7);
indAug = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 8);
indSep = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 9);
indOct = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 10);
indNov = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 11);
indDec = find(dv(:,1) >= 1961 & dv(:,1) <= 1990 & dv(:,2) == 12);


mJan = mean(temp(indJan));
mFeb = mean(temp(indFeb));
mMar = mean(temp(indMar));
mApr = mean(temp(indApr));
mMay = mean(temp(indMay));
mJun = mean(temp(indJun));
mJul = mean(temp(indJul));
mAug = mean(temp(indAug));
mSep = mean(temp(indSep));
mOct = mean(temp(indOct));
mNov = mean(temp(indNov));
mDec = mean(temp(indDec));

climatology = [mJan mFeb mMar mApr mMay mJun mJul mAug mSep mOct mNov mDec];


anom = nan(nt,1);

for i = 1:nt
	anom(i) = temp(i) - climatology(mon(i));
end

GMTm = anom;

% Annualize
nyears = floor(nt/12);
years = [tfrac(1):tfrac+nyears-1];
for i = 1:nyears
	GMTa_yr(i) = mean(GMTm(12*(i-1)+1:12*i));
end


%Decadal smoothing
GMTd_yr = hepta_smooth(GMTa_yr,1/10);
GMTd_full = hepta_smooth(GMTm,1/120);

%Trend
years = [floor(min(tfrac)):floor(max(tfrac))];
nyears = length(years) - 1;
trendcoeffs = polyfit(tfrac,GMTm,1);
trendcoeff = trendcoeffs(1)*100;
trend = polyval(trendcoeffs,tfrac);
LM = fitlm(tfrac,GMTm);
trendcoeffsd = polyfit(tfrac,GMTd_full,1);
trendcoeffd = trendcoeffsd(1)*100;
trendd = polyval(trendcoeffsd,tfrac);

%Trend from 1998-end
years = [1998:floor(max(tfrac))];
nyears = length(years) - 1;
trind = find(tfrac >= 1998);
tmr = tfrac(trind);
GMTmr = GMTm(trind);
trendcoeffsr = polyfit(tmr,GMTmr,1);
trendcoeffr = trendcoeffsr(1)*100;
trendr = polyval(trendcoeffsr,tmr);
GMTrd = GMTd_full(trind,:);
trendcoeffsrd = polyfit(tmr,GMTrd,1);
trendcoeffrd = trendcoeffsrd(1)*100;
trendrd = polyval(trendcoeffsrd,tmr);

%hiatus trend
years = [1998:2013];
nyears = length(years);
thind = find (tfrac >= 1998 & tfrac < 2014);
tmh = tfrac(thind);
GMTmh = GMTm(thind);
trendcoeffsh = polyfit(tmh, GMTmh, 1);
trendcoeffh = trendcoeffsh(1)*100;
trendh = polyval(trendcoeffsh, tmh);
LMh = fitlm(tmh, GMTmh);
GMTdh = GMTd_full(thind,:);
trendcoeffshd = polyfit(tmh, GMTdh, 1);
trendcoeffhd = trendcoeffshd(1)*100;
trendhd = polyval(trendcoeffshd, tmh);

%20th century trend
nyears = 100;
t20ind = find(tfrac >= 1900 & tfrac< 2000);
tm20 = tfrac(t20ind);
GMT20=GMTm(t20ind,:);
trendcoeffs20 = polyfit(tm20,GMT20,1);
trendcoeff20 = trendcoeffs20(1)*100;
trend20 = polyval(trendcoeffs20,tm20);
LM20 = fitlm(tm20, GMT20);

%1951-2000
years=[1951:2000]; ny = length(years);
t1951 = find(tfrac >= 1951 & tfrac < 2001);
tm1951 = tfrac(t1951);
GMT1951 = GMTm(t1951,:);
trendcoeffs1951 = polyfit(tm1951,GMT1951,1);
trendcoeff1951 = trendcoeffs1951(1)*100;
trend1951 = polyval(trendcoeffs1951,tm1951);
LM1951 = fitlm(tm1951, GMT1951);

% common
years = [1880:2017];
nyears = length(years);
tcom = find(tfrac >=1880 & tfrac < 2018);
tmcom = tfrac(tcom);
GMTcom = GMTm(tcom,:);
trendcoeffscom = polyfit(tmcom, GMTcom, 1);
trendcoeffcom = trendcoeffscom(1)*100;
trendcom = polyval(trendcoeffscom,tmcom);
LMcom = fitlm(tmcom, GMTcom);

%Assign to structure and save
NOAA_GMT.tv = dv;
NOAA_GMT.tmdn = tmdn;
NOAA_GMT.tmfrac = tfrac;
NOAA_GMT.tmr = tmr;
NOAA_GMT.tm20 = tm20;
NOAA_GMT.tm1951 = tm1951;
NOAA_GMT.ta_yr = years;
NOAA_GMT.td_yr = years;
NOAA_GMT.td_full = tfrac;
NOAA_GMT.GMTm = GMTm;
NOAA_GMT.GMTa_yr = GMTa_yr;
NOAA_GMT.GMTd_yr = GMTd_yr;
NOAA_GMT.GMTd_full = GMTd_full;
NOAA_GMT.trendcoeffs = trendcoeffs;
NOAA_GMT.trendcoeffsd = trendcoeffsd;
NOAA_GMT.trendcoeffsr = trendcoeffsr;
NOAA_GMT.trendcoeffsrd = trendcoeffsrd;
NOAA_GMT.trendcoeffs20 = trendcoeffs20;
NOAA_GMT.trendcoeffs1951 = trendcoeffs1951;
NOAA_GMT.trendcoeffsh = trendcoeffsh;
NOAA_GMT.trendcoeffshd = trendcoeffshd;
NOAA_GMT.trendcoeffscom = trendcoeffscom;
NOAA_GMT.trendcoeff = trendcoeff;
NOAA_GMT.trendcoeffd = trendcoeffd;
NOAA_GMT.trendcoeffr = trendcoeffr;
NOAA_GMT.trendcoeffrd = trendcoeffrd;
NOAA_GMT.trendcoeff20 = trendcoeff20;
NOAA_GMT.trendcoeff1951 = trendcoeff1951;
NOAA_GMT.trendcoeffh = trendcoeffh;
NOAA_GMT.trendcoeffhd = trendcoeffhd;
NOAA_GMT.trendcoeffcom = trendcoeffcom;
NOAA_GMT.trend = trend;
NOAA_GMT.trendd = trendd;
NOAA_GMT.trendr = trendr;
NOAA_GMT.trendrd = trendrd;
NOAA_GMT.trend20 = trend20;
NOAA_GMT.trend1951 = trend1951;
NOAA_GMT.trendh = trendh;
NOAA_GMT.trendhd = trendhd;
NOAA_GMT.trendcom = trendcom;
NOAA_GMT.LM = LM;
NOAA_GMT.LMh = LMh;
NOAA_GMT.LM20 = LM20;
NOAA_GMT.LM1951 = LM1951;
NOAA_GMT.LMcom = LMcom;



odir = '/home/geovault-02/avaccaro/hadCRUT4.6/NOAA_GMT/data/';
outname = 'NOAA_GMT_EXP.mat';
outpath = [odir outname];

save(outpath, 'NOAA_GMT')



