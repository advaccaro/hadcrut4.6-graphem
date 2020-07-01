function [nrout ncout] = smart_box_size(nr, nc, box_dims)

K = box_dims(1); L = box_dims(2);
nrout = smart_partition_size(nr,K);
ncout = smart_partition_size(nc,L);










%% first rows (K)
%K = box_dims(1);
%fK0 = floor(nr/K); fK = fK0;
%rK0 = nr - (fK * K); rK = rK0;

%if (fK * K) == nr & rK == 0
	%Sr = 1;
%	nrout = zeros(1,fK);
%	for k = 1:fK
%	nrout(k) = K;
%	end
%else
%	Sr = 0;
%	while Sr == 0
%	while abs(rK) < K + 1 & abs(rK) > 0 
%	fK = fK - 1;
%	rK = nr - (fK * K);
%	if ((fK * K) + rK) == nr
%	Sr = 1;
%	end
%	end
%	end
%	%create nrout and assign values
%	nrout = zeros(1,fK + 1);

%	for k = 1:fK
%	nrout(k) = K;
%	end

%	nrout(end) = rK;
%end	


%% then do the same for columns (L)
%L = box_dims(2);
%fL0 = floor(nc/L); fL = fL0;
%rL0 = nc - (fL * L); rL = rL0;

%if (fL * L)  == nc & rL == 0
	%Sc = 1;
%	ncout = zeros(1,fL);
%	for l = 1:fL
%	ncout(l) = L;
%	end
%else
%	Sc = 0;


%	while Sc == 0 
%	while abs(rL) < L + 1 & abs(rL) > 0
%	fL = fL - 1;
%	rL = nc - (fL * L);
%	if ((fL * L) + rL) == nc
%	Sc = 1;
%	end
%	end
%	end

%	%create ncout and assign values
%	ncout = zeros(1,fL + 1);

%	for l = 1:fL
%	ncout(l) = L;
%	end

%	ncout(end) = rL;
%end
