% kd_comparison.m


%% Set Up
% clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

%% Raw HadCRUT4.6 median
load had46med.mat %HadCRUT4.6 Raw
raw = rawH46med(~isnan(rawH46med));
pts = linspace(-80,.1,80);
[f,xi] = ksdensity(raw);
%[f1,xi1] = ksdensity(raw,pts,'Support','positive');
%% Plotting
fig('kernel density comparison'); clf;
%plot(xi, f,  'r', 'LineWidth', 2.5); 
semilogy(xi, f, 'r', 'LineWidth', 2.5);
hold on;


%% Target sparsities
sparsities = [40:10:80];
n = length(sparsities);
legend_strs = cell(1,n+2);
legend_strs{1} = 'Raw HadCRUT4.6';

for k = 1:n	datapath = ['./data/had46med_full_sp' num2str(sparsities(k)) '_merra_krig.mat'];
	datapath
	load(datapath)
	[fs,xis] = ksdensity(SP1.X(~isnan(SP1.X)));
	%plot(xis, fs, 'LineWidth', 1.5);
	semilogy(xis, fs, 'LineWidth', 1.5);
	legend_strs{k+1} = ['Target sparsity: ' num2str(sparsities(k)/100) '%'];
end

%% Neighborhood Graph
load('had46med_full_cr1000_merra_krig.mat');
[fn,xin] = ksdensity(CR.X(~isnan(CR.X)));
semilogy(xin,fn, 'LineWidth', 1.5);
legend_strs{k+2} = ['Neighborhood radius: 1000km'];

	

% Add legend, adjust x & y limits, add axes labels
legend(legend_strs{:});
xlim([-30, 30]);
ylim([1e-8,1]);
ylabel('Probability density');
xlabel('Temperature anomaly (\circC)');
legend('boxoff')

% Save figure
otag = './figs/kd_comparison.jpeg';
print(otag, '-djpeg', '-cmyk', '-r500')

