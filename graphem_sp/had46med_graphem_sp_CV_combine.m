%had43med_graphem_sp_CV_combine.m
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))


%Scases = [.5:.1:1.1];
%Scases = [.5,.6,.65,.7,.8,.85,.9,.95,1,1.05,1.1,1.2];
Scases = [.5,.55,.6,.65,.7,.75,.8,.85,.9,1];
%Scases = [.5,.6,.65,.7,.8,.9,.95,1];%1.05];
Ncases = length(Scases);
latBands = fliplr([-90:10:90]);
nBands = length(latBands) - 1;

%% Load CV scores
for i = 1:Ncases
	CVtag = ['H46MED_SP' num2str(Scases(i)*100) '_CVscores_v1.mat'];
	SPCV{i} = load(CVtag);
	epe(i) = SPCV{i}.epe;
	sigg(i) = SPCV{i}.sigg;
	for j = 1:nBands
		zEPE(j,i) = SPCV{i}.zonalEPE(j);
		zSigg(j,i) = SPCV{i}.zonalSigg(j);
	end
	
end

%% Plotting
fig('had46med SP CV scores'); clf
hold on;
plot(Scases,epe,'ko-')
plot(Scases,epe-sigg,'k--')
plot(Scases,epe+sigg,'k--')
xlabel('Sparsity Parameter (%)')
ylabel('Expected prediction error (Degrees^2)')
figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/figs/'
figname = 'had46med_graphem_sp_CV_scores.jpeg';
figpath = [figdir figname];
print(figpath, '-djpeg', '-cmyk')


fig('zonal SP CV scores'); clf
hold on;
plot(Scases,epe,'ko-')
plot(Scases,epe-sigg,'k--')
plot(Scases,epe+sigg,'k--')
for j = 1:length(zEPE)
	plot(Scases, zEPE(j,:));
	plot(Scases, zEPE(j,:)-zSigg(j,:));
	plot(Scases, zEPE(j,:)+zSigg(j,:));
end
legend;
xlabel('Sparsity Parameter (%)')
ylabel('Expected prediction error (Degrees^2)')
figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/figs/'
figname = 'had46med_graphem_sp_zonal_CV_scores.jpeg';
figpath = [figdir figname];
print(figpath, '-djpeg', '-cmyk')
