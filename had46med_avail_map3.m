%had46med_avail_map3.m
clear all

addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'))
%includes greatCircleDistance.m from GraphEM directory


%load data sets
load('had46med.mat')
load('hadsst3nobs.mat')
load('crutem4nobs.mat')

%bar graph w/ calculations
[ntime,nstations] = size(rawH46med);

%initialize array for areas per lat/lon
areas = zeros(nstations,1);

% Calculate area of each 5 degree lat-lon rectangle
for i = 1:nstations
	lat_center = loc(i,2);
	lon_center = loc(i,1);
	lat1 = lat_center-2.5;
	lat2 = lat_center+2.5;
	lon1 = lon_center-2.5;
	lon2 = lon_center+2.5;
	areas(i) = ((pi/180)*6371^2)*abs(sind(lat1)-sind(lat2))*abs(lon1-lon2);
end

% Surface area of the Earth in km2
surface_area = sum(areas);

%initialize array for area covered per year
area_covered = zeros(ntime,1);
per_area_covered=zeros(ntime,1);
for i = 1:ntime
	yd = rawH46med(i,:);
	nn = ~isnan(yd);
	area_covered(i) = sum(areas(nn));
	per_area_covered(i) = 100*area_covered(i)/surface_area;
end


fig('nobs map'); clf;
%orient landscape
subplot(3,2,5:6); hold on;
p = plot(H46med.tfrac, per_area_covered);
set(p, 'LineWidth', 1);
axis([1850 2018 0 100])
title('HadCRUT4.6 sampling over time');
xlabel('Time (Year)'); ylabel('% of global area')
set(gca,'TickDir', 'out', 'TickLength', [.02 .02]);
set(gca, 'XTick', 1850:25:2000);
set(gca, 'YTick',0:25:100);
set(gca, 'XMinorTick', 'on');
hL = legend('% of global area sampled');
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
titles{1} = {'HadCRUT4.6 sampling per month',
 'January 1850'}; 
titles{2} = 'January 1900'; 
titles{3} = 'January 1950'; 
titles{4} = 'January 2000';


lon = H46med.lon;
lat = H46med.lat;


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



odir = '/home/geovault-02/avaccaro/hadcrut4.6-graphem/figs/';
otagf = [odir 'had46med_availmap_coverage.jpeg'];
otag = [odir 'had46med_availmap_coverage.pdf'];;
print(otagf, '-djpeg', '-cmyk', '-r500')
print(otag, '-dpdf', '-cmyk', '-bestfit')
