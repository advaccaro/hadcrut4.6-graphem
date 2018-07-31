%make_nino_table.m

%% Initialize
addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))
load_nino_datasets

HR = H46MED_EXP;
HG = H46M80_EXP;
B = BUNGE_NINO;
C = COBE_NINO;
E = ERSSTv5_NINO;
K = Kext_NINO;
CW = C46MED_EXP;


% Preallocate arrays (columns)
name = cell(6,1); period = cell(6,1);
rho_m = NaN(6,1); rho_msig = NaN(6,1); rho_m_cell = cell(6,1);
rho_a_djf = NaN(6,1); rho_a_djfsig = NaN(6,1); rho_a_djf_cell = cell(6,1);
rho_a_yr = NaN(6,1); rho_a_yrsig = NaN(6,1); rho_a_yr_cell = cell(6,1);
rho_d_djf = NaN(6,1); rho_a_djfsig = NaN(6,1); rho_a_djf_cell = cell(6,1);
rho_d_full = NaN(6,1); rho_d_fullsig = NaN(6,1); rho_d_full_cell = cell(6,1);

n=0;

%% HadCRUT4.3 raw
n=n+1; 
X = HR;
name{n} = '$HadCRUT4.6_{raw}$';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
[rho_m(n), rho_msig(n)] = series_corr(X.tmfrac,X.NINO34m,HG.tmfrac,HG.NINO34m);
[rho_a_djf(n), rho_a_djfsig(n)] = series_corr(X.ta_djf,X.NINO34a_djf,HG.ta_djf,HG.NINO34a_djf);
[rho_a_yr(n), rho_a_yrsig(n)] = series_corr(X.ta_yr,X.NINO34a_yr,HG.ta_yr,HG.NINO34a_yr);
[rho_d_djf(n),rho_d_djfsig(n)] = series_corr(X.td_djf,X.NINO34d_djf,HG.td_djf,HG.NINO34d_djf);
[rho_d_full(n), rho_d_fullsig(n)] = series_corr(X.tmfrac,X.NINO34d_full,HG.tmfrac,HG.NINO34d_full);

clear time1 mon1 year1 timef monf yearf X

%% Cowtan & Way
n=n+1; 
X = CW;
name{n} = '$HadCRUT4.6_{CW}$';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
[rho_m(n), rho_msig(n)] = series_corr(X.tmfrac,X.NINO34m,HG.tmfrac,HG.NINO34m);
[rho_a_djf(n), rho_a_djfsig(n)] = series_corr(X.ta_djf,X.NINO34a_djf,HG.ta_djf,HG.NINO34a_djf);
[rho_a_yr(n), rho_a_yrsig(n)] = series_corr(X.ta_yr,X.NINO34a_yr,HG.ta_yr,HG.NINO34a_yr);
[rho_d_djf(n),rho_d_djfsig(n)] = series_corr(X.td_djf,X.NINO34d_djf,HG.td_djf,HG.NINO34d_djf);
[rho_d_full(n), rho_d_fullsig(n)] = series_corr(X.tmfrac,X.NINO34d_full,HG.tmfrac,HG.NINO34d_full);

clear time1 mon1 year1 timef monf yearf X

n=n+1; 
X = C;
name{n} = 'COBE SST';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
[rho_m(n), rho_msig(n)] = series_corr(X.tmfrac,X.NINO34m,HG.tmfrac,HG.NINO34m);
[rho_a_djf(n), rho_a_djfsig(n)] = series_corr(X.ta_djf,X.NINO34a_djf,HG.ta_djf,HG.NINO34a_djf);
[rho_a_yr(n), rho_a_yrsig(n)] = series_corr(X.ta_yr,X.NINO34a_yr,HG.ta_yr,HG.NINO34a_yr);
[rho_d_djf(n),rho_d_djfsig(n)] = series_corr(X.td_djf,X.NINO34d_djf,HG.td_djf,HG.NINO34d_djf);
[rho_d_full(n), rho_d_fullsig(n)] = series_corr(X.tmfrac,X.NINO34d_full,HG.tmfrac,HG.NINO34d_full);

