function [used_points] = checkerboard(nrows,ncols,Kcv) %,Xc)

%select checkerboard boxes in/out
%all_rows = [1:nrows];
%used_rows = repmat(NaN,nrows,ncols);
nel = nrows*ncols;
Knel = (nel/Kcv); fKnel = floor(Knel);
nelV = zeros(1,Kcv);
set(0,'RecursionLimit',50);
if fKnel < Knel
	nelVf = nel - (Kcv-1) * fKnel;
	nelV(1:end-1) = fKnel;
	nelV(end) = nelVf;
elseif fKnel == Knel
	nelV(:) = fKnel;
end
all_pointsV = [1:nel]; %indices of each point in checkerboard
%all_pointsVc = cell(1,nel);
all_pointsM = reshape(all_pointsV,nrows,ncols);
%top_row = all_pointsM(1,2:end-1); bot_row = all_pointsM(end,2:end-1);
%left_col = all_pointsM(2:end-1,1); right_col = all_pointsM(2:end-1,end);
%topleft = all_pointsM(1,1); topright = all_pointsM(1,end);
%botleft = all_pointsM(end,1); botright = all_pointsM(end,end);
%all_pointsMc = cell(nrows,ncols);
for i = 1:nrows
	for j = 1:ncols
	all_pointsMc{i,j} = [i j];
	end
end
all_pointsVc = reshape(all_pointsMc,1,nel);
nel_sel = zeros(1,Kcv);
all_points_sel = cell(0,0);

for k = 1:Kcv
	%points_sel{k} = cell(1,nelV(k));
	points_sel{k} = nan(1,nelV(k));
	off_limits = cell(0,0);
	
	n = 1;
	while nel_sel(k) < nelV(k)
	%points_left = setdiff([all_pointsM{:}],[all_points_sel{:,:}]);
	points_left1 = setdiff(all_pointsM, [all_points_sel{:}]);	
	points_left2 = setdiff(points_left1, [off_limits{:}]);
	if isempty(points_left2) == 1
	break;
	%clear all_points_sel points_left1 points_left2 off_limits; 
	[used_points] = checkerboard(nrows,ncols,Kcv);
	%break;	
	end	
	selection = points_left2(randi(numel(points_left2)));
	points_sel{k}(n) = selection;
	all_points_sel{end+1} = selection;
	
	
	%identify neighbors
	[neighs,nneigh] = checkerboard_neighbors2(all_pointsM,selection);
	for i = 1:nneigh
	off_limits{end+1} = neighs(i);
	end	
	%clear points_left1 points_left2
	n = n + 1; nel_sel(k) = nel_sel(k) + 1;
	end
end
	
%check for pesky NaNs and rerun if necessary
for k = 1:Kcv
	nfinel = sum(isfinite(points_sel{k}(:)));
	if nfinel < nelV(k)
	clear points_sel points_left1 points_left2;
	[used_points] = checkerboard(nrows,ncols,Kcv);
	end
end

used_points = points_sel;

%[nrout ncout] = smart_box_size(nrows, ncols, [1 1])
%% OLD VERSION BELOW
%for k = 1:nrows
%	for j = 1:ncols
%	if j == 1
%	last_choice = [];
%	end
%	possible_rows = setdiff(all_rows,last_choice);
%	possible_rows = setdiff(possible_rows,used_rows(:,j));
%	%check for bad case and rerun if necessary
%	if isempty(possible_rows) == 1
%	break; 
%	clear used_rows;
%	[used_rows] = checkerboard(nrows,ncols);
%	end
%	select_out_row = datasample(possible_rows,1);
%	last_choice = select_out_row;
%	used_rows(k,j) = select_out_row;
%	end	
%end
%check for pesky NaNs and rerun if necessary
%if sum(sum(isfinite(used_rows))) < numel(used_rows)
%	clear used_rows;
%	[used_rows] = checkerboard(nrows,ncols);
%end


