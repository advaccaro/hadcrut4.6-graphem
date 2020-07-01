function [V] = smart_partition_size(N,K)
%N number of elements in vector to be partitioned
%K approximate desired size of partitions (K is the MAXIMUM)
%V vector containing sizes of partitions
%Note: this is not reliable for cases where K is close to N
% (i.e., w/ small N and large K)

fK0 = floor(N/K); fK = fK0;
rK0 = N - (fK * K); rK = rK0;

if (fK0 * K) == N & rK0 == 0
	%Sr = 1;
	%create V and assign values
	V = zeros(1,fK);
	for k = 1:fK
	V(k) = K;
	end
else
	Sr = 0;
	nK = fK + 1;
	dK = K - 1;
	V = zeros(1,nK); n = 1; m = 0;
	while Sr == 0	
	V(1:nK - n)= K;
	if m == nK
	dK = dK - 1;
	n = 1; m = 0;
	end


	V(end-m:end) = dK;
	n = n + 1; m = m + 1;	
	if n == fK
	dK = dK - 1;
	n = 1; m = 0;
	end
	if sum(V) == N
	Sr = 1;
	end
	end
end
		


%Sr = 0;
	%while Sr == 0
%	fK = fK + 1;
%	rK = K - 1;
%	V = zeros(1,fK);
%	X = mod(N,fK);
%	V(1:X) = K;
%	XK = X * K;
%	dXK = N - XK;
%	Y = mod(dXK,fK);
%	V(end-Y:end) = rK;
%	if sum(V) == N
%	Sr = 1;
%	else
	
%	end
%	end
%end


	%V = zeros(1,fK + 1);
	%for k = 1:fK
	%V(k) = K;
	%V(end) = rK;
	%end
%end




%	Sr = 0;
%	while Sr == 0
%	while abs(rK) < K + 1 & abs(rK) > 0 
%	fK = fK - 1;
%	rK = N - (fK * K);
%	if ((fK * K) + rK) == N
%	Sr = 1;
%	end
%	end
%	end
	%create V and assign values
%	V = zeros(1,fK + 1);

%	for k = 1:fK
%	V(k) = K;
%	end
%	V(end) = rK;
%end	
