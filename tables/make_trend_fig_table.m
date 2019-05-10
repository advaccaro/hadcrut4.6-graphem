%make_trend_fig_table.m
%USC Climate Dynamics Lab - Summer 2018
%Author: Adam Vaccaro
%Purpose: Plot estimated linear warming trends for various datasets 
% along with their 95% confidence intervals over different time periods.



addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))

load_gmt_datasets
load JEG_graphics

%shorten dataset names
HR = H46MED_EXP;
HG = H46M60_EXP;
G = GISTEMP_GMT;
CW = C46MED_EXP;
N = NOAA_GMT;

nSets = 5;

%preallocate arrays (columns)
name = cell(nSets,1);
colors = cell(nSets, 1); 
period = cell(nSets,1); 
trendcom = NaN(nSets,1);  CIcom = cell(nSets,2);
trend_h = NaN(nSets,1); CIh = cell(nSets,2);
trend20 = NaN(nSets,1);  CI20 = cell(nSets,2);
trend1951 = NaN(nSets,1); CI1951 = cell(nSets,2);

n = 0; %initialize counter

%% HadCRUT4.6 GraphEM
n=n+1;
X = HG;
name{n} = 'HadCRUT4.6_{GraphEM}';
colors{n} = 'k';

Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100; CIcom{n,1} = Lcom;
Hcom = CI(2,2)*100; CIcom{n,2} = Hcom;
trendcom(n) = Mcom;
clear CI Lcom Mcom Hcom

Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100; CIh{n,1} = Lh;
Hh = CI(2,2)*100; CIh{n,2} = Hh;
trend_h(n) = Mh;
clear CI Lh Mh Hh

M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100; CI20{n,1} = L20;
H20 = CI(2,2)*100; CI20{n,2} = H20;
trend20(n) = M20;
clear CI L20 M20 H20

M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100; CI1951{n,1} = L1951;
H1951 = CI(2,2)*100; CI1951{n,2} = H1951;
trend1951(n) = M1951;
clear CI M1951 L1951 H1951

%% HadCRUT4.3 raw
n=n+1;
X = HR;
name{n} = 'HadCRUT4.6_{raw}';
colors{n} = rgb('ForestGreen');

Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100; CIcom{n,1} = Lcom;
Hcom = CI(2,2)*100; CIcom{n,2} = Hcom;
trendcom(n) = Mcom;
clear CI Lcom Mcom Hcom

Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100; CIh{n,1} = Lh;
Hh = CI(2,2)*100; CIh{n,2} = Hh;
trend_h(n) = Mh;
clear CI Lh Mh Hh

M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100; CI20{n,1} = L20;
H20 = CI(2,2)*100; CI20{n,2} = H20;
trend20(n) = M20;
clear CI L20 M20 H20

M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100; CI1951{n,1} = L1951;
H1951 = CI(2,2)*100; CI1951{n,2} = H1951;
trend1951(n) = M1951;
clear CI M1951 L1951 H1951

%% HadCRUT4.3 Cowtan & Way
n=n+1;
X = CW;
name{n} = 'HadCRUT4.6_{CW}';
colors{n} = 'r';

Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100; CIcom{n,1} = Lcom;
Hcom = CI(2,2)*100; CIcom{n,2} = Hcom;
trendcom(n) = Mcom;
clear CI Lcom Mcom Hcom

Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100; CIh{n,1} = Lh;
Hh = CI(2,2)*100; CIh{n,2} = Hh;
trend_h(n) = Mh;
clear CI Lh Mh Hh

M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100; CI20{n,1} = L20;
H20 = CI(2,2)*100; CI20{n,2} = H20;
trend20(n) = M20;
clear CI L20 M20 H20

M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100; CI1951{n,1} = L1951;
H1951 = CI(2,2)*100; CI1951{n,2} = H1951;
trend1951(n) = M1951;
clear CI M1951 L1951 H1951

%% GISTEMP
n=n+1;
X = G;
name{n} = 'GISTEMP';
colors{n} = ornj;

Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100; CIcom{n,1} = Lcom;
Hcom = CI(2,2)*100; CIcom{n,2} = Hcom;
trendcom(n) = Mcom;

