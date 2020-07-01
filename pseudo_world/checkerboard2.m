function [used_boxes] = checkerboard2(nrows,ncols)

all_rows = [1:nrows]; 
used_rows = nan(nrows,ncols);



for k = 1:nrows
	for j = 1:ncols
	if j == 1
	last_choice = [];
	end
	possible_rows = setdiff(all_rows,last_choice);
	possible_rows = setdiff(possible_rows,used_rows(:,j));
	%check for bad case and rerun if necessary
	if isempty(possible_rows) == 1
	break; 
	clear used_rows;
	[used_rows] = checkerboard2(nrows,ncols,Kcv);
	end
	select_out_row = datasample(possible_rows,1);
	last_choice = select_out_row;
	used_rows(k,j) = select_out_row;
	end	
end
%check for pesky NaNs and rerun if necessary
if sum(sum(isfinite(used_rows))) < numel(used_rows)
	clear used_rows;
	[used_rows] = checkerboard2(nrows,ncols);
end
