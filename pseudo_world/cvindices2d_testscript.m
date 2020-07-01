%cvindices2d_testscript.m
%caculate CV indices in a 2D space
Kcv = 10; %number of KCV folds
X = randn(1852,1335); %non-square test matrix
[nr,nc] = size(X); Nx = numel(X);
Xind = reshape([1:Nx],nr,nc);

[rin,rout,nrin] = kcv_indices([1:nr],Kcv);
[cin,cout,ncin] = kcv_indices([1:nc],Kcv);

for k = 1:Kcv
	nrout(k) = length(rout{k});
	ncout(k) = length(cout{k});
end

Xc = mat2cell(Xind,nrout,ncout);
%[nc,pc] = size(Xc); 
Nxc = numel(Xc);
Xcr = reshape(Xc,1,Nxc); Nxcr = numel(Xcr{1}); 

for n = 1:Nxc
	Xcrl{n} = reshape(Xcr{n},1,numel(Xcr{n}));
end

Kcvind = [1:Nxc];
[in,out,nin] = kcv_indices(Kcvind,Kcv);

for k = 1:Kcv
	Fout{k} = horzcat(Xcrl{out{k}});
end



%for k = 1:Kcv
%	nout = length(out{k});
%	Fout{k} = zeros(1,(nf*pf)/Kcv);
%	for n = 1:nout
%	Fout{k}(1+(n-1)*Nxcr:Nxcr*n) = Xcrl{out{k}(n)};
%	end
%end

for k = 1:Kcv
	Xcv_flat{k} = reshape(X,1,Nx);
	Xcv_flat{k}(Fout{k}) = NaN;
	Xcv{k} = reshape(Xcv_flat{k},nr,nc);
end

%Visualize results
for k = 1:Kcv
pcolor(Xcv{k});
pause
end






%Nrin = cell2mat(nrin)'; Ncin = cell2mat(ncin)';

%nf = floor(n/Kcv); pf = floor(p/Kcv);

%Xsq = zeros(Kcv*nf,Kcv*pf);
%[nsq,psq] = size(Xsq); Nxsq = numel(Xsq);
%Xsq = X(1:nsq,1:psq);
%Xsqind = reshape([1:Nxsq],nsq,psq);

%N = nf*ones(1,Kcv); %define this explicitly in function input
%P = pf*ones(1,Kcv); %define this explicitly
%Xc = mat2cell(Xsqind,N,P);


