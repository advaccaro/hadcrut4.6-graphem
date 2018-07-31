%GISTEMP_gmt_explore.m
addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/GISTEMP/'))

A = csvread('GLB.Ts+dSST.csv', 2,0);

years = A(:,1);
ny = length(years);

%monthly data
monthlydata = A(:,2:13);
monthlydata(monthlydata <= -999) = NaN;



%GMMT
GMMT = reshape(monthlydata.',1,numel(monthlydata));
GMMT = GMMT(:);
GMMTn = GMMT; %Keep NaNs
%Find NaN indices
nonnan = find(~isnan(GMMT)==1);
GMMT = GMMT(nonnan); %remove NaNs

%monthly time axis
for i = 1:ny
tm(1+12*(i-1)) = datenum(['15-Jan' num2str(years(i))]);
tm(2+12*(i-1)) = datenum(['15-Feb' num2str(years(i))]);
tm(3+12*(i-1)) = datenum(['15-Mar' num2str(years(i))]);
tm(4+12*(i-1)) = datenum(['15-Apr' num2str(years(i))]);
tm(5+12*(i-1)) = datenum(['15-May' num2str(years(i))]);
tm(6+12*(i-1)) = datenum(['15-Jun' num2str(years(i))]);
tm(7+12*(i-1)) = datenum(['15-Jul' num2str(years(i))]);
tm(8+12*(i-1)) = datenum(['15-Aug' num2str(years(i))]);
tm(9+12*(i-1)) = datenum(['15-Sep' num2str(years(i))]);
tm(10+12*(i-1)) = datenum(['15-Oct' num2str(years(i))]);
tm(11+12*(i-1)) = datenum(['15-Nov' num2str(years(i))]);
tm(12+12*(i-1)) = datenum(['15-Dec' num2str(years(i))]);
end
tmdn = tm(:);
tmdn = tmdn(nonnan); %Remove NaNs
tv = datevec(tmdn);
tfrac = tv(:,1) + tv(:,2)/12 - 1/12;
nt = length(tfrac);
nf = floor(nt/12);


%Annualize
for i =1:nf
	GMTa_yr(i) = nmean(GMMTn(12*(i-1)+1:12*i));
end

%Decadal smoothing
GMTd_yr = hepta_smooth(GMTa_yr,1/10);
GMTd_full = hepta_smooth(GMMT,1/120);

%Trend
years = [floor(min(tfrac)):floor(max(tfrac))];
nyears = length(years) - 1;
trendcoeffs = polyfit(tfrac,GMMT,1);
trendcoeff = trendcoeffs(1)*100;
trend = polyval(trendcoeffs,tfrac);
LM = fitlm(tfrac,GMMT);
trendcoeffsd = polyfit(tfrac,GMTd_full,1);
trendcoeffd = trendcoeffsd(1)*100;
trendd = polyval(trendcoeffsd,tfrac);

%Trend from 1998-end
years = [1998:floor(max(tfrac))];
nyears = length(years) - 1;
trind = find(tfrac >= 1998);
tmr=tfrac(trind);
GMMTr = GMMT(trind,:);
trendcoeffsr = polyfit(tmr,GMMTr,1);
trendcoeffr = trendcoeffsr(1)*100;
trendr = polyval(trendcoeffsr,tmr);
GMTrd = GMTd_full(trind,:);
trendcoeffsrd = polyfit(tmr,GMTrd/100,1);
trendcoeffrd = trendcoeffsrd(1)*100;
trendrd = polyval(trendcoeffsrd,tmr);

%hiatus trend
years = [1998:2013];
nyears = length(years);
thind = find (tfrac >= 1998 & tfrac < 2014);
tmh = tfrac(thind);
GMTmh = GMMT(thind);
trendcoeffsh = polyfit(tmh, GMTmh, 1);
trendcoeffh = trendcoeffsh(1)*100;
LMh = fitlm(tmh, GMTmh);
trendh = polyval(trendcoeffsh, tmh);
GMTdh = GMTd_full(thind,:);
trendcoeffshd = polyfit(tmh, GMTdh, 1);
trendcoeffhd = trendcoeffshd(1)*100;
trendhd = polyval(trendcoeffshd, tmh);


%20th century trend
nyears = 100;
t20ind = find(tfrac >= 1900 & tfrac< 2000);
tm20 = tfrac(t20ind);
GMT20=GMMT(t20ind,:);
trendcoeffs20 = polyfit(tm20,GMT20,1);
trendcoeff20 = trendcoeffs20(1)*100;
trend20 = polyval(trendcoeffs20,tm20);
LM20 = fitlm(tm20, GMT20);

%1951-2000
years=[1951:2000]; ny = length(years);
t1951 = find(tfrac >= 1951 & tfrac < 2001);
tm1951 = tfrac(t1951);
GMT1951 = GMMT(t1951,:);
trendcoeffs1951 = polyfit(tm1951,GMT1951,1);
trendcoeff1951 = trendcoeffs1951(1)*100;
trend1951 = polyval(trendcoeffs1951,tm1951);
LM1951 = fitlm(tm1951, GMT1951);

% common
years = [1880:2017];
nyears = length(years);
tcom = find(tfrac >=1880 & tfrac < 2018);
tmcom = tfrac(tcom);
GMTcom = GMMT(tcom,:);
trendcoeffscom = polyfit(tmcom, GMTcom, 1);
trendcoeffcom = trendcoeffscom(1)*100;
trendcom = polyval(trendcoeffscom,tmcom);
LMcom = fitlm(tmcom, GMTcom);

%Assign to structure and save
GISTEMP_GMT.tm = tv;
GISTEMP_GMT.tmdn = tmdn;
GISTEMP_GMT.tmfrac = tfrac;
GISTEMP_GMT.tmr = tmr;
GISTEMP_GMT.tm20 = tm20;
GISTEMP_GMT.tm1951 = tm1951;
GISTEMP_GMT.ta_yr = years;
GISTEMP_GMT.td_yr = years;
GISTEMP_GMT.td_full = tfrac;
GISTEMP_GMT.GMTm = GMMT;
GISTEMP_GMT.GMTa_yr = GMTa_yr;
GISTEMP_GMT.GMTd_yr = GMTd_yr;
GISTEMP_GMT.GMTd_full = GMTd_full;
GISTEMP_GMT.trendcoeffs = trendcoeffs;
GISTEMP_GMT.trendcoeffsd = trendcoeffsd;
GISTEMP_GMT.trendcoeffsr = trendcoeffsr;
GISTEMP_GMT.trendcoeffsrd = trendcoeffsrd;
GISTEMP_GMT.trendcoeffs20 = trendcoeffs20;
GISTEMP_GMT.trendcoeffs1951 = trendcoeffs1951;
GISTEMP_GMT.trendcoeffsh = trendcoeffshd;
GISTEMP_GMT.trendcoeffshd = trendcoeffshd;
GISTEMP_GMT.trendcoeffscom = trendcoeffscom;
GISTEMP_GMT.trendcoeff = trendcoeff;
GISTEMP_GMT.trendcoeffd = trendcoeffd;
GISTEMP_GMT.trendcoeffr = trendcoeffr;
GISTEMP_GMT.trendcoeffrd = trendcoeffrd;
GISTEMP_GMT.trendcoeff20 = trendcoeff20;
GISTEMP_GMT.trendcoeff1951 = trendcoeff1951;
GISTEMP_GMT.trendcoeffh = trendcoeffhd;
GISTEMP_GMT.trendcoeffhd = trendcoeffhd;
GISTEMP_GMT.trendcoeffcom = trendcoeffcom;
GISTEMP_GMT.trend = trend;
GISTEMP_GMT.trendd = trendd;
GISTEMP_GMT.trendr = trendr;
GISTEMP_GMT.trendrd = trendrd;
GISTEMP_GMT.trend20 = trend20;
GISTEMP_GMT.trend1951 = trend1951;
GISTEMP_GMT.trendh = trendh;
GISTEMP_GMT.trendhd = trendhd;
GISTEMP_GMT.trendcom = trendcom;
GISTEMP_GMT.LM = LM;
GISTEMP_GMT.LMh = LMh;
GISTEMP_GMT.LM20 = LM20;
GISTEMP_GMT.LM1951 = LM1951;
GISTEMP_GMT.LMcom = LMcom;

odir = '/home/geovault-02/avaccaro/hadCRUT4.6/GISTEMP/data/';
outname = 'GISTEMP_GMT.mat';
outpath = [odir outname];

save(outpath, 'GISTEMP_GMT')

