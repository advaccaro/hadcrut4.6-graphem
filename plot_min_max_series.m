%plot_min_max_timeseries.m
% Find min and max temperatures for each dataset and plot a line plot.

%% Set Up
% clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

sparsities = [10:5:80];
n = length(sparsities);
minimums = zeros(1,n);
maximums = zeros(1,n);
abs_maximums = zeros(1,n);

for k = 1:length(sparsities)
	datapath = ['./data/had46med_full_sp' num2str(sparsities(k)) '_merra_krig.mat'];
	load(datapath)
	minimums(k) = 0-min(min(SP1.X));
	maximums(k) = max(max(SP1.X));
	abs_maximums(k) =  max(max(abs(SP1.X)));
end

fig('Min, Max, Abs Max Plot'); clf;
plot(sparsities, minimums, 'b', 'LineWidth', 1.5);
hold on;
plot(sparsities, maximums, 'r', 'LineWidth', 1.5);
plot(sparsities, abs_maximums, 'g', 'LineWidth', 1.5);

%% Raw HadCRUT
load('had46med.mat');
%raw = rawH46med(~isnan(rawH46med));
raw_min = 0-min(min(rawH46med));
raw_max = max(max(rawH46med));
raw_abs = max(max(abs(rawH46med)));

%plot(sparsities, repmat(raw_min, [1 length(sparsities)]), 'r--', 'LineWidth', 1.5);
%plot(sparsities, repmat(raw_max, [1 length(sparsities)]), 'g--', 'LineWidth', 1.5);
plot(sparsities, repmat(raw_abs, [1 length(sparsities)]), 'k-', 'LineWidth', 3);

%% Neighborhood graph
load('had46med_full_cr1000_merra_krig.mat');
n_min = 0-min(min(CR.X));
n_max = max(max(CR.X));
n_abs = max(max(abs(CR.X)));

%plot(sparsities, repmat(n_min, [1 length(sparsities)]), 'r:', 'LineWidth', 1.5);
%plot(sparsities, repmat(n_max, [1 length(sparsities)]), 'g:', 'LineWidth', 1.5);
plot(sparsities, repmat(n_abs, [1 length(sparsities)]), 'c--', 'LineWidth', 1.5);

%% Add legend, set y limits, and add axis labels
legend('-Minimum', 'Maximum', 'Absolute maximum', 'Raw: Absolute maximum', '1000km neighborhood: Absolute maximum');
ylim([0,60]);
xlabel('Target sparsity (%)');
ylabel('Temperature anomaly (\circC)');
legend('boxoff')


%% Save figure
otag = './figs/min_max_series.jpeg';
print(otag, '-djpeg', '-cmyk', '-r500')

