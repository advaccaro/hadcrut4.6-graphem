function xk = cw_krig(tobs, tfrac, dist)
	[ntime, nlat, nlon] = size(tobs);
	tmap0 = reshape(tobs(1,:,:), [nlat, nlon]);

	% calculate area weights
	w = prepare_areas(tmap0);

	% covariance matrix
	cov = prepare_cov(tmap0, dist);

	% interpolate
	results = {};
	for i = 1:ntime
		tmap = reshape(tobs(i,:,:), [nlat, nlon]);
		result = interpolate(tmap, cov);
		results{i} = result;
		keyboard;
	end
end
	% calculate temperatures
	% read data
	% tobs, time = read_data(data)
	% t2m = read_rean(rean)
	% ncidin = netcdf.open(nc_path);

	% % calculate uncorrelated error map
	% rng(1)
	% mobs = tfrac > 1981 & tfrac < 2011;
	% tobsm = tobs(mobs,:,:);
	% % baseline
	% for m = 1:12
	% 	norm = nmean(tobsm(m:12:end,:,:), 1);
	% 	tobsm(m:12:end,:,:) = tobsm(m:12:end,:,:) - norm;
	% end
	% % means
	% tobsm0 = reshape(tobsm(1,:,:), [nlon, nlat])
	% cov1000 = prepare_cov(tobsm0, 1000);
	% tave = nans(size(tobsm));
	% ncross = 5;
	% for f1 = 1:ncross
	% 	for f2 1 = 1:ncross
	% 		mskx = ones(size(tobs(1,:,:))) < 0;
	% 		mskk = ones(size(tobs(1,:,:))) < 0;
	% 		for i = 1:size(mskx,1)
	% 			for j = 1:size(mskx,2)
	% 				if mod(i+f1-1, ncross) <= 2 & mod(j+f2-1, ncross) <= 2
	% 					mskx(i,j) = true;
	% 				end
	% 				if mod(i+f1-1, ncross) == 11 & mod(j+f2-2, ncross) == 1
	% 					mskk(i,j) = true;
	% 				end
	% 			end
	% 		end
	% 		for m = 1:size(tobsm,1)
	% 			tmon = tobsm(m,:,:);
	% 			tmon[mskx] = NaN;
	% 			tmon = interpolate(tmon, cov1000);
	% 			tave(m,mskk) = tmon(mskk);
	% 		end
	% 	end
	% end
	% % mask to cells which are all present
	% diff = tobsm-tave;
	% sd = nan(size(diff(1,:,:)));
	% for i = 1:size(diff,1)
	% 	for j = 1:size(diff,2)
	% 		if sum(~isnan(diff(:,i,j))) >= 60
	% 			sd(i,j) = sqrt(nmean(square(diff(:,i,j))));
	% 		end
	% 	end
	% end
	% % short cut for quick testing
	% if ncross == 0
	% 	sd = max(0.5*nstd(tobsm,1),.01);
	% end
	% % truncate outliers
	% smax = percentile(sd(~isnan(sd)), 99.0);
	% sd = min(sd, smax);
	% % and infill
	% sd = interpolate(sd, cov1000);
	% % calculate std map
	% % e2m =
	%




function weights = prepare_areas(tmap)
		w = zeros(size(tmap));
		[ny,nx] = size(tmap);
		for i = 1:ny
			w(i,:) =  sind(180.0*i/ny-90.0) - sind(180.0*(i-1)/ny-90.0);
		end
		weights = w/sum(sum(w));
	end

function y = clip(x,bl,bu)
  % return bounded value clipped between bl and bu
  y=min(max(x,bl),bu);
end

% prepare a list of intercell distances for flattened maps
function cov = prepare_cov(tmap, dist) %dist = 1000
	[nlat, nlon] = size(tmap);
	xs = deg2rad( ((0:nlat-1)+.5)*180/nlat-90.0);
	ys = deg2rad( ((0:nlon-1)+.5)*360/nlon-180.0);
	las = repelem(xs,len(ys));
	lns = repmat(ys, [1 length(xs)]);
	dists = zeros(numel(tmap), numel(tmap));
	for i = 1:numel(tmap)
	    dists(i,:) = 6371.0*acos( clip( sin(las(i))*sin(las) + cos(las(i)).*cos(las).*cos(lns(i)-lns), -1.0, 1.0 ) );
	end
	cov = exp(-dists/dist);
end

function flattened = flatten(fatten)
	flattened = reshape(fatten.',1,[]);
end

function result = interpolate(tmap, cov)
	keyboard;
	% set up matrices
	data = flatten(tmap);
	unobsflag = isnan(data);
	obsflag = ~isnan(data);
	tmp = cov(obsflag,:);
	a = tmp(:,obsflag);
	b = tmp(:,unobsflag);
	c = data(obsflag);
	a = vertcat( horzcat(a, ones(size(a,1), 1)), horzcat(ones(1, size(a,2)), 0)	);
	b = vertcat(b, ones(1,size(b,2)));
	c = horzcat(c, zeros(1));
	%solve for basis function weights
	x = linsolve(a,b);
	% calculate temperatures and store
	t = dot(c,x);
	result = data;
	result(unobsflag) = t;
	result = reshape(result, size(tmap)); %CHECK THIS RESHAPE
end

function r = rms(x)
	r = sqrt(mean(square(x)));;
end

function tn = gta1(t, cov)
	data = flatten(t);
	unobsflag = isnan(data);
	obsflag = ~(unobsflag);
	y = data(obsflag);
	w = cov(obsflag,:);
	w = w(:,obsflag);
	% Solve for gls mean
	wi = pinv(w);
	swi = sum(wi,1);
	tn = dot(swi,y)/sum(swi);
end
