%cci_plot_cvscores_all.m
% directories
data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
fig_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/figs/';

% Target sparsities
sparsities = .5:.1:1;
nspars = length(sparsities);

% initialize arrays
epes = zeros(1, nspars);
siggs = zeros(1,nspars);
null_epe = zeros(1,nspars);
null_sigg = zeros(1,nspars);
cr_epe = zeros(1,nspars);
cr_sigg = zeros(1,nspars);


% sparsities
for i = 1:nspars
	target_spars = sparsities(i);
	% load CV scores
	CVtag = ['cci_combined_sp' num2str(target_spars*100) '_CVscores_all.mat'];
	CVpath = [data_dir CVtag];
	a = load(CVpath);
	epes(i) = a.epe;
	siggs(i) = a.sigg;
	clear a
end

% prepare null and neighborhood graph
nulltag = 'cci_combined_null_CVscores.mat';
nullpath = [data_dir nulltag];
n = load(nullpath);
null_epe = null_epe + n.epe;
null_sigg = null_sigg + n.sigg;


neightag = 'cci_combined_cr_CVscores.mat';
neighpath = [data_dir neightag];
cr = load(neighpath);
cr_epe = cr_epe + cr.epe;
cr_sigg = cr_sigg + cr.sigg;


%% plotting
fig('CCI CV scores'); clf;
hold on;
p1 = plot(sparsities, epes, 'ko-');
plot(sparsities, epes-siggs, 'k--')
plot(sparsities, epes+siggs, 'k--')

% neigh graph
p2 = plot(sparsities, cr_epe, 'b');
plot(sparsities, cr_epe-cr_sigg, 'b--');
plot(sparsities, cr_epe+cr_sigg, 'b--');

% % null reconstruction
% p3 = plot(sparsities, null_epe, 'r');
% plot(sparsities, null_epe-null_sigg, 'r--')
% plot(sparsities, null_epe+null_sigg, 'r--')

xlabel('Sparsity (%)');
ylabel('Expected prediction error (K^{2})');
title('CCI comparison cross-validation scores');
[hleg,objh] = legend([p1,p2,p3], {'GLASSO', 'Neighborhood radius: 1000km'}); %, 'Null reconstruction'});
legend('boxoff')
figname = 'cci_cvscores_nonull.jpeg';
figpath = [fig_dir figname];
print(figpath, '-djpeg', '-cmyk');

