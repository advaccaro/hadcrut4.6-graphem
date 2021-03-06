%cci_plot_cvscores_all.m
function cci_plot_cvscores_all(include_null)
	if ~exist('include_null', 'var')
		include_null = false;
	end
	% directories
	data_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/data/';
	fig_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI/figs/';

	% Target sparsities
	sparsities = [.5:.1:.8,.85:.05:1,1.1,1.2];
	nspars = length(sparsities);

	% initialize arrays
	epes = zeros(1, nspars);
	siggs = zeros(1,nspars);
	null_epe = zeros(1,nspars);
	null_sigg = zeros(1,nspars);
	cr_epe = zeros(1,nspars);
	cr_sigg = zeros(1,nspars);
	krig_epe = zeros(1,nspars);
	krig_sigg = zeros(1,nspars);


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
	if include_null
		nulltag = 'cci_combined_null_CVscores.mat';
		nullpath = [data_dir nulltag];
		n = load(nullpath);
		null_epe = null_epe + n.epe;
		null_sigg = null_sigg + n.sigg;
	end

	% prepare neighborhood graph
	neightag = 'cci_combined_cr_CVscores.mat';
	neighpath = [data_dir neightag];
	cr = load(neighpath);
	cr_epe = cr_epe + cr.epe;
	cr_sigg = cr_sigg + cr.sigg;

	% prepare kriging
	krigtag = 'cci_combined_krig800_CVscores.mat';
	krigpath = [data_dir krigtag];
	krig = load(krigpath);
	krig_epe = krig_epe + krig.epe;
	krig_sigg = krig_sigg + krig.sigg;


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

	if include_null
		% % null reconstruction
		p3 = plot(sparsities, null_epe, 'r');
		plot(sparsities, null_epe-null_sigg, 'r--')
		plot(sparsities, null_epe+null_sigg, 'r--')
	end

	% kriging
	p4 = plot(sparsities, krig_epe, 'g');
	plot(sparsities, krig_epe-krig_sigg, 'g--')
	plot(sparsities, krig_epe+krig_sigg, 'g--')

	xlabel('Sparsity (%)');
	ylabel('Expected prediction error (K^{2})');
	title('CCI comparison cross-validation scores');
	if include_null
		[hleg,objh] = legend([p1,p2,p3], {'GLASSO', 'Neighborhood radius: 1000km', 'Null reconstruction', 'Kriging'});
	else
		[hleg,objh] = legend([p1,p2,p4], {'GLASSO', 'Neighborhood radius: 1000km', 'Kriging'});
	end

	legend('boxoff')
	if include_null
		figname = 'cci_cvscores.jpeg';
	else
		figname = 'cci_cvscores_nonull.jpeg';
	end
	figpath = [fig_dir figname];
	print(figpath, '-djpeg', '-cmyk');
	close all;
end
