file = csvread('NOAA_NCEI.csv', 5,0); %reads in csv file

time_str = num2str(file(:,1));
nt = length(time_str);



%Stores data into a vector
for i = 1:nt
year = str2num(time_str(i, 1:4));
month = str2num(time_str(i,5:6));
tm(i) = datenum(year, month, 15);
tfrac(i) = year + (month-1)/12;
mon(i) = month; 
end
tm = tm(:);

monthlydata = file(:,2);
GMMT = monthlydata(:); %(:) forces it to save into a column vector

NOAA.tm = tm;
NOAA.GMTm = GMMT(:);
NOAA.tfrac = tfrac(:);
NOAA.mon = mon(:);
save('NOAA.mat', 'NOAA')
