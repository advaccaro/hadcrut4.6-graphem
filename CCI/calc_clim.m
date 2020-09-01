function clim = calc_clim(data2d)
	% assumes data2d starts in january
	% assumes data2d is: time x space

	[nt, ns] = size(data2d);
	clim = zeros(12,ns);
	step_full = 12*[0:1:ceil(nt/12)-1]; %jump 12 months at a time
	step_partial = step_full(1:end-1);

	if (mod(nt,12) ~= 0) %if there are incomplete years
		% treat full years
		step = step_full;
		for month = 1:mod(nt,12)
			T_ind = month + step;
			tmp = squeeze(data2d(T_ind,:));
			clim(month,:) = nmean(tmp,1);
		end
		% treat partial years
		step = step_partial;
		for month = mod(nt,12)+1:12
			T_ind = month + step;
			tmp = squeeze(data2d(T_ind,:));
			clim(month,:,:) = nmean(tmp,1);
		end
	else
		for month = 1:12
			T_ind = month + step_full;
			tmp = squeeze(data2d(T_ind,:));
			clim(month,:) = nmean(tmp,1);
		end
	end
end
