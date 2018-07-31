%make_trend_table.m

addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))

load_gmt_datasets

%shorten dataset names
HR = H46MED_EXP;
HG = H46M80_EXP;
G = GISTEMP_GMT;
CW = C46MED_EXP;
N = NOAA_GMT;

nSets = 5;

%preallocate arrays (columns)
name = cell(nSets,1); period = cell(nSets,1); 
trendcom = NaN(nSets,1); trend_h = NaN(nSets,1);
trend20 = NaN(nSets,1); trend1951 = NaN(nSets,1);
trend_cell = cell(nSets,1);
trend_h_cell = cell(nSets,1);
trend20_cell = cell(nSets,1);
trend1951_cell = cell(nSets,1);


n = 0;

%% HadCRUT4.6 GraphEM
n=n+1;
X = HG;
name{n} = '$HadCRUT4.6_{GraphEM}$';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
%period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
%trendcom(n) = X.trendcoeffcom;
%trend_h(n) = X.trendcoeffh;
%trend20(n) = X.trendcoeff20;
%trend1951(n) = X.trendcoeff1951;
Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100;
Hcom = CI(2,2)*100;
trend_cell{n} = latexci3(Lcom, Mcom, Hcom);
clear CI Lcom Mcom Hcom
Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100;
Hh = CI(2,2)*100;
trend_h_cell{n} = latexci3(Lh, Mh, Hh);
clear CI Lh Mh Hh
M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100;
H20 = CI(2,2)*100;
trend20_cell{n} = latexci3(L20, M20, H20);
clear CI L20 M20 H20
M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100;
H1951 = CI(2,2)*100;
trend1951_cell{n} = latexci3(L1951, M1951, H1951);
clear CI M1951 L1951 H1951
clear X time1 timef mon1 monf 



%% HadCRUT4.3 raw
n=n+1;
X = HR;
name{n} = '$HadCRUT4.6_{raw}$';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
%period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
%trendcom(n) = X.trendcoeffcom;
%trend_h(n) = X.trendcoeffh;
%trend20(n) = X.trendcoeff20;
%trend1951(n) = X.trendcoeff1951;
Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100;
Hcom = CI(2,2)*100;
trend_cell{n} = latexci3(Lcom, Mcom, Hcom);
clear CI Lcom Mcom Hcom
Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100;
Hh = CI(2,2)*100;
trend_h_cell{n} = latexci3(Lh, Mh, Hh);
clear CI Lh Mh Hh
M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100;
H20 = CI(2,2)*100;
trend20_cell{n} = latexci3(L20, M20, H20);
clear CI L20 M20 H20
M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100;
H1951 = CI(2,2)*100;
trend1951_cell{n} = latexci3(L1951, M1951, H1951);
clear CI M1951 L1951 H1951
clear X time1 timef mon1 monf



%% HadCRUT4.3 Cowtan & Way
n=n+1;
X = CW;
name{n} = '$HadCRUT4.6_{CW}$';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
%period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
%trendcom(n) = X.trendcoeffcom;
%trend_h(n) = X.trendcoeffh;
%trend20(n) = X.trendcoeff20;
%trend1951(n) = X.trendcoeff1951;
Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100;
Hcom = CI(2,2)*100;
trend_cell{n} = latexci3(Lcom, Mcom, Hcom);
clear CI Lcom Mcom Hcom
Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100;
Hh = CI(2,2)*100;
trend_h_cell{n} = latexci3(Lh, Mh, Hh);
clear CI Lh Mh Hh
M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100;
H20 = CI(2,2)*100;
trend20_cell{n} = latexci3(L20, M20, H20);
clear CI L20 M20 H20
M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100;
H1951 = CI(2,2)*100;
trend1951_cell{n} = latexci3(L1951, M1951, H1951);
clear CI M1951 L1951 H1951
clear X time1 timef mon1 monf


%% GISTEMP
n=n+1;
X = G;
name{n} = 'GISTEMP';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
%period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
%trendcom(n) = X.trendcoeffcom;
%trend_h(n) = X.trendcoeffh;
%trend20(n) = X.trendcoeff20;
%trend1951(n) = X.trendcoeff1951;
Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100;
Hcom = CI(2,2)*100;
trend_cell{n} = latexci3(Lcom, Mcom, Hcom);
clear CI Lcom Mcom Hcom
Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100;
Hh = CI(2,2)*100;
trend_h_cell{n} = latexci3(Lh, Mh, Hh);
clear CI Lh Mh Hh
M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100;
H20 = CI(2,2)*100;
trend20_cell{n} = latexci3(L20, M20, H20);
clear CI L20 M20 H20
M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100;
H1951 = CI(2,2)*100;
trend1951_cell{n} = latexci3(L1951, M1951, H1951);
clear CI M1951 L1951 H1951
clear X time1 timef mon1 monf



%% NOAA
n=n+1;
X = N;
name{n} = 'NOAA';
time1 = datevec(min(X.tmdn));
mon1 = time1(2); year1 = time1(1);
timef = datevec(max(X.tmdn));
monf = timef(2); yearf = timef(1);
%period{n} = [num2str(mon1) '/' num2str(year1) '--' num2str(monf) '/' num2str(yearf)];
%trendcom(n) = X.trendcoeffcom;
%trend_h(n) = X.trendcoeffh;
%trend20(n) = X.trendcoeff20;
%trend1951(n) = X.trendcoeff1951;
Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100;
Hcom = CI(2,2)*100;
trend_cell{n} = latexci3(Lcom, Mcom, Hcom);
clear CI Lcom Mcom Hcom
Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100;
Hh = CI(2,2)*100;
trend_h_cell{n} = latexci3(Lh, Mh, Hh);
clear CI Lh Mh Hh
M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100;
H20 = CI(2,2)*100;
trend20_cell{n} = latexci3(L20, M20, H20);
clear CI L20 M20 H20
M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100;
H1951 = CI(2,2)*100;
trend1951_cell{n} = latexci3(L1951, M1951, H1951);
clear CI M1951 L1951 H1951
clear X time1 timef mon1 monf



%for i = 1:n
%	trend_cell{i} = num2str(trendcom(i), '%+3.3f');
%	trend_h_cell{i} = num2str(trend_h(i), '%+3.3f');
%	trend20_cell{i} = num2str(trend20(i), '%+3.3f');
%	trend1951_cell{i} = num2str(trend1951(i), '%+3.3f');
%end

%M = [name trend_cell trend_h_cell trend20_cell trend1951_cell];
cLabels = {'Dataset', 'm(1880-2017)', 'm(1998-2013)', 'm(20th century)', 'm(1951-2000)'};
%latextable(M,'Horiz',cLabels,'name','trend_db_table_input.tex','Hline',[1]);

fid = fopen('trend_db_table_input.tex', 'w');
fprintf(fid, '\\begin{tabular}{ccccc} \n');
fprintf(fid, '%s & %s & %s & %s & %s \\\\ \n', [cLabels{:}]);
fprintf(fid, '\\hline \n');
for i = 1:n
	fprintf(fid, '%s &%s &%s &%s &%s\\\\ \n', [name{i}, trend_cell{i}, trend_h_cell{i}, trend20_cell{i}, trend1951_cell{i}]);
end
fprintf(fid, '\\end{tabular}');
fclose(fid);




