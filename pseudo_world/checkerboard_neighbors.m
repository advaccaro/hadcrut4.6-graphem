function [neighbors,nneigh] = checkerboard_neighbors(all_pointsM,selection)
%checkerboard_neighbors.m


[nrows, ncols] = size(all_pointsM);

top_row = all_pointsM(1,2:end-1); bot_row = all_pointsM(end,2:end-1);
left_col = all_pointsM(2:end-1,1); right_col = all_pointsM(2:end-1,end);
topleft = all_pointsM(1,1); topright = all_pointsM(1,end);
botleft = all_pointsM(end,1); botright = all_pointsM(end,end);

%borders = [top_row bot_row left_col' right_col'];
border_rows = [top_row bot_row];
border_cols = [left_col' right_col'];
corners = [topright botright topleft botleft];

if ismember(selection,corners) == 1
	nneigh = 3;
	neighs = zeros(1,nneigh);
	if selection == topleft
	neighs(1) = selection + nrows;
	neighs(2) = selection + 1;
	neighs(3) = topright;
	elseif selection == botleft
	neighs(1) = selection + nrows;
	neighs(2) = selection - 1;
	neighs(3) = botright;
	elseif selection == topright
	neighs(1) = selection - nrows;
	neighs(2) = selection + 1;
	neighs(3) = topleft;
	elseif selection == botright
	neighs(1) = selection - nrows;
	neighs(2) = selection - 1;	
	neighs(3) = botleft;
	end
elseif ismember(selection,border_rows) == 1
	nneigh = 3;
	neighs = zeros(1,nneigh);
	if ismember(selection,top_row) == 1
	neighs(1) = selection - nrows;
	neighs(2) = selection + nrows;
	neighs(3) = selection + 1;
	elseif ismember(selection,bot_row) == 1
	neighs(1) = selection - nrows;
	neighs(2) = selection + nrows;
	neighs(3) = selection - 1;
	end
elseif ismember(selection,border_cols) == 1
	nneigh = 4;
	neighs = zeros(1,nneigh);	
	if ismember(selection,left_col) == 1
	neighs(1) = selection + nrows;
	neighs(2) = selection + 1;
	neighs(3) = selection - 1;
	neighs(4) = selection + (nrows * (ncols - 1));
	elseif ismember(selection,right_col) == 1
	neighs(1) = selection - nrows;
	neighs(2) = selection + 1;
	neighs(3) = selection - 1;
	neighs(4) = selection - (nrows * (ncols - 1));
	end
else 
	nneigh = 4;
	neighs = zeros(1,nneigh);
	neighs(1) = selection + nrows;
	neighs(2) = selection - nrows;
	neighs(3) = selection + 1;
	neighs(4) = selection - 1;
end

neighbors = neighs;
