file = csvread('GLB.Ts+dSST.csv', 2,0); %reads in csv file

years = file(:,1);
ny = length(years);

%Stores data into a vector
for i = 1:ny
tm(1+12*(i-1)) = datenum(['15-Jan' num2str(years(i))]);
tm(2+12*(i-1)) = datenum(['15-Feb' num2str(years(i))]);
tm(3+12*(i-1)) = datenum(['15-Mar' num2str(years(i))]);
tm(4+12*(i-1)) = datenum(['15-Apr' num2str(years(i))]);
tm(5+12*(i-1)) = datenum(['15-May' num2str(years(i))]);
tm(6+12*(i-1)) = datenum(['15-Jun' num2str(years(i))]);
tm(7+12*(i-1)) = datenum(['15-Jul' num2str(years(i))]);
tm(8+12*(i-1)) = datenum(['15-Aug' num2str(years(i))]);
tm(9+12*(i-1)) = datenum(['15-Sep' num2str(years(i))]);
tm(10+12*(i-1)) = datenum(['15-Oct' num2str(years(i))]);
tm(11+12*(i-1)) = datenum(['15-Nov' num2str(years(i))]);
tm(12+12*(i-1)) = datenum(['15-Dec' num2str(years(i))]);
end
tm = tm(:);

monthlydata = file(:,2:13);
GMMT = reshape(monthlydata.',1,numel(monthlydata));
GMMT = GMMT(:);

GISTEMP.tm = tm;
GISTEMP.GMTm = GMMT;
save('GISTEMP.mat', 'GISTEMP')