clear CI Lcom Mcom Hcom
Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100; CIh{n,1} = Lh;
Hh = CI(2,2)*100; CIh{n,2} = Hh;
trend_h(n) = Mh;

clear CI Lh Mh Hh
M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100; CI20{n,1} = L20;
H20 = CI(2,2)*100; CI20{n,2} = H20;
trend20(n) = M20;
clear CI L20 M20 H20

M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100; CI1951{n,1} = L1951;
H1951 = CI(2,2)*100; CI1951{n,2} = H1951;
trend1951(n) = M1951;
clear CI M1951 L1951 H1951



%% NOAA
n=n+1;
X = N;
name{n} = 'NOAA';
colors{n} = maroon;

Mcom = X.LMcom.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMcom);
Lcom = CI(2,1)*100; CIcom{n,1} = Lcom;
Hcom = CI(2,2)*100; CIcom{n,2} = Hcom;
trendcom(n) = Mcom;
clear CI Lcom Mcom Hcom

Mh = X.LMh.Coefficients.Estimate(2)*100;
CI = coefCI(X.LMh);
Lh = CI(2,1)*100; CIh{n,1} = Lh;
Hh = CI(2,2)*100; CIh{n,2} = Hh;
trend_h(n) = Mh;
clear CI Lh Mh Hh

M20 = X.LM20.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM20);
L20 = CI(2,1)*100; CI20{n,1} = L20;
H20 = CI(2,2)*100; CI20{n,2} = H20;
trend20(n) = M20;
clear CI L20 M20 H20

M1951 = X.LM1951.Coefficients.Estimate(2)*100;
CI = coefCI(X.LM1951);
L1951 = CI(2,1)*100; CI1951{n,1} = L1951;
H1951 = CI(2,2)*100; CI1951{n,2} = H1951;
trend1951(n) = M1951;
clear CI M1951 L1951 H1951

% Prepare for subplotting
Titles = {'1998-2013', '1951-2000', '20th century', '1880-2017'};
nTrends = 4;
trends = cell(nTrends,1); CIs = cell(nTrends,1);
trends{1} = trend_h; CIs{1} = CIh;
trends{2} = trend1951; CIs{2} = CI1951;
trends{3} = trend20; CIs{3} = CI20;
trends{4} = trendcom;  CIs{4} = CIcom;

lines = cell(nTrends, 1);
xlabel_str = ['{\Delta}T (' char(176) 'C/century)'];
fig('Trend table fig'); clf;
for ii = 1:nTrends
	subplot(1,nTrends+1,ii+1); hold on;
	for j = 1:nSets
		y = (6-j)/10;
		lines{j} = plot([CIs{ii}{j,:}], [y y], 'DisplayName', name{j}, 'color', colors{j}, 'LineWidth', 1.5);
		scatter(trends{ii}(j),y, [], colors{j}, 'filled');
	end
	ax = gca;
	ax.YAxis.Visible = 'off';
	title(Titles{ii});
	xlim([0.15 1.45]);
	%xlabel(xlabel_str);
	ylim([0.05 .6]);
end
%[ax,h1] = suplabel(xlabel_str);
hold off;
subplot(1,nTrends+1,1); hold on;
%legend(lines{1}, name{1}, lines{2}, name{2}, lines{3}, name{3}, lines{4}, name{4});
[hL, hObj] = legend([lines{:}], name);
hL.FontSize = 18; 
hT = findobj(hObj, 'type', 'line');
set(hT, 'linewidth', 2);
%legend boxoff
%newPosition = [0.1128 0.0986 0.2745 0.800]; %[0.0850 0.1029 0.2000 0.8800]; %[0.05 0.6 0.2 0.15];
newPosition = [0.0210 0.1745 0.3605 0.6500];
newUnits = 'normalized';
set(hL, 'Position', newPosition, 'Units', newUnits);
axis off
hold off

pause;

set(hL, 'color','none');
set(hL, 'Box', 'off');

%suplabel(xlabel_str);

%save/print
odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/figs/';
figname = 'gmt_trend_plot_zoom_sp60.pdf';
figpath = [odir figname];
%hepta_figprint(figpath)
print(figpath, '-cmyk', '-dpdf', '-bestfit')


