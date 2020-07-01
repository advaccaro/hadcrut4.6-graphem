function [used_rows] = checkerboard3(nrows,ncols,Kcv)

all_rows = [1:nrows]; 
used_rows = nan(nrows,ncols);
offlimits = cell(1,ncols+3);

%DO FIRST FOLD USING RANDOM SAMPLING W/ "NO NEIGHBOR" RULE
for j = 1:ncols
	%if j == 1
		%last_choice = [];
		%prev_choice = [];
	%elseif j == ncols
	%	last_choice = [last_choice used_rows(1,1)];
	%end
	possible_rows = setdiff(all_rows,offlimits{j});	
	%possible_rows = setdiff(all_rows, last_choice);
	%possible_rows = setdiff(possible_rows, prev_choice);
	%possible_rows = setdiff(possible_rows,used_rows(:,j)
	if isempty(possible_rows) == 1
		break;
		clear used_rows;
		[used_rows] = checkerboard3(nrows,ncols,Kcv);
	end
	select_out_row = datasample(possible_rows,1);
		if select_out_row == 1
			offlimits{j+1} = [offlimits{j+1} 1 2 nrows];
			offlimits{j+2} = [offlimits{j+2} 1];
			offlimits{j+3} = [offlimits{j+3} 1];
		elseif select_out_row == nrows
			offlimits{j+1} = [offlimits{j+1} 1 nrows-1 nrows];
			offlimits{j+2} = [offlimits{j+2} nrows];
			offlimits{j+3} = [offlimits{j+3} nrows];
		%elseif select_out_row == nrows 
			%offlimits{j+1} = [offlimits{j+1} select_out_row - 1:select_out_row + 1];
			
		elseif select_out_row < nrows  & select_out_row > 1
			offlimits{j+1} = [offlimits{j+1} select_out_row - 1:select_out_row + 1];
			offlimits{j+2} = [offlimits{j+2} select_out_row];
			offlimits{j+3} = [offlimits{j+3} select_out_row];
		end
	
	%last_choice = select_out_row;
	used_rows(1,j) = select_out_row;
end





%DO REMAINING FOLDS USING "MARCHING" METHOD
for k = 2:nrows
	for j = 1:ncols
		entry = mod(used_rows(k-1,j) + 1, Kcv);
		if entry == 0
			entry = Kcv;
		end
		used_rows(k,j) = entry;
	end
end


%check for pesky NaNs and rerun if necessary
if sum(sum(isfinite(used_rows))) < numel(used_rows)
	clear used_rows;
	[used_rows] = checkerboard3(nrows,ncols,Kcv);
end
