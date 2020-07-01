function [Xcv, cv_in, cv_out] = kcv_indices2d(X,Kcv)
%% kcv_indices2d.m (doesn't ensure no two blocks are from the same column (spatial location))
%inputs: X is the 2d data matrix, Kcv is the number of folds
%outputs: Xcv contains the k-fold partitioned matrices, cv_in/out contain the indices 
[nr,nc] = size(X); Nx = numel(X);
Xind = reshape([1:Nx],nr,nc);

[rin,rout,nrin] = kcv_indices([1:nr],Kcv);
[cin,cout,ncin] = kcv_indices([1:nc],Kcv);

for k = 1:Kcv
	nrout(k) = length(rout{k});
	ncout(k) = length(cout{k});
end

Xc = mat2cell(Xind,nrout,ncout); Nxc = numel(Xc);
Xcr = reshape(Xc,1,Nxc); 

for n = 1:Nxc
	Xcrl{n} = reshape(Xcr{n},1,numel(Xcr{n}));
end

Kcvind = [1:Nxc];
[in,out,nin] = kcv_indices(Kcvind,Kcv);

for k = 1:Kcv
	Fout{k} = horzcat(Xcrl{out{k}});
	Xcv_flat{k} = reshape(X,1,Nx);
	Xcv_flat{k}(Fout{k}) = NaN;
	Xcv{k} = reshape(Xcv_flat{k},nr,nc);
	cv_in{k} = ~isnan(Xcv{k});
	cv_out{k} = isnan(Xcv{k});
end

%% Visualize results
%for k = 1:Kcv
%pcolor(Xcv{k});
%pause
%end

