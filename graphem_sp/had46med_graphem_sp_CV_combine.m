%had43med_graphem_sp_CV_combine.m
addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'))


%Scases = [.5:.1:1.1];
%Scases = [.5,.6,.65,.7,.8,.85,.9,.95,1,1.05,1.1,1.2];
Scases = [.5,.55,.6,.65,.7,.75,.8,.85,.9,1];
%Scases = [.5,.6,.65,.7,.8,.9,.95,1];%1.05];
Ncases = length(Scases);
latBounds = fliplr([-90:20:90]);
nBands = length(latBounds) - 1;

%% Load CV scores
for i = 1:Ncases
	CVtag = ['H46MED_SP' num2str(Scases(i)*100) '_CVscores_v2.mat'];
	SPCV{i} = load(CVtag);
	kMSE = SPCV{i}.MSE;
	EPE(i) = mean(kMSE);
	Sigg(i) = std(kMSE);
	for j = 1:nBands
		zkMSE(i,j,:) = SPCV{i}.zMSE(:,j);
		zEPE(j,i) = mean(zkMSE(i,j,:));
		zSigg(j,i) = std(zkMSE(i,j,:));
	end
	
end

for j = 1:nBands
colors{j} = [j/10 1-j/10 j/10];
end
%% Plotting
%fig('had46med SP CV MSE scores'); clf;
%hold on;
%for k = 1:length(MSE)



fig('had46med SP CV EPE scores'); clf;
hold on;
plot(Scases,EPE,'ko-')
plot(Scases,EPE-Sigg,'k--')
plot(Scases,EPE+Sigg,'k--')
xlabel('Sparsity Parameter (%)')
ylabel('Expected prediction error (Degrees^2)')
figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/figs/'
figname = 'had46med_graphem_sp_CV_scores2.jpeg';
figpath = [figdir figname];
print(figpath, '-djpeg', '-cmyk')


fig('zonal SP CV scores'); clf
hold on;
%plot(Scases,epe,'ko-')
%plot(Scases,epe-sigg,'k--')
%plot(Scases,epe+sigg,'k--')
for j = 1:nBands
	latUpper = latBounds(j);
	latLower = latBounds(j+1);
	legname = [num2str(latLower) ' to ' num2str(latUpper)];
	plot(Scases, zEPE(j,:));
	%plot(Scases, zEPE(j,:)-zSigg(j,:));
	%plot(Scases, zEPE(j,:)+zSigg(j,:));
end
%legend(hp,legname);
xlabel('Sparsity Parameter (%)')
ylabel('Expected prediction error (Degrees^2)')
figdir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/graphem_sp/figs/'
figname = 'had46med_graphem_sp_zonal_CV_scores2.jpeg';
figpath = [figdir figname];
print(figpath, '-djpeg', '-cmyk')


fig('zonal MSE'); clf;
hold on;
for k = 1:10
for j = 1:nBands
plot(Scases, zkMSE(:,j,k), 'Color', colors{j})
end
end

xlabel('Sparsity Parameter (%)')
ylabel('MSE (Degrees^2)')

fig('single fold zMSE'); clf;
hold on;
for j = 1:nBands
plot(Scases, SPCV{1}.zMSE(:,j))
end
xlabel('Sparsity Parameter (%)')
ylabel('MSE (Degrees^2)')