clear time1 mon1 year1 timef monf yearf X

n=n+1; 
X = B;
name{n} = 'Bunge \& Clark';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
[rho_m(n), rho_msig(n)] = series_corr(X.tmfrac,X.NINO34m,HG.tmfrac,HG.NINO34m);
[rho_a_djf(n), rho_a_djfsig(n)] = series_corr(X.ta_djf,X.NINO34a_djf,HG.ta_djf,HG.NINO34a_djf);
[rho_a_yr(n), rho_a_yrsig(n)] = series_corr(X.ta_yr,X.NINO34a_yr,HG.ta_yr,HG.NINO34a_yr);
[rho_d_djf(n),rho_d_djfsig(n)] = series_corr(X.td_djf,X.NINO34d_djf,HG.td_djf,HG.NINO34d_djf);
[rho_d_full(n), rho_d_fullsig(n)] = series_corr(X.tmfrac,X.NINO34d_full,HG.tmfrac,HG.NINO34d_full);

clear time1 mon1 year1 timef monf yearf X


n=n+1; 
X = E;
name{n} = 'ERSSTv5';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
[rho_m(n), rho_msig(n)] = series_corr(X.tmfrac,X.NINO34m,HG.tmfrac,HG.NINO34m);
[rho_a_djf(n), rho_a_djfsig(n)] = series_corr(X.ta_djf,X.NINO34a_djf,HG.ta_djf,HG.NINO34a_djf);
[rho_a_yr(n), rho_a_yrsig(n)] = series_corr(X.ta_yr,X.NINO34a_yr,HG.ta_yr,HG.NINO34a_yr);
[rho_d_djf(n),rho_d_djfsig(n)] = series_corr(X.td_djf,X.NINO34d_djf,HG.td_djf,HG.NINO34d_djf);
[rho_d_full(n), rho_d_fullsig(n)] = series_corr(X.tmfrac,X.NINO34d_full,HG.tmfrac,HG.NINO34d_full);

clear time1 mon1 year1 timef monf yearf X

n=n+1; 
X = K;
name{n} = 'Kaplan extended';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
[rho_m(n), rho_msig(n)] = series_corr(X.tmfrac,X.NINO34m,HG.tmfrac,HG.NINO34m);
[rho_a_djf(n), rho_a_djfsig(n)] = series_corr(X.ta_djf,X.NINO34a_djf,HG.ta_djf,HG.NINO34a_djf);
[rho_a_yr(n), rho_a_yrsig(n)] = series_corr(X.ta_yr,X.NINO34a_yr,HG.ta_yr,HG.NINO34a_yr);
[rho_d_djf(n),rho_d_djfsig(n)] = series_corr(X.td_djf,X.NINO34d_djf,HG.td_djf,HG.NINO34d_djf);
[rho_d_full(n), rho_d_fullsig(n)] = series_corr(X.tmfrac,X.NINO34d_full,HG.tmfrac,HG.NINO34d_full);

clear time1 mon1 year1 timef monf yearf X



for i = 1:n
	rho_m_cell{i} = ['\textbf{',num2str(rho_m(i),'%+3.2f'),'}'];
	rho_a_djf_cell{i} = ['\textbf{',num2str(rho_a_djf(i),'%+3.2f'),'}'];
	rho_a_yr_cell{i} = ['\textbf{',num2str(rho_a_yr(i),'%+3.2f'),'}'];
	rho_d_djf_cell{i} = ['\textbf{',num2str(rho_d_djf(i),'%+3.2f'),'}'];
	rho_d_full_cell{i} = ['\textbf{',num2str(rho_d_full(i),'%+3.2f'),'}'];
end

M = [name period rho_m_cell rho_a_yr_cell rho_d_full_cell rho_a_djf_cell rho_d_djf_cell'];
cLabels = {'Dataset', 'Period', '$\rho(N3.4m)$', '$\rho(N3.4a_{yr})$', '$\rho(N3.4d_{yr})$', '$\rho(N3.4a_{djf})$', '$\rho(N3.4d_{djf})$'};
latextable(M,'Horiz',cLabels,'name','nino_db_table_input.tex','Hline',[1]);


