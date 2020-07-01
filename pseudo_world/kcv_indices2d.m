function [Xcv, cv_in, cv_out] = kcv_indices2d(X,Kcv)
%% kcv_indices2d.m
%inputs: X is the 2d data matrix, Kcv is the number of folds
%outputs: Xcv contains the k-fold partitioned matrices, cv_in/out contain the indices 

%nargs = nargin(kcv_indices2d);
%if nargs < 3
%	vis = 0;
%end

[nr,nc] = size(X); Nx = numel(X);
Xind = reshape([1:Nx],nr,nc);

row_size = nr/Kcv; floor_row_size = floor(row_size);

if row_size > floor_row_size
	row_size = floor_row_size + 1;
end
	


[nrout ncout] = smart_box_size(nr, nc, [row_size 5]);

%create checkerboard
Xc = mat2cell(Xind,nrout,ncout); Nxc = numel(Xc);
[nrows,ncols] = size(Xc);

for i = 1:nrows
	for j = 1:ncols
	Xc_flat{i,j} = reshape(Xc{i,j},1,numel(Xc{i,j}));
	end
end


%select checkerboard boxes in/out
used_rows = checkerboard3(nrows,ncols,Kcv);



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


%if vis == 1
	%% Visualize results
	%for k = 1:Kcv
	%pcolor(Xcv{k});
	%pause
	%end
%end
