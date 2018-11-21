% hist_comparison.m


%% Set Up
% clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

fig('Histogram comparison'); clf;

%% Raw HadCRUT4.6 median
load had46med.mat %HadCRUT4.6 Raw
raw = rawH46med(~isnan(rawH46med));
subplot(2,2,1);
histogram(raw);
title('Raw HadCRUT4.6 median')
set(gca, 'YScale', 'log')
ylim([1, 1e7])
xlabel('Temperature anomaly (\circC)')
ylabel('Number of grid cells')

%% Neighborhood Graph
load('had46med_full_cr1000_merra_krig.mat');
subplot(2,2,2);
histogram(CR.X);
title('GraphEM Neighborhood graph: 1000km');
set(gca, 'YScale', 'log')
ylim([1, 1e7])
xlabel('Temperature anomaly (\circC)')
ylabel('Number of grid cells')

%% GlASSO Target Sparsity 0.6%
SP60 = load('had46med_full_sp60_merra_krig.mat');
subplot(2,2,3);
histogram(SP60.SP1.X);
title('GraphEM GLASSO: 0.6% sparsity');
set(gca, 'YScale' ,'log')
ylim([1, 1e7])
xlabel('Temperature anomaly (\circC)')
ylabel('Number of grid cells')

%% GlASSO Target Sparsity 0.8%
SP80 = load('had46med_full_sp80_merra_krig.mat');
subplot(2,2,4);
histogram(SP80.SP1.X);
title('GraphEM GLASSO: 0.8% sparsity');
set(gca, 'YScale' ,'log')
ylim([1, 1e7])
xlabel('Temperature anomaly (\circC)')
ylabel('Number of grid cells')

otag = './figs/hist_comparison_log.pdf';
print(otag, '-cmyk', '-dpdf', '-bestfit');

otag2 = './figs/hist_comparison_log.jpeg';
print(otag2, '-cmyk', '-djpeg');



