%cci_plot_cvscores_all.m
function cci_plot_cvscores_all(include_null)
	if ~exist('include_null', 'var')
		include_null = true;
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


	neightag = 'cci_combined_cr_CVscores.mat';
	neighpath = [data_dir neightag];
	cr = load(neighpath);
	cr_epe = cr_epe + cr.epe;
	cr_sigg = cr_sigg + cr.sigg;


	%% plotting
	fig('CCI CV scores'); clf;
	hold on;
	[AX, H1, H2] = plotyy(sparsities, epes, sparsities, null_epe);
	% hold(AX(1));
	% hold(AX(2));
	% p1 = plot(AX(1), sparsities, epes);
	% p2 = plot(AX(2), sparsities, null_epe);
	% line(sparsities, epes - siggs, '--', 'Parent', AX(1));
	line(AX(1), sparsities, epes + siggs, 'LineStyle', '--');
	% line(sparsities, epes+siggs, '--')
	p2 = line(AX(1), sparsities, cr_epe, 'Color', 'b');
	line(AX(1), sparsities, cr_epe-cr_sigg, 'Color', 'b', 'LineStyle', '--');
	line(AX(1), sparsities, cr_epe+cr_sigg, 'Color', 'b', 'LineStyle', '--');
	% [hAx2, lgl, lrl] = plotyy(sparsities, epes-siggs, sparsities, null_epe-null_sigg);
	% [hAx3, lgu, lru] = plotyy(sparsities, epes+siggs, sparsities, null_epe+null_sigg);
	%
	% % neigh graph
	%[hAx2, lc, lr = plotyy(sparsities, cr_epe, 'b');
	% lc = plot(sparsities, cr_epe, 'b');
	% plot(sparsities, cr_epe-cr_sigg, 'b--');
	% plot(sparsities, cr_epe+cr_sigg, 'b--');

	% if include_null
	% 	% % null reconstruction
	% 	[hAx3, ln] p3 = plotyy(sparsities, null_epe, 'r');
	% 	plotyy(sparsities, null_epe-null_sigg, 'r--')
	% 	plotyy(sparsities, null_epe+null_sigg, 'r--')
	% end

	xlabel('Sparsity (%)');
	ylabel('Expected prediction error (K^{2})');
	title('CCI comparison cross-validation scores');
	if include_null
		[hleg,objh] = legend([H1,p2,H2], {'GLASSO', 'Neighborhood radius: 1000km', 'Null reconstruction'});
	else
		[hleg,objh] = legend([p1,p2], {'GLASSO', 'Neighborhood radius: 1000km'});
	end

	legend('boxoff')
	if include_null
		figname = 'cci_cvscores_yy.jpeg';
	else
		figname = 'cci_cvscores_nonull_yy.jpeg';
	end
	figpath = [fig_dir figname];
	print(figpath, '-djpeg', '-cmyk');
	close all;
end
