clear all; load JEG_graphics
a = cfdataset('HadSST3_median.nc')
time = double(a.data('time')); %'days since 1850-1-1 0:0:0'
a.attributes('time');
lon = double(a.data('longitude'));
lat = double(a.data('latitude'));
sst = double(a.data('sst'));
[nt, ny, nx]= size(sst);

% Number of observations
b = cfdataset('number_of_observations.nc');
nobs = double(b.data('nobs'));
% flip latitude from south to north
lat = flipud(lat);
%sst = flipdim(sst,2); 
%nobs = flipdim(nobs,2);

%
lon_west = lon(lon<0) + 360;
lon_east = lon(lon>=0);
lon360 = [lon_east' lon_west']';
nobs_e = nobs(:,:,find(lon>0));
nobs_w = nobs(:,:,find(lon<0));
nobs360 = cat(3,nobs_e,nobs_w);
sst_e = sst(:,:,find(lon>0));
sst_w = sst(:,:,find(lon<0));
sst360 = cat(3,sst_e,sst_w);



% Uniformize time grid
tnum  = time + datenum(1850,1,1);
[year,month,day,hour,~,~] = datevec(tnum);
tstr  = datestr(tnum);
day(:) = 15; % assign 15th of the month
hour(:) = 12;


fig('Ship tracks'); clf
orient landscape
yearc = [2000 1950 1925 1900 1875 1850];

for k=1:length(yearc)
	ind=find(year==yearc(k) & month==1);
	tmp =sq(nobs360(ind,:,:));
	subplot(3,2,k)
   m_proj('Robinson','clong',170,'lat',[-82.5,82.5]);
	h = m_pcolor(lon360,lat,log10(tmp)), caxis([0,log10(500)]);
   set(h,'edgecolor','none'); hold on
   m_coast('patch',ligr); 
   m_grid('box','off','xtick',9,'ytick',6,'xlabeldir','end','xticklabels',[],'yticklabels',[]);
   hc = colorbar2('horiz');
   L = [2 5 10 25 50 100 250 500];
   l = log10(L);
	set(hc,'Xtick',l,'XTicklabel',L);
   title(['HadSST3: # of observations in Jan ', num2str(yearc(k))],style_t{:}); 
end
hepta_figprint('HadSST3_availability',300)

% Map anomalies
fig('Anomalies'); clf
orient landscape
yearc = [2000 1950 1925 1900 1875 1850];
for k=1:length(yearc)
	ind=find(year==yearc(k) & month==1)
	tmp =sq(sst360(ind,:,:));
	subplot(3,2,k)
   m_proj('Robinson','clong',170,'lat',[-82.5,82.5]);
	h = m_pcolor(lon360,lat,tmp), caxis([-3,3]);
   colormap(cejulien2(21))
   set(h,'edgecolor','none'); hold on
   m_coast('patch',ligr); 
   m_grid('box','off','xtick',9,'ytick',6,'xlabeldir','end','xticklabels',[],'yticklabels',[]);
   hc = colorbar2('horiz');
   title(['HadSST3: SST in Jan ', num2str(yearc(k))],style_t{:}); 
end
hepta_figprint('HadSST3_anomalies',300)

