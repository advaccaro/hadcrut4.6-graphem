%checkerboard_testscript.m
X = randn(203,331); Kcv = 10;

[nr,nc] = size(X); Nx = numel(X);
Xind = reshape([1:Nx],nr,nc);

[nrout ncout] = smart_box_size(nr, nc, [5 5]);
%[rin,rout,nrin] = kcv_indices([1:nr],Kcv);
%[cin,cout,ncin] = kcv_indices([1:nc],Kcv);

%for k = 1:Kcv
%	nrout(k) = length(rout{k});
%	ncout(k) = length(cout{k});
%end

%create checkerboard
Xc = mat2cell(Xind,nrout,ncout); Nxc = numel(Xc);
[nrows,ncols] = size(Xc);

used_points = checkerboard(nrows,ncols,Kcv);
save('checkerboard.mat','used_points')

