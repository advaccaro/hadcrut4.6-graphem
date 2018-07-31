%had43med_avail_map2.m
clear all

addpath(genpath('/home/geovault-02/avaccaro/hadCRUT4.6/'))


%load data sets
load('had46med.mat')
load('hadsst3nobs.mat')
load('crutem4nobs.mat')

%bar graph w/ calculations
[ntime,nstations] = size(rawH46med);

for i = 1:ntime
	navail(i,1) = sum(~isnan(HadSST3nobs.nobs2d(i,:)));
	navail(i,2) = sum(~isnan(CRUTEM4nobs.nobs2d(i,:)));
end	

fig('nobs map'); clf;
%orient landscape
subplot(3,2,5:6); hold on;
hb = bar(H46med.tfrac,navail,'stacked');
ocean_color = hb(1).FaceColor;
hb(1).EdgeColor = ocean_color;
land_color = hb(2).FaceColor;
hb(2).EdgeColor = land_color;
%hb.BarWidth = 1;
%hb.EdgeColor = dkgr;
axis([1850 2018 0 2500])
title('HadCRUT4.6 number of observations over time');
xlabel('Time (Year)'); ylabel('# observations')
set(gca,'TickDir', 'out', 'TickLength', [.02 .02]);
set(gca, 'XTick', 1850:25:2000);
set(gca, 'XMinorTick', 'on');
hL = legend('Ocean', 'Land');
set(hL, 'Location', 'NorthWest')
legend('boxoff')



%%%% combine nobs
[ntime, nloc] = size(had46med);
hnobs = HadSST3nobs.nobs;
hnobs(isnan(hnobs)) = 0;
cnobs = CRUTEM4nobs.nobs;
cnobs(isnan(cnobs)) = 0;
combined_nobs = hnobs(:,:,1:ntime) + cnobs(:,:,1:ntime);
%

%%%%%%%%%%%%%%%%%%%%%
years = [1850, 1900, 1950, 2000];
titles{1} = {'HadCRUT4.6 number of observations per month',
 'January 1850'}; 
titles{2} = 'January 1900'; 
titles{3} = 'January 1950'; 
titles{4} = 'January 2000';

%lons = loc(:,1);
%lats = loc(:,2);
lon = H46med.lon;
%nlon = length(lon);
lat = H46med.lat;
%nlat = length(lat);

cmap = cbrewer('seq', 'Purples', 14);


for k = 1:length(years)
	yearc = years(k);
	ind = find(H46med.tfrac == yearc);
	tmp = sq(combined_nobs(:,:,ind));
	subplot(3,2,k)
	m_proj('Robinson','clong',0);
	h = m_pcolor(lon ,lat, log10(tmp)');
	set(h, 'edgecolor', 'none');
	caxis([0 3.5]);
	colormap(cmap);
	m_coast('color','k');		m_grid( 'xtick',[-180:60:180],'xticklabels',[],'tickdir','out','ytick',[-90:30:90], 'yticklabels',[],'color','k', 'fontsize',10, 'linestyle', 'none');
	title(titles{k})
	ax(k) = gca;
	if k == 2 | k == 4
		ax(k).Position(1) = ax(k).Position(1) - .09;
	else
		ax(k).Position(1) = ax(k).Position(1) - .02;
	end
end
ax2_original_position = ax(2).Position;
ax4_original_position = ax(4).Position;
ax(4).Position = ax4_original_position;
cbar = colorbar;
cbar.Position(1) = cbar.Position(1) + .09;
cbar.Position(4) = cbar.Position(4)*3;
%ax4 = gca;
%original_position = ax4.Position;
%cbar = colorbar2('horiz');
%cbar.Position(4) = cbar.Position(4) * 2;
%cbar.Position(3) = cbar.Position(3)*1.5;
%cbar.Position(1) = cbar.Position(1) - .31;
%cbar.Position(2) = cbar.Position(2) - .03;
%l = [0 0.25 .5
%L = [2 5 10 25 50 100 250 500 1000 2000 4000];
%l = log10(L);
%set(cbar, 'Xtick', l, 'XTicklabel', L);

%ax4.Position = original_position;
%set(cbar,'Location','SouthWestOutside');



odir = '/home/geovault-02/avaccaro/hadCRUT4.6/figs/';
otagf = [odir 'had46med_availmap_nobs.jpeg'];
otag = [odir 'had46med_availmap_nobs.pdf'];;
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk', '-bestfit')

