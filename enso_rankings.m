%enso_rankings.m

working_dir = '/home/geovault-02/avaccaro/hadCRUT4.6/';
addpath(genpath(working_dir))

%Load NINO indices
load_nino_datasets

%Rename for convenience
R = H46MED_EXP; %Raw
DATA(1).X = R;
DATA(1).title = 'Raw HadCRUT4.6 median';
DATA(1).abr = 'Raw HadCRUT4.6';    
G = H46M80_EXP; %GraphEM GLASSO 0.8 Sparsity
DATA(2).X = G;
DATA(2).title = 'HadCRUT4.6 median GraphEM 0.8 sparsity';
DATA(2).abr = 'GraphEM';
CW = C46MED_EXP; %Cowtan and Way
DATA(3).X = CW;
DATA(3).title = 'HadCRUT4.6 median Cowtan & Way';
DATA(3).abr = 'Cowtan & Way';
C = COBE_NINO; % COBE SST2
DATA(4).X = C;
DATA(4).title = 'COBE SST2';
DATA(4).abr = 'COBE';
B = BUNGE_NINO; % Bunge & Clarke
DATA(5).X = B;
DATA(5).title = 'Bunge and Clarke';
DATA(5).abr = 'Bunge';
E = ERSSTv5_NINO; %ERSSTv5
DATA(6).X = E;
DATA(6).title = 'ERSSTv5';
DATA(6).abr = 'ERSSTv5';
K = Kext_NINO; % Kaplan Extended
DATA(7).X = K;
DATA(7).title = 'Kaplan Extended';
DATA(7).abr = 'Kaplan';
% explore top years across each dataset
for j = 1:length(DATA)
	X = DATA(j).X;
	top10 = maxk(X.NINO34a_yr, 10);
	for k = 1:10
		top10ind(k) = find(X.NINO34a_yr == top10(k));
		if k == 10
			disp(DATA(j).title)
			top10;
			top10years = X.ta_yr(top10ind);
			disp(top10years)
			sorted_top10years = sort(top10years);
			%disp(sorted_top10years)
		end
	end
end



%somewhat arbitrarily chosen years:
years = [1877 1888 1902 1905 1941 1972 1982 1987 1997 2015];
nyears = length(years);
YearStr = ['1877', '1888', '1902', '1905', '1941', '1972', '1982', '1997', '2015'];

for k = 1:nyears
	year = years(k);
	for j = 1:length(DATA)
		name_str(j) = DATA(j).abr;
		X = DATA(j).X;
		year_ind = find(X.ta_yr == year);
		NINO_val(j) = X.NINO34a_yr(year_ind);
		if j == length(DATA)
			sorted_NINO = fliplr(sort(NINO_val));
			col(1:j,1) = sorted_NINO;
			for x = 1:j
				rev_ind = find(NINO_val == sorted_NINO(x));
				col(x,2) =  DATA(rev_ind).abr;
			end
		end
	end
	COL(k).YearStr = YearStr(k);
	COL(k).col = col;
end
	
		
		
		%table_str = [name_str '(' num2str(NINO_val) ')'];
		%T(j,k) = table_str
		
		


