% kd_comparison.m


%% Set Up
% clear all
working_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
addpath(genpath(working_dir))

%% Raw HadCRUT4.6 median
legend_strs = cell(1,5);
legend_strs{1} = 'Raw HadCRUT4.6';
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

%% GraphEM
legend_strs{2} = 'GraphEM';
load had46med_full_sp60_merra_krig
[fs, xis] = ksdensity(SP1.X(~isnan(SP1.X)));
semilogy(xis, fs, 'LineWidth', 1.5);

%% Cowtand and Way
legend_strs{3} = 'CW14';
load cw17
[fc, xc] = ksdensity(cw17.temp2d(~isnan(cw17.temp2d)));
semilogy(xc, fc, 'LineWidth', 1.5);

%% Neighborhood Graph
legend_strs{4} = ['ST Kriging'];
load('had46med_full_cr1000_merra_krig.mat');
[fn,xin] = ksdensity(CR.X(~isnan(CR.X)));
semilogy(xin,fn, 'LineWidth', 1.5);

%% ST GAM
legend_strs{5} = 'ST GAM';
GAMX = rawH46med;
hzeros = zeros(size(GAMX));
GAMX(isnan(GAMX)) = hzeros(isnan(GAMX));
GAMX = GAMX(~isnan(GAMX));
[fg, xg] = ksdensity(GAMX);
semilogy(xg, fg, 'LineWidth', 1.5);
	

% Add legend, adjust x & y limits, add axes labels
legend(legend_strs{:});
xlim([-30, 30]);
ylim([1e-10,1]);
ylabel('Probability density');
xlabel('Temperature anomaly (\circC)');
legend('boxoff')

% Save figure
otag = './figs/kd_comparison_5x1.jpeg';
print(otag, '-djpeg', '-cmyk', '-r500')

