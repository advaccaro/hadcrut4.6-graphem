function pseudoworlds_plot_cvscores(worldtype)
	% if worldtype ~= 'lsat' or worldtype ~= 'sst'
	if ~strcmp(worldtype, 'sst') & ~strcmp(worldtype,'lsat')
		worldtype = 'sst';
	end
	% SBATCH worldnum --> run_pseudoworld_sp_CV(worlnum)

	% run -> pseudoworld_graphem_sp_CV(mat, lsat/sst, worldnum, Scases, 10)
	home_dir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/';
	fig_dir = [home_dir 'pseudo_world/figs'];

	addpath(genpath(home_dir))

	%% load raw data
	if strcmp(worldtype, 'sst')
		load('pseudoworld1_sst.mat'); [ntime1,nspace1] = size(PW1_sst.grid_2d);
		load('pseudoworld2_sst.mat'); [ntime2,nspace2] = size(PW2_sst.grid_2d);
		load('pseudoworld3_sst.mat'); [ntime3,nspace3] = size(PW3_sst.grid_2d);
		load('pseudoworld4_sst.mat'); [ntime4,nspace4] = size(PW4_sst.grid_2d);
		loc = PW1_sst.loc; lats = loc(:,2);
	else
		load('pseudoworld1_lsat.mat'); [ntime1,nspace1] = size(PW1_lsat.grid_2d);
		load('pseudoworld2_lsat.mat'); [ntime2,nspace2] = size(PW2_lsat.grid_2d);
		load('pseudoworld3_lsat.mat'); [ntime3,nspace3] = size(PW3_lsat.grid_2d);
		load('pseudoworld4_lsat.mat'); [ntime4,nspace4] = size(PW4_lsat.grid_2d);
		loc = PW1_lsat.loc; lats = loc(:,2);
	end

	lats1_2d = repmat(lats,[1 ntime1]); lats1_2d = lats1_2d';
	lats2_2d = repmat(lats,[1 ntime2]); lats2_2d = lats2_2d';
	lats3_2d = repmat(lats,[1 ntime3]); lats3_2d = lats3_2d';
	lats4_2d = repmat(lats,[1 ntime4]); lats4_2d = lats4_2d';

	%% load CV scores
	if strcmp(worldtype, 'sst')
		PW1_CV = load('pseudoworld1_sst_sp_CVscores_v2.mat');
		PW2_CV = load('pseudoworld2_sst_sp_CVscores_v2.mat');
		PW3_CV = load('pseudoworld3_sst_sp_CVscores_v2.mat');
		PW4_CV = load('pseudoworld4_sst_sp_CVscores_v2.mat');
	else
		PW1_CV = load('pseudoworld1_lsat_sp_CVscores_v2.mat');
		PW2_CV = load('pseudoworld2_lsat_sp_CVscores_v2.mat');
		PW3_CV = load('pseudoworld3_lsat_sp_CVscores_v2.mat');
		PW4_CV = load('pseudoworld4_lsat_sp_CVscores_v2.mat');
	end

	%calculate envelopes
	Scases1 = [PW1_CV.Scases]; Ncases1 = length(Scases1);
	Sqcases1 = [Scases1 Scases1];
	Scases2 = [PW2_CV.Scases]; Ncases2 = length(Scases2);
	Sqcases2 = [Scases2 Scases2];
	Scases3 = [PW3_CV.Scases]; Ncases3 = length(Scases3);
	Sqcases3 = [Scases3 Scases3];
	Scases4 = [PW4_CV.Scases]; Ncases4 = length(Scases4);
	Sqcases4 = [Scases4 Scases4];


	pw1top = PW1_CV.epe+PW1_CV.sigg; pw1bot = PW1_CV.epe-PW1_CV.sigg;
	pw2top = PW2_CV.epe+PW2_CV.sigg; pw2bot = PW2_CV.epe-PW2_CV.sigg;
	pw3top = PW3_CV.epe+PW3_CV.sigg; pw3bot = PW3_CV.epe-PW3_CV.sigg;
	pw4top = PW4_CV.epe+PW4_CV.sigg; pw4bot = PW4_CV.epe-PW4_CV.sigg;


	pw1v = zeros(2*Ncases1,1); pw2v = zeros(2*Ncases2,1); 
	pw3v = zeros(2*Ncases3,1); pw4v = zeros(2*Ncases4,1);

	Sverts1 = zeros(2*Ncases1,1);
	Sverts2 = zeros(2*Ncases2,1);
	Sverts3 = zeros(2*Ncases3,1);
	Sverts4 = zeros(2*Ncases4,1);

	for j = 1:Ncases1
		Sverts1(2*j) = Scases1(j);
		Sverts1(1+(2*(j-1))) = Scases1(j);
		pw1v(2*j) = pw1top(j);
		pw1v(1+2*(j-1)) = pw1bot(j);
	end

	for j = 1:Ncases2
		Sverts2(2*j) = Scases2(j);
		Sverts2(1+(2*(j-1))) = Scases2(j);
		pw2v(2*j) = pw2top(j);
		pw2v(1+2*(j-1)) = pw2bot(j);
	end

	for j = 1:Ncases3
		Sverts3(2*j) = Scases3(j);
		Sverts3(1+(2*(j-1))) = Scases3(j);
		pw3v(2*j) = pw3top(j);
		pw3v(1+2*(j-1)) = pw3bot(j);
	end

	for j =1:Ncases4
		Sverts4(2*j) = Scases4(j);
		Sverts4(1+(2*(j-1))) = Scases4(j);
		pw4v(2*j) = pw4top(j);
		pw4v(1+2*(j-1)) = pw4bot(j);
	end

	pw1y = [pw1bot, fliplr(pw1top)]; pw1y2 = [pw1y, pw1y(1)];
	pw2y = [pw2bot, fliplr(pw2top)]; pw2y2 = [pw2y, pw2y(1)];
	pw3y = [pw3bot, fliplr(pw3top)]; pw3y2 = [pw3y, pw3y(1)];
	pw4y = [pw4bot, fliplr(pw4top)]; pw4y2 = [pw4y, pw4y(1)];

	vertx1 = [Scases1, fliplr(Scases1)];
	vertxsq1 = [vertx1, vertx1(1)];
	Z1 = zeros(size(vertxsq1));

	vertx2 = [Scases2, fliplr(Scases2)];
	vertxsq2 = [vertx2, vertx2(1)];
	Z2 = zeros(size(vertxsq2));

	vertx3 = [Scases3, fliplr(Scases3)];
	vertxsq3 = [vertx3, vertx3(1)];
	Z3 = zeros(size(vertxsq3));

	vertx4 = [Scases4, fliplr(Scases4)];
	vertxsq4 = [vertx4, vertx4(1)];
	Z4 = zeros(size(vertxsq4));

	%% Plotting
	fig(['Pseudoworlds ' worldtype 'graphem sp CV scores']); clf;
	hold on;
	%envelopes
	hp1 = fill3(vertxsq1,pw1y2,Z1,'k'); hp2 = fill3(vertxsq2,pw2y2,Z2,'r');
	hp3 = fill3(vertxsq3,pw3y2,Z3,'b'); hp4 = fill3(vertxsq4,pw4y2,Z4,'g');
	alpha(hp1,.3); alpha(hp2,.3); alpha(hp3,.3); alpha(hp4,.3);
	set(hp1,'EdgeAlpha',0);
	set(hp2,'EdgeAlpha',0);
	set(hp3,'EdgeAlpha',0);
	set(hp4,'EdgeAlpha',0);

	%pseudoworld1
	h1 = plot(PW1_CV.Scases, PW1_CV.epe, 'ko-');
	%pseudoworld2
	h2 = plot(PW2_CV.Scases, PW2_CV.epe, 'ro-');
	%pseudoworld3
	h3 = plot(PW3_CV.Scases, PW3_CV.epe, 'bo-');
	%pseudoworld4
	h4 = plot(PW4_CV.Scases, PW4_CV.epe, 'go-');

	hleg = legend([h1 h2 h3 h4], {'Pseudo-world 1', 'Pseudo-world 2', 'Pseudo-world 3', 'Pseudo-world 4'});
	legend('boxoff'); 
	xlabel('Sparsity (%)');
	ylabel('Expected prediction error (K^{2})');
	title(['10-fold CV scores for choosing target sparsity (Pseudo-worlds ' upper(worldtype) ')']);

	if strcmp(worldtype, 'sst')
		figname = 'pseudoworlds_sst_cvscores.tif';
	else
		figname = 'pseudoworlds_lsat_cvscores.tif';
	end

	figpath = [fig_dir figname];
	print(figpath, '-dtiff', '-noui', '-r250')

end



