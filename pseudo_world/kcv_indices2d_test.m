function [Xcv, cv_in, cv_out] = kcv_indices2d(X,Kcv,box_dims)
%% kcv_indices2d.m
%inputs: X is the 2d data matrix, Kcv is the number of folds, box_dims is the dimensions of the checkerboard boxes
%outputs: Xcv contains the k-fold partitioned matrices, cv_in/out contain the indices 
[nr,nc] = size(X); Nx = numel(X);
Xind = reshape([1:Nx],nr,nc);

K = box_dims(1); %size of checkerboard rows
L = box_dims(2); %size of checkerboard columns
fK = floor(nr/K);
fL = floor(nc/L);

%figure out dimensions for checkerboard


%[rin,rout,nrin] = kcv_indices([1:nr],Kcv);
%[cin,cout,ncin] = kcv_indices([1:nc],Kcv);

for k = 1:Kcv
	nrout(k) = length(rout{k});
	ncout(k) = length(cout{k});
end

%create checkerboard
Xc = mat2cell(Xind,nrout,ncout); Nxc = numel(Xc); %work on this
[nrows,ncols] = size(Xc);

%Xcr = reshape(Xc,1,Nxc); %flatten into vector
%for n = 1:Nxc
%	Xcrl{n} = reshape(Xcr{n},1,numel(Xcr{n})); %flatten cell content into vectors
%end


%select checkerboard boxes in/out
%all_rows = [1:Kcv];
%used_rows = zeros(Kcv,ncols);

%counter = 0;
%while counter < numel(used_rows);
%	for k = 1:Kcv
%	for j = 1:ncols
%	if j == 1
%	last_choice = [];
%	end
%	possible_rows = setdiff(all_rows,last_choice);
%	possible_rows = setdiff(possible_rows,used_rows(:,j));
%	if ismember(last_choice,used_rows(:,j)) == 1
%	counter = 0;
%	else
%	counter = counter + 1;
%	end
%		
%	select_out_row = datasample(possible_rows,1);
%	last_choice = select_out_row;
%	used_rows(k,j) = select_out_row;
%	end	
%	end
%end

used_rows = kcv_indices2d_part2(Kcv,ncols);

%translate used_rows
for k = 1:Kcv
	used_rows_trans{k} = zeros(ncols,2); %preallocate
end
for k = 1:Kcv
	for n = 1:ncols
	used_rows_trans{k}(n,1) = used_rows(k,n); %row index
	used_rows_trans{k}(n,2) = n; %column index
	end
end
rows_t = used_rows_trans;

for k = 1:Kcv
	for n = 1:ncols
	row_choice = double(rows_t{k}(n,1));
	out_messy = Xc{row_choice,n};
	out_rows_flat{k,n} = reshape(out_messy,1,numel(out_messy));
	end
end

	
for k = 1:Kcv
	out_rows_flat_all{k} = horzcat(out_rows_flat{k,:});
	out_flat{k} = out_rows_flat_all{k};
	Xcv_flat{k} = reshape(X,1,Nx);
	Xcv_flat{k}(out_flat{k}) = NaN;
	Xcv{k} = reshape(Xcv_flat{k},nr,nc);
	cv_in{k} = ~isnan(Xcv{k});
	cv_out{k} = isnan(Xcv{k});
end

%End portion of original version below
%Kcvind = [1:Nxc];
%[in,out,nin] = kcv_indices(Kcvind,Kcv);

%for k = 1:Kcv
%	Fout{k} = horzcat(Xcrl{out{k}});
%	Xcv_flat{k} = reshape(X,1,Nx);
%	Xcv_flat{k}(Fout{k}) = NaN;
%	Xcv{k} = reshape(Xcv_flat{k},nr,nc);
%	cv_in{k} = ~isnan(Xcv{k});
%	cv_out{k} = isnan(Xcv{k});
%end

%% Visualize results
%for k = 1:Kcv
%pcolor(Xcv{k});
%pause
%end

