% plot_extreme_anomaly_time_distribution.m

%% Set Up
% clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

thresh = 15;

%% Raw HadCRUT4.6 median
load had46med.mat %HadCRUT4.6 Raw
raw_counts = count_anoms(rawH46med, thresh);
legend_strs{1} = 'Raw HadCRUT4.6 median';

%% Neighborhood Graph
load('had46med_full_cr1000_merra_krig.mat');
neigh_counts = count_anoms(CR.X, thresh);
legend_strs{2} = 'GraphEM neighborhood: 1000km';


%% GlASSO Target Sparsity 0.6%
SP60 = load('had46med_full_sp60_merra_krig.mat');
sp60_counts = count_anoms(SP60.SP1.X, thresh);
legend_strs{3} = 'GraphEM GLASSO: 0.6% sparsity';


%% GlASSO Target Sparsity 0.8%
SP80 = load('had46med_full_sp80_merra_krig.mat');
sp80_counts = count_anoms(SP80.SP1.X, thresh);
legend_strs{4} = 'GraphEM GLASSO: 0.8% sparsity';


%% Plotting prep
%tfrac = flipud(H46med.tfrac);
tfrac = H46med.tfrac;
xlab = 'Date';
ylab = 'Number of absolute anomalies greater than 15\circC';

%% Plotting
fig('Extreme anomaly temporal distribution'); clf;
hold on;
plot(tfrac, raw_counts, 'k', 'LineWidth', 3.5)
plot(tfrac, neigh_counts, 'r', 'LineWidth', 1.5)
plot(tfrac, sp60_counts, 'LineWidth', 1.5) 
plot(tfrac, sp80_counts)
xlabel(xlab)
ylabel(ylab)
xlim([1850, 2020]);
title('Number of extreme temperature anomalies over time')
legend(legend_strs{:})
legend('boxoff')

%% Print fig
otag = './figs/extreme_anomalies_temporal_dist.jpeg';
print(otag, '-cmyk', '-djpeg');

function counts = count_anoms(array2d, thresh)
% Counts extreme temperature anomalies
	array_abs = abs(array2d);
	counts = sum(array_abs >= thresh, 2);
end
	
	
